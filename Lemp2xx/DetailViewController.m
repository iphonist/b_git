//
//  DetailViewController.m
//  LempMobile2
//
//  Created by Hyemin Kim on 12. 11. 15..
//  Copyright (c) 2012년 Adriaenssen BVBA. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TimeLineCell.h"
#import "PhotoViewController.h"
#import "PostViewController.h"
#import <objc/runtime.h>
#import "PhotoTableViewController.h"
#import "SendNoteViewController.h"
#import "WriteScheduleViewController.h"
#import "UIImage+Resize.h"
#import "PollMemberViewController.h"
#import "WebViewController.h"
#import "HorizontalCollectionViewLayout.h"
#import "SocialSearchViewController.h"
#import "UIImage+GIF.h"
//#import "UIImage+RoundedCorner.h"
//@implementation UITextView (DisableCopyPaste)
//
//- (BOOL)canBecomeFirstResponder
//{
//    return NO;
//}
//
//@end



#ifdef BearTalk
#define originReplyHeight 50.0f
#else
#define originReplyHeight 61.0f
#endif

#define PI 3.14159265358979323846
static inline float radians(double degrees) { return degrees * PI / 180; }

#if defined(GreenTalk) || defined(GreenTalkCustomer)
    #define MAX_MESSAGEEND_LINE 5

    static int g_viewSizeHeight[MAX_MESSAGEEND_LINE] = {originReplyHeight, originReplyHeight+19, originReplyHeight+19+19, originReplyHeight+19+19+19, originReplyHeight+19+19+19+19};
    static int g_areaSizeHeight[MAX_MESSAGEEND_LINE] = {originReplyHeight-16, originReplyHeight-16+19, originReplyHeight-16+19+19, originReplyHeight-16+19+19+19, originReplyHeight-16+19+19+19+19};
    static int g_textSizeHeight[MAX_MESSAGEEND_LINE] = {20, 20+19, 20+19+19, 20+19+19+19, 20+19+19+19+19};
#else

    #define MAX_MESSAGEEND_LINE 3

    static int g_viewSizeHeight[MAX_MESSAGEEND_LINE] = {originReplyHeight, originReplyHeight+19, originReplyHeight+19+19};
    static int g_areaSizeHeight[MAX_MESSAGEEND_LINE] = {originReplyHeight-16, originReplyHeight-16+19, originReplyHeight-16+19+19};
    static int g_textSizeHeight[MAX_MESSAGEEND_LINE] = {20, 20+19, 20 +19+19};
#endif



@interface DetailViewController ()

@end

const char paramDic;
const char paramNumber;
const char paramUrl;

@implementation DetailViewController

@synthesize replyTextView;
@synthesize contentsData;
@synthesize myTable;



- (id)init//WithViewCon:(UIViewController *)viewcon//NibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super init];//WithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //		parentViewCon = viewcon;
        //        NSLog(@"parentViewCon %@",parentViewCon);
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshProfiles)
                                                     name:@"refreshProfiles"
                                                   object:nil];
        
        //		self.hidesBottomBarWhenPushed = YES;
        isPhoto = NO;
        NSLog(@"isPhoto %@",isPhoto?@"YES":@"NO");
        self.moveTab = NO;
        self.popKeyboard = NO;
        viewReply = NO;
        
        if (self.parentViewCon == nil) {
            self.parentViewCon = SharedAppDelegate.root.home;
        }
    }
    return self;
}

- (void)refreshProfiles
{
    NSLog(@"refreshProfiles");
    [myTable reloadData];
}

- (void)arriveNewReply:(NSNotification*)noti
{
    NSLog(@"arriveNewReply %@",noti);
    
    if(noti) {
        NSDictionary *arriveInfo = [noti userInfo];
        NSLog(@"arriveNewReply idx %@",arriveInfo[@"cidx"]);
        if ([arriveInfo[@"cidx"] isEqualToString:contentsData.idx]) {
            [self getReply:YES];
        }
    }
}

- (void)dealloc
{
//    self.parentViewCon = nil;
//    [likeArray release];
//    [readArray release];
//    [replyArray release];
//    [groupArray release];
//    [myTable release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super dealloc];
}

- (void)setViewToReply{
    //    NSLog(@"setViewToReply %@",myTable);
    viewReply = YES;
}

- (void)backTo//:(id)sender
{
    
    NSLog(@"backTo");
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
    
    
    if (YES == self.moveTab) {
        NSInteger selectTabIndex;
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        if ([contentsData.contentType intValue] == 1) {
            selectTabIndex = kTabIndexSocial;
        } else {
            selectTabIndex = 999;
        }
        
        //        if (selectTabIndex < 999) {
        //            UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
        //            if (SharedAppDelegate.root.mainTabBar.selectedIndex != selectTabIndex) {
        //                if ([SharedAppDelegate.root.mainTabBar.tabBar isHidden]) {
        //                    [nv popToRootViewControllerWithBlockGestureAnimated:NO];
        //                }
        //                [SharedAppDelegate.root.mainTabBar setSelectedIndex:selectTabIndex];
        //                nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
        //
        //                if ([nv.viewControllers count] > 1) {
        //                    [nv popToRootViewControllerWithBlockGestureAnimated:NO];
        //                }
        //            }
        //
        //            if (selectTabIndex == kTabIndexMessage) {
        //                [SharedAppDelegate.root.note setReserveRefresh:YES];
        //                if ([SharedAppDelegate.root.mainTabBar.viewControllers count] > kTabIndexMessage) {
        //                    UINavigationController *naviCon = (UINavigationController*)[SharedAppDelegate.root.mainTabBar.viewControllers objectAtIndex:kTabIndexMessage];
        //                    if ([[naviCon viewControllers] count] > 0) {
        //                        MHTabBarController *subTab = (MHTabBarController*)[[naviCon viewControllers] objectAtIndex:0];
        //                        [subTab setSelectedIndex:kSubTabIndexNote];
        //
        //                        UINavigationController *subNaviCon = (UINavigationController*)subTab.selectedViewController.navigationController;
        //                        if ([[subNaviCon viewControllers] count] > 1) {
        //                            [subNaviCon popToRootViewControllerWithBlockGestureAnimated:NO];
        //                        }
        //                    }
        //                }
        //            }
        //        }
    } else {
        //        if ([contentsData.contentType intValue] == 7) {
        //            for (TimeLineCell *cellData in SharedAppDelegate.root.note.readList) {
        //                if ([cellData.idx isEqualToString:contentsData.idx]) {
        //                    NSMutableDictionary *modifyDic = [NSMutableDictionary dictionaryWithDictionary:[cellData.targetdic objectFromJSONString]];
        //                    [modifyDic setObject:@"1" forKey:@"read"];
        //                    cellData.targetdic = [modifyDic JSONString];
        //                    break;
        //                }
        //            }
        //        }
    }
#else
    
    if ([contentsData.contentType intValue] == 1) {
        selectTabIndex = kTabIndexSocial;
    } else if ([contentsData.contentType intValue] == 7) {
        selectTabIndex = kTabIndexMessage;
    } else if ([contentsData.contentType intValue] == 8 || [contentsData.contentType intValue] == 9){
        selectTabIndex = kTabIndexMe;
    } else {
        selectTabIndex = 999;
    }
    
    if (selectTabIndex < 999) {
        UINavigationController *nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
        if (SharedAppDelegate.root.mainTabBar.selectedIndex != selectTabIndex) {
            if ([SharedAppDelegate.root.mainTabBar.tabBar isHidden]) {
                [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
            }
            [SharedAppDelegate.root.mainTabBar setSelectedIndex:selectTabIndex];
            nv = (UINavigationController*)SharedAppDelegate.root.mainTabBar.selectedViewController;
            
            if ([nv.viewControllers count] > 1) {
                [(CBNavigationController *)nv popToRootViewControllerWithBlockGestureAnimated:NO];
            }
        }
        
        if (selectTabIndex == kTabIndexMessage) {
            [SharedAppDelegate.root.note setReserveRefresh:YES];
            if ([SharedAppDelegate.root.mainTabBar.viewControllers count] > kTabIndexMessage) {
                UINavigationController *naviCon = (UINavigationController*)[SharedAppDelegate.root.mainTabBar.viewControllers objectAtIndex:kTabIndexMessage];
                if ([[naviCon viewControllers] count] > 0) {
                    MHTabBarController *subTab = (MHTabBarController*)[[naviCon viewControllers] objectAtIndex:0];
                    [subTab setSelectedIndex:kSubTabIndexNote];
                    
                    UINavigationController *subNaviCon = (UINavigationController*)subTab.selectedViewController.navigationController;
                    if ([[subNaviCon viewControllers] count] > 1) {
                        [(CBNavigationController *)subNaviCon popToRootViewControllerWithBlockGestureAnimated:NO];
                    }
                }
            }
        }
    }
} else {
    if ([contentsData.contentType intValue] == 7) {
        for (TimeLineCell *cellData in SharedAppDelegate.root.note.readList) {
            if ([cellData.idx isEqualToString:contentsData.idx]) {
                NSMutableDictionary *modifyDic = [NSMutableDictionary dictionaryWithDictionary:[cellData.targetdic objectFromJSONString]];
                [modifyDic setObject:@"1" forKey:@"read"];
                cellData.targetdic = [modifyDic JSONString];
                break;
            }
        }
    }
}
#endif
if (self.presentingViewController && [self.navigationController.viewControllers count] == 1) {
    [self dismissViewControllerAnimated:YES completion:nil];
} else {
    [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
}





//    if(self.navigationItem.leftBarButtonItem.tag == kPush)
//    [self.navigationController popViewControllerWithBlockGestureAnimated:YES];
//    else if(self.navigationItem.leftBarButtonItem.tag == kModal)
//        [self dismissViewControllerAnimated:YES completion:nil];


//    if([parentViewCon isKindOfClass:[SharedAppDelegate.root.home class]])
//        [SharedAppDelegate.root.home getTimeline:@"" target:SharedAppDelegate.root.home.targetuid type:SharedAppDelegate.root.home.category groupnum:SharedAppDelegate.root.home.groupnum];
//    else
//        [parentViewCon getTimeline:[NSString stringWithFormat:@"%d",SharedAppDelegate.root.home.firstInteger]];
//    [sender setEnabled:YES];
}


#define kDeleteReply 100
#define kDeletePost 200
#define kCancelSchedule 300
#define kEndPoll 400
#define kPushEndPoll 500
#define kInstallHWP 600
#define kDeletePhoto 700
#define kShare 800
#define kAddNotice 900

#define kEdit 1
#define kGroup 2
#define kReply 3
#define kPhoto 4
#define kActionReply 5
#define kSelectShare 6
//#define kHWP 6

- (void)editPost
{
    NSLog(@"editPost");
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        UIAlertAction* cancel;
     
#ifdef MQM
        
#elif Batong
        
        if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
// written by me
            NSLog(@"1\n");
            
            if([contentsData.notice isEqualToString:@"1"]) {
                
                NSLog(@"2\n");
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"삭제"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [self deletePost];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
            }
            else{
                NSLog(@"3\n");
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"수정"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [self modifyPost];
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"삭제"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [self deletePost];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
            }
        }
        else{
            // not me
            NSLog(@"4\n");
            
            if([contentsData.writeinfoType isEqualToString:@"1"] && ![contentsData.sub_category isKindOfClass:[NSNull class]] && [contentsData.sub_category length]>1){
                if([[SharedAppDelegate readPlist:@"isCS"]isEqualToString:@"1"])// i am cs
                {
                    NSLog(@"5\n");
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"삭제"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        
                                        [self deletePost];
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    [view addAction:actionButton];
                }
            }
            
        }
        
        NSLog(@"6\n");
        
        
         cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
        
        return;
#endif
        if([contentsData.contentType isEqualToString:@"1"]) {
   

#ifdef MQM
            
                     if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        // 공유 이동 수정 삭제
   
                         
                        actionButton = [UIAlertAction
                                        actionWithTitle:@"수정"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            
                                            [self modifyPost];
                                            
                                            //Do some thing here
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
                        [view addAction:actionButton];
                        
                        actionButton = [UIAlertAction
                                        actionWithTitle:@"삭제"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            
                                            [self deletePost];
                                            
                                            //Do some thing here
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
                        [view addAction:actionButton];
                    }
                     else{
                        
                    }
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
            
            
            NSLog(@"7\n");
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"수정"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                [self modifyPost];
                                
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"삭제"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                
                                [self deletePost];
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
#else
            
#ifdef BearTalk
            NSLog(@"groupMaster %@",groupMaster);
            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                NSLog(@"noticeyn %@",noticeyn);
                NSString *addString = @"";
                if([noticeyn isEqualToString:@"Y"])
                    addString = @"해제";
                else
                    addString = @"등록";
                    
                actionButton = [UIAlertAction
                                actionWithTitle:[NSString stringWithFormat:@"소셜 공지 %@",addString]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                     [self confirmAddNotice];
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
               
            }
#endif
            
            if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
            if([contentsData.notice isEqualToString:@"1"]) {
                
                NSLog(@"8\n");
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"삭제"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [self deletePost];
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
            } else if([contentsData.notice isEqualToString:@"0"]) {
                
                NSLog(@"9\n");
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"수정"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [self modifyPost];
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"이동"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [self showGroupActionsheet];
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"삭제"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [self deletePost];
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                

            }
            }
            else {
             
                
            }
#endif
        }
        else if([contentsData.contentType isEqualToString:@"7"]) {
            actionButton = [UIAlertAction
                            actionWithTitle:@"다시 보내기"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                
                                [self reSend];
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
            actionButton = [UIAlertAction
                            actionWithTitle:@"삭제"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                
                                [self deletePost];
                                
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
            
        }
        
        
        else if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
            NSLog(@"11 %@",groupMaster);
            NSString *typestring = @"";
            if([contentsData.contentType isEqualToString:@"11"]){
                typestring = @"질문";
            }
            else{
                typestring = @"요청";
            }
            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                
                if([replyArray count] == 0){
                    NSLog(@"1");
                    //답변전 (질문 삭제)
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:[NSString stringWithFormat:@"%@ 삭제",typestring]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        
                                        [self deletePost];
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    
                    [view addAction:actionButton];
                    
                }
                else{
                    NSLog(@"2");
                    //답변후 (답변 수정, 답변 삭제, 질문 삭제
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"답변 수정"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        [self modifyReplyAction:replyArray[0]];
                                        
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    [view addAction:actionButton];
                    
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:@"답변 삭제"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        [self deleteReplyAction:replyArray[0]];
                                        
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    [view addAction:actionButton];
                    
                    
                    actionButton = [UIAlertAction
                                    actionWithTitle:[NSString stringWithFormat:@"%@ 삭제",typestring]
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        
                                        [self deletePost];
                                        
                                        
                                        //Do some thing here
                                        [view dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
                    [view addAction:actionButton];
                }
            }
            else{
                
                if([replyArray count] == 0){
                    NSLog(@"3");
                    //답변전 (질문 수정 / 질문 삭제
                    
                    if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        actionButton = [UIAlertAction
                                        actionWithTitle:[NSString stringWithFormat:@"%@ 수정",typestring]
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            
                                            [self modifyPost];
                                            
                                            //Do some thing here
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
                        
                        [view addAction:actionButton];
                        
                        actionButton = [UIAlertAction
                                        actionWithTitle:[NSString stringWithFormat:@"%@ 삭제",typestring]
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            
                                            
                                            [self deletePost];
                                            //Do some thing here
                                            [view dismissViewControllerAnimated:YES completion:nil];
                                            
                                        }];
                        
                        [view addAction:actionButton];
                    }
                    else{
                        
                    }
                }
                else{
                    NSLog(@"4");
                    //답변후 (메뉴 제공 하지 않음
                    
                }
            }
            
        }
        
        else if([contentsData.contentType isEqualToString:@"17"]){
            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // 삭제
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"삭제"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [self deletePost];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
            }
            else if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // 수정 삭제
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"수정"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [self modifyPost];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"삭제"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [self deletePost];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
            }
        }
        else if([contentsData.contentType isEqualToString:@"8"] || [contentsData.contentType isEqualToString:@"9"]){
            if([contentsData.contentDic[@"schedulestarttime"] intValue]==0) {
                
                
            } else {
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"일정 수정"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    [self modifySchedule];
                                    
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
                
                actionButton = [UIAlertAction
                                actionWithTitle:@"일정 취소"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    [self cancelScheduleAlert];
                                    //Do some thing here
                                    [view dismissViewControllerAnimated:YES completion:nil];
                                    
                                }];
                [view addAction:actionButton];
                
            }
        }
        
        
        
         cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    
    else{
        UIActionSheet *actionSheet = nil;
#ifdef MQM
#elif Batong
        if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
            // written by me
            
            if([contentsData.notice isEqualToString:@"1"]) {
                
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles:@"삭제", nil];
                
            }
            else{
                
                
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles:@"수정", @"삭제", nil];
                
                [actionSheet showInView:SharedAppDelegate.window];
                actionSheet.tag = kEdit;
        }
        }
        else{
            // not me
            
            if([contentsData.writeinfoType isEqualToString:@"1"] && ![contentsData.sub_category isKindOfClass:[NSNull class]] && [contentsData.sub_category length]>1){
                if([[SharedAppDelegate readPlist:@"isCS"]isEqualToString:@"1"])// i am cs
                {
                    
                    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                                destructiveButtonTitle:nil otherButtonTitles:@"삭제", nil];
                }
            }
            
        }
        
        
        
            if(actionSheet != nil){
                [actionSheet showInView:SharedAppDelegate.window];
                actionSheet.tag = kEdit;
                [self.view endEditing:YES];
            }
        
        
        return;
#endif
        if([contentsData.contentType isEqualToString:@"1"]) {
#ifdef MQM
            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // 공유 삭제
                
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles: @"삭제", nil];
                
                [actionSheet showInView:SharedAppDelegate.window];
                actionSheet.tag = kEdit;
            }
            else if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // 공유 이동 수정 삭제
                
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles:@"수정", @"삭제", nil];
                
                [actionSheet showInView:SharedAppDelegate.window];
                actionSheet.tag = kEdit;
            }
            else{
                
            }

#elif defined(GreenTalk) || defined(GreenTalkCustomer)
            
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                        destructiveButtonTitle:nil otherButtonTitles:@"수정", @"삭제", nil];
            
            [actionSheet showInView:SharedAppDelegate.window];
            actionSheet.tag = kEdit;
            return;
#endif
            if([contentsData.notice isEqualToString:@"1"]) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles:@"삭제", nil];
            } else if([contentsData.notice isEqualToString:@"0"]) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles:@"수정", @"이동", @"삭제", nil];
            } else {
                return;
            }
        }
        else if([contentsData.contentType isEqualToString:@"7"]) {
            actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                        destructiveButtonTitle:nil otherButtonTitles:@"다시 보내기", @"삭제", nil];
            
        }
        
        
        else if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
            NSLog(@"11 %@",groupMaster);
            NSString *typestring = @"";
            if([contentsData.contentType isEqualToString:@"11"]){
                typestring = @"질문";
            }
            else{
                typestring = @"요청";
            }
            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                
                if([replyArray count] == 0){
                    NSLog(@"1");
                    //답변전 (질문 삭제)
                    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                                destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"%@ 삭제",typestring], nil];
                }
                else{
                    NSLog(@"2");
                    //답변후 (답변 수정, 답변 삭제, 질문 삭제
                    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                                destructiveButtonTitle:nil otherButtonTitles:@"답변 수정",
                                   @"답변 삭제",
                                   [NSString stringWithFormat:@"%@ 삭제",typestring], nil];
                }
            }
            else{
                
                if([replyArray count] == 0){
                    NSLog(@"3");
                    //답변전 (질문 수정 / 질문 삭제
                    if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                                    destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"%@ 수정",typestring],
                                       [NSString stringWithFormat:@"%@ 삭제",typestring], nil];
                    }
                    else{
                        
                    }
                }
                else{
                    NSLog(@"4");
                    //답변후 (메뉴 제공 하지 않음
                    
                }
            }
            
        }
        else if([contentsData.contentType isEqualToString:@"17"]){
                if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    // 삭제
                    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                                destructiveButtonTitle:nil otherButtonTitles:@"삭제", nil];
                }
                else if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    // 수정 삭제
                    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                                destructiveButtonTitle:nil otherButtonTitles:@"수정", @"삭제", nil];
                }
        }
        else {
            if([contentsData.contentDic[@"schedulestarttime"] intValue]==0) {
                actionSheet = [[UIActionSheet alloc] initWithTitle:@"취소된 일정입니다." delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles:nil];
            } else {
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                            destructiveButtonTitle:nil otherButtonTitles:@"일정수정", @"일정취소", nil];
            }
        }
        //    [actionSheet showInView:self.parentViewController.tabBarController.view];
        if(actionSheet != nil){
            [actionSheet showInView:SharedAppDelegate.window];
            actionSheet.tag = kEdit;
            [self.view endEditing:YES];
        }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag == kSelectShare){
        if(buttonIndex == 0){
            
            [SharedAppDelegate.root.home showShareGroupActionsheet:contentsData.idx];
        }
        else if(buttonIndex == 1){
            
            [SharedAppDelegate.root.home showShareOtherAppActionsheet:contentsData.contentDic[@"msg"] con:self];
        }
        
    }
    else if(actionSheet.tag == kGroup){
        //        if(buttonIndex == 0){
        //            [self movePostToCate:@"1" toGroup:@""];
        //        }
        //        else
        //        if(buttonIndex == 0){
        //            [self movePostToCate:@"3" toGroup:@""];
        //
        //        }
        if(buttonIndex == 0){
            [self movePostToCate:@"1" toGroup:@""];
        }
        else{
            
            //            NSMutableArray *groupArray = [NSMutableArray array];
            //
            //            for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
            //                if([[dicobjectForKey:@"accept"]isEqualToString:@"Y"])
            //                {
            //                    [groupArray addObject:dic];
            //                }
            //            }
            if(buttonIndex == [groupArray count])
                return;
            
            NSLog(@"grouparray %@",groupArray);
            [self movePostToCate:@"2" toGroup:groupArray[buttonIndex][@"groupnumber"]];
            //            [self movePostToCate:@"2" toGroup:@""];
            
        }
        
    }
    else if(actionSheet.tag == kEdit) {
        
        if([contentsData.contentType isEqualToString:@"1"]){
#ifdef MQM
            
            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // 공유 삭제
                switch (buttonIndex) {
                    case 0:
                        [self deletePost];
                        break;
                    default:
                        break;
                }

            }
            else if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // 공유 이동 수정 삭제
                switch (buttonIndex) {
                    case 0:
                        [self modifyPost];
                        break;
                    case 1:
                        [self deletePost];
                        break;
                    default:
                        break;
                }
            }
            else{

            }
#elif defined(GreenTalk) || defined(GreenTalkCustomer)
            switch (buttonIndex) {
                case 0:
                    [self modifyPost];
                    break;
                case 1:
                    [self deletePost];
                    break;
                default:
                    break;
            }
            
            return;
#elif BearTalk
            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
            if([contentsData.notice isEqualToString:@"0"]){
                switch (buttonIndex) {
                    case 0:
                          [self confirmAddNotice];
                        break;
                    case 1:
                        [self modifyPost];
                        break;
                    case 2:
                        [self showGroupActionsheet];
                        break;
                    case 3:
                        [self deletePost];
                        break;
                    default:
                        break;
                }
            }
            else if([contentsData.notice isEqualToString:@"1"]){
                
                switch (buttonIndex) {
                    case 0:
                         [self confirmAddNotice];
                        break;
                    case 1:
                        [self deletePost];
                        break;
                    default:
                        break;
                }
            }
            }
            else{
                if([contentsData.notice isEqualToString:@"0"]){
                    switch (buttonIndex) {
                        case 0:
                            [self modifyPost];
                            break;
                        case 1:
                            [self showGroupActionsheet];
                            break;
                        case 2:
                            [self deletePost];
                            break;
                        default:
                            break;
                    }
                }
                else if([contentsData.notice isEqualToString:@"1"]){
                    
                    switch (buttonIndex) {
                        case 0:
                            [self deletePost];
                            break;
                        default:
                            break;
                    }
                }
            }
            
            
#else
            if([contentsData.notice isEqualToString:@"0"]){
                switch (buttonIndex) {
                    case 0:
                        [self modifyPost];
                        break;
                    case 1:
                        [self showGroupActionsheet];
                        break;
                    case 2:
                        [self deletePost];
                        break;
                    default:
                        break;
                }
            }
            else if([contentsData.notice isEqualToString:@"1"]){
                
                switch (buttonIndex) {
                    case 0:
                        [self deletePost];
                        break;
                    default:
                        break;
                }
            }
            
#endif
        }
        else if([contentsData.contentType isEqualToString:@"7"]){
            switch (buttonIndex) {
                case 0:
                    [self reSend];
                    break;
                case 1:
                    [self deletePost];
                    break;
                default:
                    break;
            }
            
        }
        if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                
                if([replyArray count] == 0){
                    //답변전 (질문 삭제)
                    switch (buttonIndex) {
                        case 0:
                            [self deletePost];
                            break;
                        default:
                            break;
                    }
                }
                else{
                    //답변후 (답변 수정, 답변 삭제, 질문 삭제
                    
                    NSDictionary *dic = replyArray[0];
                    objc_setAssociatedObject(actionSheet, &paramDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                    
                    switch (buttonIndex) {
                        case 0:
                            [self modifyReply:actionSheet];
                            //
                            break;
                        case 1:
                            [self deleteReply:actionSheet];
                            
                            break;
                        case 2:
                            [self deletePost];
                            break;
                        default:
                            break;
                    }
                }
            }
            else{
                
                if([replyArray count] == 0){
                    //답변전 (질문 수정 / 질문 삭제
                    switch (buttonIndex) {
                        case 0:
                            [self modifyPost];
                            break;
                        case 1:
                            [self deletePost];
                            
                            break;
                            
                        default:
                            break;
                    }
                }
                else{
                    //답변후 (메뉴 제공 하지 않음
                    
                }
            }
            
        }
        else if([contentsData.contentType isEqualToString:@"17"]){
            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // 삭제
                switch (buttonIndex) {
                    case 0:
                        [self deletePost];
                        break;
                    default:
                        break;
                }

            }
            else if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                // 수정 삭제
                switch (buttonIndex) {
                    case 0:
                        [self modifyPost];
                        break;
                    case 1:
                        [self deletePost];
                        break;
                    default:
                        break;
                }

            }
        }
        else{
            if([contentsData.contentDic[@"schedulestarttime"]intValue]==0)
            {
                return;
            }
            else{
                switch (buttonIndex) {
                    case 0:
                        [self modifySchedule];
                        break;
                    case 1:
                        [self cancelScheduleAlert];
                        break;
                    default:
                        break;
                }
            }
            
            
        }
    }
    else if(actionSheet.tag == kReply){
        switch (buttonIndex) {
            case 0:
                NSLog(@"reply note");
                [self cmdReplyNote];
                
                break;
            case 1:
                [self deletePost];
                break;
            default:
                break;
        }
    }
    else if(actionSheet.tag == kPhoto){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        switch (buttonIndex) {
            case 0:
                picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
                break;
            case 1:
                [SharedAppDelegate.root launchQBImageController:1 con:self];
                //                picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                //                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //                [self presentViewController:picker animated:YES];
                break;
            default:
                [self.view endEditing:YES];
                break;
        }
    }
    else if(actionSheet.tag == kActionReply){
        switch (buttonIndex) {
            case 0:
                [self modifyReply:actionSheet];
                break;
            case 1:
                [self deleteReply:actionSheet];
                break;
            default:
                break;
        }
        
    }
    //    else if(actionSheet.tag == kHWP){
    //
    //        BOOL isInstalled = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"db-2z06lztlavpszkt://"]]; // PorlarisOffice = db-76y0qkvvslf5i4d // 한글
    //        BOOL isInstalled2 = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"db-76y0qkvvslf5i4d://://"]];
    //                NSString *url = objc_getAssociatedObject(actionSheet, &paramUrl);
    //        NSLog(@"url %@",url);
    //        if(isInstalled && isInstalled2){
    //        if(buttonIndex == 0){
    //            // hancom
    //            NSLog(@"call hancom");
    //            NSString *hwpUrl = [NSString stringWithFormat:@"db-2z06lztlavpszkt://?%@",url];
    //            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:hwpUrl]];
    //        }
    //        else if(buttonIndex == 1){
    //            // polaris
    //            NSLog(@"call polaris");
    //            NSString *polaUrl = [NSString stringWithFormat:@"db-76y0qkvvslf5i4d://?%@",url];
    //            NSLog(@"polaUrl %@",polaUrl);
    //            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:polaUrl]];
    //
    //        }
    //        }
    //        else if(isInstalled){
    //            if(buttonIndex == 0){
    //                // hancom
    //                NSLog(@"call hancom");
    //                NSString *hwpUrl = [NSString stringWithFormat:@"db-2z06lztlavpszkt://%@",url];
    //                NSLog(@"hwpurl %@",hwpUrl);
    //                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:hwpUrl]];
    //
    //            }
    //        }
    //        else if(isInstalled2){
    //            if(buttonIndex == 0){
    //                // polaris
    //                NSLog(@"call polaris");
    //                NSString *polaUrl = [NSString stringWithFormat:@"db-76y0qkvvslf5i4d://%@",url];
    //                NSLog(@"polaUrl %@",polaUrl);
    //                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:polaUrl]];
    //
    //            }
    //        }
    //    }
}
- (void)confirmAddNotice{
    
    NSString *addString = @"";
    if([noticeyn isEqualToString:@"Y"])
        addString = @"에서 해제";
    else
        addString = @"로 등록";
    
    [CustomUIKit popupAlertViewOK:@"소셜 공지" msg:[NSString stringWithFormat:@"현재 소셜의 공지%@합니다.\n계속하시겠습니까?",addString] delegate:self tag:kAddNotice sel:@selector(addNotice:) with:noticeyn csel:nil with:nil];
}


- (void)addNotice:(NSString *)yn{
    
    
    
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    
    NSLog(@"groupnum %@",SharedAppDelegate.root.home.groupnum);
    if([SharedAppDelegate.root.home.groupnum length]<1 || SharedAppDelegate.root.home.groupnum == nil)
        return;
    
    NSString *type = @"D";
    if([yn isEqualToString:@"N"])
        type = @"I";
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/timelinecontentfavorite.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           //     SharedAppDelegate.root.home.groupnum,@"groupnumber",
                                contentsData.idx,@"contentindex",
                                type,@"type",
                                [ResourceLoader sharedInstance].myUID,@"uid",nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameters %@",parameters);
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/timeline.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [myTable.pullToRefreshView stopAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            NSString *addString = @"";
            if([noticeyn isEqualToString:@"Y"])
                addString = @"해제";
            else
                addString = @"등록";
            
            OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:[NSString stringWithFormat:@"소셜 공지 %@되었습니다.",addString]];
            
            toast.position = OLGhostAlertViewPositionCenter;
            
            toast.style = OLGhostAlertViewStyleDark;
            toast.timeout = 2.0;
            toast.dismissible = YES;
            [toast show];
            
            
               [SharedAppDelegate.root setNeedsRefresh:YES];
            
            
        }else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        [myTable.pullToRefreshView stopAnimating];
        NSLog(@"FAIL : %@",operation.error);
        
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
    
    

}
#define kModifySchedule 3

- (void)modifySchedule{
    WriteScheduleViewController *schedule = [[WriteScheduleViewController alloc]initTo:kModifySchedule];
    NSLog(@"contentsdata.contenstdic %@",contentsData.contentDic);
    NSString *endTime = contentsData.contentDic[@"scheduleendtime"];
    NSLog(@"endTime %@",endTime);
    if([endTime isEqualToString:@"0"] || endTime == nil)
        endTime = contentsData.contentDic[@"schedulestarttime"];
    [schedule setStart:contentsData.contentDic[@"schedulestarttime"]
                   end:endTime
                 title:contentsData.contentDic[@"scheduletitle"]
              location:contentsData.contentDic[@"jlocation"]
               explain:contentsData.contentDic[@"msg"]
                 alarm:contentsData.contentDic[@"alarm"]
                allday:contentsData.contentDic[@"allday"] index:contentsData.idx];
    
    schedule.title = @"일정수정";
    //    [SharedAppDelegate.root returnTitle:schedule.title viewcon:schedule noti:NO alarm:NO];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:schedule];
    [self presentViewController:nc animated:YES completion:nil];
//    [schedule release];
//    [nc release];
}

- (void)cancelScheduleAlert{
    
    //    UIAlertView *alert;
    //    //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
    //    alert = [[UIAlertView alloc] initWithTitle:@"정말 취소하시겠습니까?" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    //    alert.tag = kCancelSchedule;
    //    [alert show];
    //    [alert release];
    
    [CustomUIKit popupAlertViewOK:@"일정 취소" msg:@"정말 취소하시겠습니까?" delegate:self tag:kCancelSchedule sel:@selector(cancelSchedule) with:nil csel:nil with:nil];
}

- (void)cancelSchedule{
    
    [SharedAppDelegate.root modifySchedule:contentsData.idx title:contentsData.contentDic[@"scheduletitle"] location:@"" start:@"0000-00-00 00:00:00" end:@"0000-00-00 00:00:00" alarm:@"" allday:@"" msg:@"" type:@"5" con:self];
}


- (void)movePostToCate:(NSString *)newcate toGroup:(NSString *)newnum{
    
    [SharedAppDelegate.root
     modifyPost:contentsData.idx
     modify:3
     msg:@""
     oldcategory:[contentsData.targetdic objectFromJSONString][@"category"]
     newcategory:newcate
     oldgroupnumber:[contentsData.targetdic objectFromJSONString][@"categorycode"]
     newgroupnumber:newnum target:@"" replyindex:@"" viewcon:self];
    //      [self backTo];
}

- (void)deletePost{
    
    //    UIAlertView *alert;
    NSString *msg = @"";
    if([contentsData.contentType isEqualToString:@"7"]){
        msg = @"쪽지를 삭제하시겠습니까?";
    }
    else{
        msg = @"정말 삭제하시겠습니까?";
    }
    //    alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
    //    alert.tag = kDeletePost;
    //    [alert show];
    //    [alert release];
    
    [CustomUIKit popupAlertViewOK:@"삭제" msg:msg delegate:self tag:kDeletePost sel:@selector(confirmDelete) with:nil csel:nil with:nil];
    
    //    [self backTo];
}


#define kPost 2
#define kReply 3
#define kModifyPost 20
#define kModifyReply 30

- (void)modifyPost{
    
//    PostViewController *post = [[PostViewController alloc] initWithStyle:kPost];//WithViewCon:self];
    //    post.title = [NSString stringWithFormat:@"%@",self.title];
    [SharedAppDelegate.root.home.post initData:kPost];
    BOOL hasImage = NO;
    if([contentsData.contentDic[@"image"]length]>0)
        hasImage = YES;
    
    SharedAppDelegate.root.home.post.title = @"글 수정";
    [SharedAppDelegate.root.home.post setModifyView:contentsData.contentDic[@"msg"] idx:contentsData.idx tag:kModifyPost image:hasImage images:modifyImageArray poll:contentsData.pollDic];
#ifdef Batong
    
    [SharedAppDelegate.root.home.post setSubCategorys:contentsData.sub_category];
    [SharedAppDelegate.root.home.post setDeptName:contentsData.personInfo[@"deptname"]];
#endif
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.home.post];
    [self presentViewController:nc animated:YES completion:nil];
//    [post release];
//    [nc release];
}

- (void)reSend{
    NSLog(@"replyarray %@",replyArray);
    NSMutableArray *memberArray = [NSMutableArray array];
    for(NSString *forDic in replyArray){
        NSDictionary *dic = [SharedAppDelegate.root searchContactDictionary:[forDic objectFromJSONString][@"uid"]];
        NSLog(@"dic %@",dic);
        if([dic count] > 0) {
            [memberArray addObject:dic];
        }
    }
    
    if ([memberArray count] > 0) {
        SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:1];//WithViewCon:self];
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
        post.title = @"쪽지 보내기";
        [post saveArray:memberArray];
        //    [SharedAppDelegate.root returnTitle:post.title viewcon:post noti:NO alarm:NO];
        [self presentViewController:nc animated:YES completion:nil];
//        [post release];
//        [nc release];
    } else {
        [SVProgressHUD showErrorWithStatus:@"쪽지 대상이 존재하지 않습니다!"];
    }
}

- (void)confirmDelete{
    [SharedAppDelegate.root modifyPost:contentsData.idx
                                modify:1 msg:@""
                           oldcategory:@""
                           newcategory:@"" oldgroupnumber:@"" newgroupnumber:@"" target:contentsData.targetdic replyindex:@"" viewcon:self];
    
    if([contentsData.contentType isEqualToString:@"7"]){
        [SharedAppDelegate.root.note refreshTimeline];
        
        
    }
}
- (void)confirmDeletePhoto{
    
    qnaView.hidden = NO;
    //            qnaView.frame = CGRectMake(0, myTable.contentSize.height+10, 320, 240);
    preView.frame = CGRectMake(0, 130, 320, 0);
    preView.hidden = YES;
    qnaOptionView.frame = CGRectMake(0, CGRectGetMaxY(preView.frame)+5, 320, 90);
    CGRect qFrame = qnaView.frame;
    qFrame.size.height = CGRectGetMaxY(qnaOptionView.frame);
    qnaView.frame = qFrame;
    myTable.contentSize = CGSizeMake(myTable.contentSize.width, CGRectGetMaxY(qnaView.frame));
}

- (void)confirmDeleteReply:(NSString *)number{
    
    [SharedAppDelegate.root modifyReply:number
                                 modify:1 msg:@""
                                viewcon:self];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex == 1)
    {
//        if(alertView.tag == kShare){
//            [SharedAppDelegate.root.home goShare:contentsData.idx];
//        }
//        else
        if(alertView.tag == kDeletePhoto){
        
            [self confirmDeletePhoto];
        }
        else if(alertView.tag == kDeletePost)
        {
            [self confirmDelete];
        }
        
        else if(alertView.tag == kDeleteReply)     {
            NSString *number = objc_getAssociatedObject(alertView, &paramNumber);
            [self confirmDeleteReply:number];
        }
        else if(alertView.tag == kCancelSchedule)     {
            [self cancelSchedule];
        }
        else if(alertView.tag == kAddNotice)     {
            [self addNotice:noticeyn];
        }
        else if(alertView.tag == kEndPoll){
            
            //            UIAlertView *alert;
            //            alert = [[UIAlertView alloc] initWithTitle:@"설문 참여 대상 모두에게 설문 종료 알림을 보내시겠습니까?" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
            //            alert.tag = kPushEndPoll;
            //            [alert show];
            //            [alert release];
            [self confirmEnd];
        }
        else if(alertView.tag == kPushEndPoll){
            
            [self confirmEndPollWithNum];
        }
        else if(alertView.tag == kInstallHWP){
            
            [self confirmHwp];
            
        }
        
        
    }
    else{
        if(alertView.tag == kPushEndPoll){
            [self confirmEndPoll];
            
        }
    }
    
}

- (void)confirmEnd{
    
    [CustomUIKit popupAlertViewOK:@"설문 종료 알림" msg:@"설문 참여 대상 모두에게 설문 종료 알림을 보내시겠습니까?" delegate:self tag:kPushEndPoll sel:@selector(confirmEndPollWithNum) with:nil csel:@selector(confirmEndPoll) with:nil];
}
- (void)confirmHwp{
    
    NSString *encodingStr = [@"한글 뷰어" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *searchUrl = [NSString stringWithFormat:@"https://search.itunes.apple.com/WebObjects/MZSearch.woa/wa/search?media=software&term=%@",encodingStr];
    NSLog(@"searchUrl %@",searchUrl);
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:searchUrl]];
}

- (void)confirmEndPollWithNum{
    [self cmdEndPoll:@"1"];
}

- (void)confirmEndPoll{
    [self cmdEndPoll:@""];
}
- (void)showToast{
    
    NSLog(@"showToast %@",contentsData.contentType);
    if([contentsData.contentType isEqualToString:@"7"]){
        OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"쪽지가 삭제되었습니다."];
        
        toast.position = OLGhostAlertViewPositionCenter;
        
        toast.style = OLGhostAlertViewStyleDark;
        toast.timeout = 2.0;
        toast.dismissible = YES;
        [toast show];
//        [toast release];
    }
}




- (void)showGroupActionsheet{
    
    groupArray = [[NSMutableArray alloc]init];
    
    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
        NSLog(@"dic %@",dic);
        NSString *aAccept = dic[@"accept"];
        if([aAccept isEqualToString:@"Y"])
        {
            [groupArray addObject:dic];
        }
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        for(int i = 0; i < [groupArray count]; i++){
            
            actionButton = [UIAlertAction
                            actionWithTitle:groupArray[i][@"groupname"]
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                if(i == 0){
                                    [self movePostToCate:@"1" toGroup:@""];
                                }
                                else{
                                    
                                    
                                    if(i == [groupArray count])
                                        return;
                                    
                                    [self movePostToCate:@"2" toGroup:groupArray[i][@"groupnumber"]];
                                    //            [self movePostToCate:@"2" toGroup:@""];
                                    
                                }
                                
                                //Do some thing here
                                [view dismissViewControllerAnimated:YES completion:nil];
                                
                            }];
            [view addAction:actionButton];
        }
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    
    else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil otherButtonTitles:nil];
        for(NSDictionary *dic in groupArray){
            [actionSheet addButtonWithTitle:dic[@"groupname"]];
        }
        [actionSheet addButtonWithTitle:@"취소"];
        [actionSheet setCancelButtonIndex:[groupArray count]];
        //    [actionSheet showInView:self.parentViewController.tabBarController.view];
        [actionSheet showInView:SharedAppDelegate.window];
        actionSheet.tag = kGroup;
        //    [array release];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"viewwillAppear isPhoto %@",isPhoto?@"YES":@"NO");
    //    self.parentViewCon.hidesBottomBarWhenPushed = YES;
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    if(isPhoto == NO)
        [self getReply:NO];
    
    
    isPhoto = YES;
#if defined(Batong) || defined(BearTalk)
    [self getEmoticon];
#endif
    [SharedAppDelegate.root reloadPersonal];
    //    [self setSubviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    //    [SharedAppDelegate.root.home getTimeline:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.popKeyboard) {
        [replyTextView becomeFirstResponder];
        showEmoticonView = NO;
        self.popKeyboard = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(arriveNewReply:)
                                                 name:@"arriveNewReply"
                                               object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    
    //    self.parentViewCon.hidesBottomBarWhenPushed = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"viewWillDisappear");
    //    if(![contentsData.contentType isEqualToString:@"11"])
    isPhoto = NO;
    [self.view endEditing:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"arriveNewReply" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
}
//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
//    if(action==@selector(a:))
//        return YES;
//    else if(action == @selector(b:))
//        return YES;
//
//    return NO;
//
//}
//
//
//- (void)a:(id)sender
//{
//
//}
//
//- (void)b:(id)sender
//{
//
//}



#define kNotFavorite 1
#define kFavorite 2
#define kNothing 3

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    isPhoto = NO;
    
    
    
    NSLog(@"contentsdata %@",contentsData);
    //    UIMenuItem *item1 = [[UIMenuItem alloc]initWithTitle:@"복사" action:@selector(a:)];
    //    UIMenuItem *item2 = [[UIMenuItem alloc]initWithTitle:@"모두 선택" action:@selector(b:)];
    //    UIMenuController *theMenu = [UIMenuController sharedMenuController];
    //    [theMenu setMenuItems:[NSArray arrayWithObjects:item1, item2, nil]];
    //    [theMenu setTargetRect:CGRectMake(0,0,0,0) inView:self.view];
    //    [theMenu setMenuVisible:YES animated:YES];
    
    NSLog(@"self.presenting %@",self.presentingViewController);
    //    self.hidesBottomBarWhenPushed = YES;
    //	if (self.presentingViewController) {
    //		UIButton *button = [CustomUIKit closeButtonWithTarget:self selector:@selector(backTo)];
    //		UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    //		self.navigationItem.leftBarButtonItem = btnNavi;
    //		[btnNavi release];
    //	} else {
    UIButton *button = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = btnNavi;
//    [btnNavi release];
    //	}
//#ifdef BearTalk
//    
//    self.view.backgroundColor = RGB(255, 255, 255);//RGB(240, 235, 232);
//#else
    self.view.backgroundColor = RGB(249, 249, 249);
    
//#endif
    
    replyView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-originReplyHeight, self.view.frame.size.width, originReplyHeight)];
    NSLog(@"replyview1 %@",NSStringFromCGRect(replyView.frame));
    replyView.userInteractionEnabled = YES;
    
#ifdef BearTalk
    replyView.backgroundColor = RGB(249, 249, 249);
    replyView.layer.borderColor = RGB(224, 224, 224).CGColor;
    replyView.layer.borderWidth = 0.5f;
#else
    replyView.image = [[UIImage imageNamed:@"dv_btmtab_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:30];//[UIImage imageNamed:@"n01_dt_writdtn_bg.png"];
    
#endif
    photoBackgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0,replyView.frame.origin.y - 120,320,120)];
    photoBackgroundView.image = [UIImage imageNamed:@"btm_dropbg.png"];
    photoBackgroundView.userInteractionEnabled = YES;
    
    photoView = [[UIImageView alloc]init];
    [photoBackgroundView addSubview:photoView];
//    [photoView release];
    
    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(320-38,0,38,38)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"mmbtm_location_del.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closePhoto) forControlEvents:UIControlEventTouchUpInside];
    [photoBackgroundView addSubview:closeButton];

    
#ifdef BearTalk
    
    UIButton *photoButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 13, 24, 24)];
    [photoButton setBackgroundImage:[UIImage imageNamed:@"btn_file_off.png"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [replyView addSubview:photoButton];
    
    emoticonButtonBackground = [[UIImageView alloc]init];
    emoticonButtonBackground.frame = CGRectMake(CGRectGetMaxX(photoButton.frame)+3, photoButton.frame.origin.y, 0, 24);
    emoticonButtonBackground.image = [UIImage imageNamed:@"btn_emoticon_off.png"];
    [replyView addSubview:emoticonButtonBackground];
    NSLog(@"replyview rect %@",NSStringFromCGRect(replyView.frame));
    NSLog(@"emoticonButtonBackground rect %@",NSStringFromCGRect(emoticonButtonBackground.frame));
#else
    
    UIImageView *photoButtonBackground = [[UIImageView alloc]init];
    photoButtonBackground.frame = CGRectMake(4,9,33,43);
    [photoButtonBackground setImage:[[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
    [replyView addSubview:photoButtonBackground];
    photoButtonBackground.userInteractionEnabled = YES;
    
    UIImageView *photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(33/2-17/2,43/2-14/2,17,14)];
    [photoImage setImage:[UIImage imageNamed:@"photo_addbtn.png"]];
    [photoButtonBackground addSubview:photoImage];
    
    UIButton *photoButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,photoButtonBackground.frame.size.width,photoButtonBackground.frame.size.height)];
    [photoButton addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [photoButtonBackground addSubview:photoButton];
    
    emoticonButtonBackground = [[UIImageView alloc]init];
    emoticonButtonBackground.frame = CGRectMake(41, photoButtonBackground.frame.origin.y, 0, 43);
    [emoticonButtonBackground setImage:[[UIImage imageNamed:@"imageview_roundingborder_gray.png"]stretchableImageWithLeftCapWidth:20 topCapHeight:10]];
    [replyView addSubview:emoticonButtonBackground];
    
    emoticonButtonImage = [[UIImageView alloc]init];
    emoticonButtonImage.frame = CGRectMake(0, 0, 0, 43);
    [emoticonButtonImage setImage:[UIImage imageNamed:@"button_detail_emoticon.png"]];
    [emoticonButtonBackground addSubview:emoticonButtonImage];
#endif
    
    
    
    emoticonButtonBackground.userInteractionEnabled = YES;
    btnEmoticon = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:[UIColor clearColor] target:self selector:@selector(showEmoticon) frame:CGRectMake(0, 0, emoticonButtonBackground.frame.size.width, emoticonButtonBackground.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [emoticonButtonBackground addSubview:btnEmoticon];
    
    
    
#ifdef BearTalk
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake([SharedFunctions scaleFromWidth:86],[SharedFunctions scaleFromHeight:86]);
    aCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake([SharedFunctions scaleFromWidth:8], replyView.frame.origin.y + replyView.frame.size.height, self.view.frame.size.width - ([SharedFunctions scaleFromWidth:8]*2), 216) collectionViewLayout:layout];
    aCollectionView.backgroundColor = RGB(249, 249, 249);
    [aCollectionView setDataSource:self];
    [aCollectionView setDelegate:self];
    aCollectionView.scrollsToTop = NO;
    aCollectionView.pagingEnabled = YES;
    [aCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:aCollectionView];
//    self.view.backgroundColor = RGB(249,249,249);

#else
    HorizontalCollectionViewLayout *layout=[[HorizontalCollectionViewLayout alloc] init];
    aCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, replyView.frame.origin.y + replyView.frame.size.height + 20, self.view.frame.size.width, 216-20-20) collectionViewLayout:layout];
    layout.itemSize = CGSizeMake(80,80);
    [aCollectionView setDataSource:self];
    [aCollectionView setDelegate:self];
    aCollectionView.pagingEnabled = YES;
    aCollectionView.scrollsToTop = NO;
    [aCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [self.view addSubview:aCollectionView];
    aCollectionView.hidden = YES;
    aCollectionView.backgroundColor = [UIColor whiteColor];
    NSLog(@"aCollectionView1 %@",aCollectionView);
    
    paging = [[UIPageControl alloc]init];
    paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
    
    paging.currentPage = 0;
    
    
        paging.pageIndicatorTintColor = [UIColor lightGrayColor];
        paging.currentPageIndicatorTintColor = [UIColor grayColor];
    
    paging.transform = CGAffineTransformMakeScale(0.85, 0.85);
    //    [paging setCurrentPage:0];
    
    [self.view addSubview:paging];
    paging.hidden = YES;
#endif
//    [paging release];

    
    replyTextViewBackground = [[UIImageView alloc]init];
    replyTextViewBackground.frame = CGRectMake(41, 9, 220-emoticonButtonBackground.frame.size.width-4, 43);
    replyTextViewBackground.image = [[UIImage imageNamed:@"comtviewbg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:15];//[UIImage imageNamed:@"n01_dt_writdtn.png"];
    replyTextViewBackground.userInteractionEnabled = YES;
    [replyView addSubview:replyTextViewBackground];
//    [replyTextViewBackground release];
    
    
//    [placeHolderLabel release];
    
#ifdef BearTalk
    
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    labelSend = [CustomUIKit labelWithText:@"등록" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(replyView.frame.size.width - 16 - 53, 8, 53, replyView.frame.size.height - 8*2) numberOfLines:1 alignText:NSTextAlignmentCenter];
    labelSend.backgroundColor =  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    labelSend.layer.cornerRadius = 3.0; // rounding label
    labelSend.clipsToBounds = YES;
    labelSend.userInteractionEnabled = YES;
    [replyView addSubview:labelSend];
    
    sendButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(sendReply:) frame:CGRectMake(0, 0, labelSend.frame.size.width, labelSend.frame.size.height) imageNamedBullet:nil imageNamedNormal:@"" imageNamedPressed:nil];
    [labelSend addSubview:sendButton];
    replyTextViewBackground.frame = CGRectMake(CGRectGetMaxX(emoticonButtonBackground.frame)+6, 8, labelSend.frame.origin.x - 3 - (CGRectGetMaxX(emoticonButtonBackground.frame)+6), replyView.frame.size.height - 8*2);
    
    NSLog(@"replyview rect %@",NSStringFromCGRect(replyView.frame));
    NSLog(@"emoticonButtonBackground rect %@",NSStringFromCGRect(emoticonButtonBackground.frame));
#else
    sendButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(sendReply:) frame:CGRectMake(CGRectGetMaxX(replyTextViewBackground.frame)+4, 9, 50, 43) imageNamedBullet:nil imageNamedNormal:@"send_btn_dft.png" imageNamedPressed:nil];
    [replyView addSubview:sendButton];
#endif
    
    
    replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, replyTextViewBackground.frame.size.height/2 - 20/2, replyTextViewBackground.frame.size.width-25, 20)];
    [replyTextView setFont:[UIFont systemFontOfSize:14]];
    [replyTextView setContentInset:UIEdgeInsetsMake(-8, 0, -8, 0)];
    //    [replyTextView setContentInset:UIEdgeInsetsMake(-4,0,-4,0)];
    [replyTextView setDelegate:self];
    [replyTextView setBackgroundColor:[UIColor clearColor]];
    [replyTextViewBackground addSubview:replyTextView];
    //    [replyTextView sizeToFit];
    //    replyTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 9, replyTextView.frame.size.width-15, 20)];
    [placeHolderLabel setNumberOfLines:1];
    [placeHolderLabel setFont:[UIFont systemFontOfSize:14.0]];
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    [placeHolderLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [placeHolderLabel setTextColor:[UIColor grayColor]];
    [placeHolderLabel setText:@"댓글을 남기세요."];
    [replyTextView addSubview:placeHolderLabel];
    //    [replyTextView release];
    replyTextView.selectedRange = NSMakeRange(0,0);
    
//    [sendButton release];
    
    replyArray = [[NSMutableArray alloc]init];
    readArray = [[NSMutableArray alloc]init];
    likeArray = [[NSMutableArray alloc]init];
    
    
    float viewY = 64;
    
    
    CGRect tableFrame;
    //	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - viewY - self.tabBarController.tabBar.frame.size.height);
    //	} else {
    //		tableFrame = CGRectMake(0, 0, 320, self.view.frame.size.height - 44.0 - self.tabBarController.tabBar.frame.size.height);
    //	}
    NSLog(@"tableFrame %@",NSStringFromCGRect(tableFrame));
    
    NSLog(@"\n............contentType.............. %@\n",contentsData.contentType);
    NSLog(@"\n............type.............. %@\n",contentsData.type);
    NSLog(@"\n............writeinfoType.............. %@\n",contentsData.writeinfoType);
    
    myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    myTable.backgroundColor = [UIColor clearColor];
    myTable.bounces = NO;
    myTable.delegate = self;
    myTable.dataSource = self;
    myTable.scrollsToTop = YES;
    myTable.userInteractionEnabled = YES;
    [self.view addSubview:myTable];
    myTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [myTable release];
    
    if ([myTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [myTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([myTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [myTable setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:replyView];
//    [replyView release];
    replyView.hidden = YES;
    
    readLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 0, 0)];
    
    [readLabel setTextAlignment:NSTextAlignmentLeft];
    [readLabel setTextColor:[UIColor grayColor]];
    [readLabel setFont:[UIFont systemFontOfSize:11]];
    //		[nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    [readLabel setBackgroundColor:[UIColor clearColor]];
    //	[readLabel setText:@"0명 읽음"];
    [myTable addSubview:readLabel];
//    [readLabel release];
    
    favButton = [[UIButton alloc]initWithFrame:CGRectMake(320-36-10, 7, 36, 36)];
    [favButton addTarget:self action:@selector(addOrClear:) forControlEvents:UIControlEventTouchUpInside];
    favButton.adjustsImageWhenHighlighted = NO;
    favButton.tag = kNotFavorite;
    [myTable addSubview:favButton];
    
//    [favButton release];
    
    if([contentsData.contentType isEqualToString:@"7"])
        [favButton setBackgroundImage:[UIImage imageNamed:@"button_note_detail_bookmark.png"] forState:UIControlStateNormal];
    else{
#ifdef BearTalk
        favButton.frame = CGRectMake(self.view.frame.size.width - 16 - 30+7, 17-4, 30, 30);
        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_off.png"] forState:UIControlStateNormal];
#else
        readLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 20)];
        [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_dft.png"] forState:UIControlStateNormal];
#endif
    }
    
    if([contentsData.contentType isEqualToString:@"8"] || [contentsData.contentType isEqualToString:@"9"])
        favButton.hidden = YES;
    else
        favButton.hidden = NO;
    
#ifdef Batong
    favButton.hidden = YES;
    
    
    spgLabel = [CustomUIKit labelWithText:@"" fontSize:9 fontColor:RGB(41, 92, 172) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
    spgLabel.backgroundColor = RGB(216, 216, 216);
    spgLabel.layer.cornerRadius = 3.0; // rounding label
    spgLabel.clipsToBounds = YES;
    [myTable addSubview:spgLabel];
    
    hpgLabel = [CustomUIKit labelWithText:@"" fontSize:9 fontColor:RGB(168, 21, 6) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
    hpgLabel.backgroundColor = RGB(216, 216, 216);
    hpgLabel.layer.cornerRadius = 3.0; // rounding label
    hpgLabel.clipsToBounds = YES;
    [myTable addSubview:hpgLabel];
    
    
    nbgLabel = [CustomUIKit labelWithText:@"" fontSize:9 fontColor:RGB(38, 152, 129) frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
    nbgLabel.backgroundColor = RGB(216, 216, 216);
    nbgLabel.layer.cornerRadius = 3.0; // rounding label
    nbgLabel.clipsToBounds = YES;
    [myTable addSubview:nbgLabel];
    
    
    
    
#elif GreenTalk
    
    
    if([contentsData.writeinfoType isEqualToString:@"0"]){
        
        favButton.hidden = YES;
    }
    else if([contentsData.contentType isEqualToString:@"1"]){
        if([contentsData.writeinfoType isEqualToString:@"1"]){
            favButton.frame = CGRectMake(320-29-10, 7, 29, 29);
            favButton.hidden = NO;
            [favButton setBackgroundImage:[UIImage imageNamed:@"button_social_share.png"] forState:UIControlStateNormal];
        }
        else{
            favButton.hidden = YES;
        }
    }
    else if([contentsData.contentType isEqualToString:@"7"]){
        
        favButton.frame = CGRectMake(320-29-10, 7, 29, 29);
        favButton.hidden = NO;
        [favButton setBackgroundImage:[UIImage imageNamed:@"button_social_share.png"] forState:UIControlStateNormal];
    }
    else{
        favButton.hidden = YES;
    }
    
    
#elif GreenTalkCustomer
    favButton.hidden = YES;
    
    
#endif
    
    [self.view addSubview:photoBackgroundView];
//    [photoBackgroundView release];
    photoBackgroundView.hidden = YES;
    
    //    myTable.separatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"datview_bg.png"]];
    
//    myTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    if([contentsData.company length]>0)
    //        self.title = contentsData.company;
    //    if([contentsData.group length]>0)
    //        self.title = contentsData.group;
    //    if([contentsData.targetname length]>0)
    //        self.title = contentsData.targetname;
    
    
    [self setDetailGroupMaster];
    
    NSDictionary *tDic = [contentsData.targetdic objectFromJSONString];
    NSLog(@"contentsData.targetdic %@",tDic);
    if([contentsData.contentType isEqualToString:@"8"]){
        self.title = @"그룹일정";
    }
    else if([contentsData.contentType isEqualToString:@"9"]){
        if([tDic[@"category"]isEqualToString:@"3"]){
            self.title = @"개인일정";
        }
        else if([tDic[@"category"]isEqualToString:@"2"]){
            self.title = @"소셜일정";
        }
    }
    else{
        self.title = tDic[@"categoryname"];
        
        if([contentsData.contentType isEqualToString:@"11"]){
            self.title = @"Q&A";
        }
        else if([contentsData.contentType isEqualToString:@"14"]){
            self.title = @"배송요청";
        }
        
    }
    if([tDic[@"category"]isEqualToString:@"1"] || [tDic[@"category"]isEqualToString:@"5"]){
        //        if([contentsData.idx intValue]>[[SharedAppDelegate readPlist:@"lastcom"]intValue])
        //            [SharedAppDelegate writeToPlist:@"lastcom" value:contentsData.idx];
        
        
        if([contentsData.idx intValue]>[[SharedAppDelegate readPlist:@"0"]intValue])
            [SharedAppDelegate writeToPlist:@"0" value:contentsData.idx];
        
    }
    else if([tDic[@"category"]isEqualToString:@"2"]){
        
        if([contentsData.idx intValue]>[[SharedAppDelegate readPlist:tDic[@"categorycode"]]intValue])
            [SharedAppDelegate writeToPlist:tDic[@"categorycode"] value:contentsData.idx];
    }
    else if([tDic[@"category"]isEqualToString:@"3"]){
        if([contentsData.contentType isEqualToString:@"7"]){
            
            [SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastnote" value:contentsData.idx];
            if ([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]) {
                self.title = @"보낸쪽지";
            } else {
                self.title = @"받은쪽지";
            }
            //            if([contentsData.idx intValue]>[[SharedAppDelegate readPlist:@"lastnote"]intValue]) {
            //                [SharedAppDelegate writeToPlist:@"lastnote" value:contentsData.idx];
            //			}
        }
        else if([contentsData.contentType isEqualToString:@"8"]){
            
            [SharedAppDelegate.root.mainTabBar writeLastIndexForMode:@"lastschedule" value:contentsData.idx];
            //            if([contentsData.idx intValue]>[[SharedAppDelegate readPlist:@"lastschedule"]intValue]) {
            //                [SharedAppDelegate writeToPlist:@"lastschedule" value:contentsData.idx];
            //			}
        }
    }
    //    [SharedAppDelegate.root returnTitle:self.title viewcon:self noti:NO alarm:NO];
    NSLog(@"detail viewDidLoad %@ %@ %@",contentsData.profileImage,[ResourceLoader sharedInstance].myUID,contentsData.writeinfoType);
    
    //    UIButton *button;
    //    = [CustomUIKit backButtonWithTitle:nil target:self selector:@selector(backTo)];
    //    UIBarButtonItem *btnNavi;
    //    = [[UIBarButtonItem alloc]initWithCustomView:button];
    //    self.navigationItem.leftBarButtonItem = btnNavi;
    //    [btnNavi release];
    
    if([contentsData.contentType isEqualToString:@"7"]){
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(deletePost) frame:CGRectMake(0, 0, 26, 26)
                             imageNamedBullet:nil imageNamedNormal:@"barbutton_delete.png" imageNamedPressed:nil];
        
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
//        [button release];
        
    }
    else if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
        //        if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
        //
        //            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 32, 32)
        //                                 imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
        //
        //            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        //            self.navigationItem.rightBarButtonItem = btnNavi;
        //            [btnNavi release];
        //        }
        //        else{
        [self checkMaster];
        //        }
    }
    else if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID] && [contentsData.writeinfoType isEqualToString:@"1"]){
        
#ifdef BearTalk
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 25, 25)
                             imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_ect.png" imageNamedPressed:nil];
        
#else
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 26, 26)
                             imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
#endif
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
//        [btnNavi release];
//        [button release];
        
    }
    else if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID] && [contentsData.contentType isEqualToString:@"1"]){
        
#ifdef BearTalk
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 25, 25)
                             imageNamedBullet:nil imageNamedNormal:@"actionbar_btn_ect.png" imageNamedPressed:nil];
        
        
        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = btnNavi;
#endif
        
        
    }
    else{
    }
    msgLineCount = 1;
    isResizing = NO;
    
    
    tagArray = [[NSMutableArray alloc]init];
    //    [myTable reloadData];
    
    //    [self getReply];
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
        
        qnaView = [[UIView alloc]init];
        qnaView.backgroundColor = [UIColor clearColor];
        [myTable addSubview:qnaView];
        NSLog(@"groupmaster %@",groupMaster);
        //                    qnaView.userInteractionEnabled = YES;
        
        UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 320-20, 120)];
        background.image = [[UIImage imageNamed:@"login_input.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:15];
        //                background.image = [CustomUIKit customImageNamed:@"login_input.png"];
        background.userInteractionEnabled = YES;
        [qnaView addSubview:background];
//        [background release];
        
        replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 12, background.frame.size.width-25, background.frame.size.width - 20)];
        [replyTextView setFont:[UIFont systemFontOfSize:14]];
        [replyTextView setContentInset:UIEdgeInsetsMake(-8, 0, -8, 0)];
        //    [replyTextView setContentInset:UIEdgeInsetsMake(-4,0,-4,0)];
        [replyTextView setDelegate:self];
        [replyTextView setBackgroundColor:[UIColor clearColor]];
        [background addSubview:replyTextView];
        //    [replyTextView sizeToFit];
        //    replyTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 9, replyTextView.frame.size.width-15, 20)];
        [placeHolderLabel setNumberOfLines:1];
        [placeHolderLabel setFont:[UIFont systemFontOfSize:14.0]];
        [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
        [placeHolderLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [placeHolderLabel setTextColor:[UIColor grayColor]];
        [placeHolderLabel setText:@"답변 입력"];
        [replyTextView addSubview:placeHolderLabel];
//        [replyTextView release];
        replyTextView.selectedRange = NSMakeRange(0,0);
//        [placeHolderLabel release];
        
        
        preView = [[UIView alloc]init];
        preView.frame = CGRectMake(0, 130, 320, 0);
        preView.hidden = YES;
        preView.userInteractionEnabled = YES;
        [qnaView addSubview:preView];
//        [preView release];
        
        qnaOptionView = [[UIView alloc]init];
        qnaOptionView.frame = CGRectMake(0, CGRectGetMaxY(preView.frame)+5, 320, 90);
        [qnaView addSubview:qnaOptionView];
        qnaOptionView.userInteractionEnabled = YES;
        
        
        UIButton *button;
        
        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(addPhoto:) frame:CGRectMake(background.frame.origin.x, 0, background.frame.size.width, 40) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        [button setBackgroundImage:[[UIImage imageNamed:@"button_confirm_id.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
        [qnaOptionView addSubview:button];
//        [button release];
        
        UILabel *label;
        label = [CustomUIKit labelWithText:@"사진 첨부" fontSize:16 fontColor:[UIColor whiteColor]
                                     frame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        
        [button addSubview:label];
        
        
        
        qnaSendButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(sendReply:) frame:CGRectMake(background.frame.origin.x, 40+5, button.frame.size.width, 40) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
        
        [qnaSendButton setBackgroundImage:[[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
        
        
        [qnaOptionView addSubview:qnaSendButton];
//        [qnaSendButton release];
        
        qnaSendLabel = [CustomUIKit labelWithText:@"답변 등록" fontSize:16 fontColor:[UIColor grayColor]
                                            frame:CGRectMake(0, 0, qnaSendButton.frame.size.width, qnaSendButton.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
        [qnaSendButton addSubview:qnaSendLabel];
        qnaSendButton.enabled = NO;
        
        
        
        
        qnaView.hidden = YES;
//        [qnaView release];
//        [qnaOptionView release];
        
    }
    
    
}


- (void)setDetailGroupMaster{
    
    NSLog(@"groupnum %@",SharedAppDelegate.root.home.groupDic);
    if(SharedAppDelegate.root.home.groupDic[@"groupmaster"] == nil || [SharedAppDelegate.root.home.groupDic[@"groupmaster"]length]<1)
        return;
    
    if(groupMaster){
       
        groupMaster = nil;
    }
    groupMaster = [[NSString alloc]initWithString:SharedAppDelegate.root.home.groupDic[@"groupmaster"]];
    
}
- (void)checkMaster{
    
    
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    NSLog(@"groupnum %@",SharedAppDelegate.root.home.groupnum);
    if([SharedAppDelegate.root.home.groupnum length]<1 || SharedAppDelegate.root.home.groupnum == nil){
        
        if(groupMaster){
//            [groupMaster release];
            groupMaster = nil;
        }
        groupMaster = [[NSString alloc]initWithString:@""];
        return;
        
    }
    //        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/group/groupinfo.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                SharedAppDelegate.root.home.groupnum,@"groupnumber",nil];
    NSLog(@"groupinfo %@",parameters);
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    //        NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/group/groupinfo.lemp" parameters:parameters];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if(groupMaster){
//                [groupMaster release];
                groupMaster = nil;
            }
            groupMaster = [[NSString alloc]initWithFormat:@"%@",resultDic[@"groupmaster"]];
            
            
            
        }
        else {
            //                [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVProgressHUD dismiss];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            if(![isSuccess isEqualToString:@"0015"])
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹정보를 받는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}


- (void)closeEmoticon{
    
    if (selectedEmoticon) {
//        [selectedEmoticon release];
        selectedEmoticon = nil;
    }
    
    photoBackgroundView.hidden = YES;
}
- (void)closePhoto{//:(id)sender{
    
    if (selectedImageData) {
//        [selectedImageData release];
        selectedImageData = nil;
    }
    
    photoBackgroundView.hidden = YES;
}


- (void)addPhoto:(id)sender{
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"사진 찍기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            picker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
                            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                            [self presentViewController:picker animated:YES completion:nil];
                            
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"앨범에서 사진 선택"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            [SharedAppDelegate.root launchQBImageController:1 con:self];
                            
                            
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
        UIActionSheet *actionSheet = nil;
        
        
        
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"사진 찍기", @"앨범에서 사진 선택", nil];
        actionSheet.tag = kPhoto;
        
        
        [actionSheet showInView:SharedAppDelegate.window];
    }
}



#pragma mark -
#pragma mark UIImagePicker Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    isPhoto = YES;
    NSLog(@"isPhoto %@",isPhoto?@"YES":@"NO");
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker release];
}







- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    NSLog(@"ipicker %@",info);
    isPhoto = YES;
    NSLog(@"isPhoto %@",isPhoto?@"YES":@"NO");
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self sendPhoto:image];
        [picker dismissViewControllerAnimated:YES completion:nil];
//        [picker release];
    } else {
        //        PhotoViewController *photoViewCon = [[[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] autorelease];
        //        [picker presentViewController:photoViewCon animated:YES];
    }
    
    //	UIImage *image = [infoobjectForKey:UIImagePickerControllerOriginalImage];
    //	[self sendPhoto:image];
    //	[picker dismissViewControllerAnimated:YES completion:nil];
    
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#pragma mark - QBImagePickerControllerDelegate
- (void)qb_imagePickerController:(QBImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    NSLog(@"assets count %d",(int)[assets count]);
    PHImageManager *imageManager = [PHImageManager new];
    
//    NSMutableArray *infoArray = [NSMutableArray array];
//    for (PHAsset *asset in assets) {
        [imageManager requestImageDataForAsset:assets[0]
                                       options:0
                                 resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                     
                                     if([imageData length]<1){
                                         
                                         [CustomUIKit popupSimpleAlertViewOK:nil msg:@"이미지가 너무 작습니다." con:self];
                                         return;
                                     }

                                     
#ifdef BearTalk
                                     NSLog(@"dataUTI %@ info %@",dataUTI,info);
                                     NSString *filename = ((NSURL *)info[@"PHImageFileURLKey"]).absoluteString;
                                     UIImage *image;
                                     //                                     image = [UIImage imageWithData:imageData];
                                     //
                                     NSLog(@"imageData length %d",(int)[imageData length]);
                                     image = [UIImage sd_animatedGIFWithData:imageData];
                                     NSLog(@"image %@",image);
                                     NSLog(@"imagesize %@",NSStringFromCGSize(image.size));
                                     filename = [filename lowercaseString];
                                     if([filename hasSuffix:@"gif"]){
                                         // gif 는 사이즈 안 줄임
                                     }
                                     else{
                                         if(image.size.width > 640 || image.size.height > 960) {
                                             image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
                                         }
                                         imageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
                                         NSLog(@"aimagedata length %d",[imageData length]);
                                     }
                                     
                                     NSMutableArray *images = [NSMutableArray array];
                                     [images addObject:@{@"image" : image, @"filename" : filename, @"data" : imageData}];
                                     
                                     
                                         PhotoTableViewController *photoTable = [[PhotoTableViewController alloc]initForUpload:images parent:self];
                                         //    if(![picker.navigationController.topViewController isKindOfClass:[photoTable class]])
                                         
                                         UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:photoTable];
                                         //                                         [picker pushView:photoTable animated:YES];
                                         
                                         [picker presentViewController:nc animated:YES completion:nil];
                                     
#else
                                     
                                     UIImage *image = [UIImage imageWithData:imageData];
                                   
                                     
                                     PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] ;
                                   [picker presentViewController:photoViewCon animated:YES completion:nil];
#endif
                                 }];
//    }
    
    
    
    
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    NSLog(@"qb_imagePickerControllerDidCancel");
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

#else

- (void)qbimagePickerController:(QBImagePickerController *)picker didFinishPickingMediaWithInfo:(id)info
{
    isPhoto = YES;
    NSLog(@"isPhoto %@",isPhoto?@"YES":@"NO");
    NSLog(@"info %@",info);
    NSArray *mediaInfoArray = (NSArray *)info;
    UIImage *image = mediaInfoArray[0][UIImagePickerControllerOriginalImage];
    
    PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithImage:image parentPicker:picker parentViewCon:self] ;
    [picker presentViewController:photoViewCon animated:YES completion:nil];
}
#endif


- (void)saveImages:(NSMutableArray *)array{
   
    NSLog(@"saveImages %d",[array count]);
    if([array count]==0)
    return;
    
    NSString *filename = array[0][@"filename"];
    UIImage *image = array[0][@"image"];
    
    isPhoto = YES;
    NSLog(@"isPhoto %@",isPhoto?@"YES":@"NO");
    
    NSLog(@"sendPhoto");
    if([filename hasSuffix:@"gif"]){
    }
    else{
    if(image.size.width > 640 || image.size.height > 960) {
        image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
    }
    }
    
    
    if(selectedEmoticon){
        //        [selectedEmoticon release];
        selectedEmoticon = nil;
    }
    
    
    if (selectedImageData) {
        //        [selectedImageData release];
        selectedImageData = nil;
    }
    if([filename hasSuffix:@"gif"]){
        selectedImageData = [[NSData alloc] initWithData:array[0][@"data"]];
    }
    else{
        selectedImageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
        
    }
    
    
    CGSize imageSize = [UIImage imageWithData:selectedImageData].size;
    CGFloat imageScale = imageSize.height/100;
    imageSize.width = imageSize.width/imageScale;
    
    if(imageSize.width>300)
    imageSize.width = 300;
    
    //	if (imageSize.width > imageSize.height) {
    //		imageScale = 100/imageSize.width;
    //		imageSize.width = 100;
    //		imageSize.height = imageSize.height*imageScale;
    //	} else if (imageSize.width < imageSize.height) {
    //		imageScale = 100/imageSize.height;
    //		imageSize.width = imageSize.width*imageScale;
    //		imageSize.height = 100;
    //	} else {
    //		imageSize.width = 100;
    //		imageSize.height = 100;
    //	}
    
    NSLog(@"imageSize %@",NSStringFromCGSize(imageSize));
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
        
        //        photoView.frame = CGRectMake(10,10,imageSize.width, 100);
        //        photoView.image = image;
        //        preView.hidden = NO;
        
        qnaView.hidden = NO;
        preView.frame = CGRectMake(0, 130, 320, 60);
        preView.hidden = NO;
        qnaOptionView.frame = CGRectMake(0, CGRectGetMaxY(preView.frame)+5, 320, 90);
        CGRect qFrame = qnaView.frame;
        qFrame.size.height = CGRectGetMaxY(qnaOptionView.frame);
        qnaView.frame = qFrame;
        myTable.contentSize = CGSizeMake(myTable.contentSize.width, CGRectGetMaxY(qnaView.frame));
        
        UIImageView *inImageView = [[UIImageView alloc]init];
        inImageView.frame = CGRectMake(10, 3, 52, 52);
        [inImageView setContentMode:UIViewContentModeScaleAspectFill];
        [inImageView setClipsToBounds:YES];
        
//        inImageView.image = image;
        inImageView.image = [UIImage sd_animatedGIFWithData:selectedImageData];
        [preView addSubview:inImageView];
        inImageView.userInteractionEnabled = YES;
        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,52,52)];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"wrt_photobgdel.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteEachPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [inImageView addSubview:deleteButton];
        //        [deleteButton release];
        //        [inImageView release];
        //        [preView release];
        return;
        
    }
    photoView.frame = CGRectMake(10,10,imageSize.width, 100);
    photoView.image = image;
    
    //	[self imageWithImage:[UIImage imageWithData:imageData] scaledToSizeWithSameAspectRatio:CGSizeMake(imageSize.width, imageSize.height) toPath:thumbFilePath];
    
    
    photoBackgroundView.hidden = NO;
    
    //	[addPhoto setBackgroundImage:image forState:UIControlStateNormal];
    
    NSLog(@"selectedImageData length %d",(int)[selectedImageData length]);
#ifdef BearTalk
#else
    if([selectedImageData length]>0)
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
#endif
    
    
    //    if(photoBackgroundView.hidden == NO){
    photoBackgroundView.frame = CGRectMake(0, replyView.frame.origin.y - 120, 320, 120);
    //    }

}



- (void)sendPhoto:(UIImage*)image
{
    isPhoto = YES;
    NSLog(@"isPhoto %@",isPhoto?@"YES":@"NO");
    
    NSLog(@"sendPhoto");
    if(image.size.width > 640 || image.size.height > 960) {
        image = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(640, 960) interpolationQuality:kCGInterpolationHigh];
    }
    
    
    if(selectedEmoticon){
//        [selectedEmoticon release];
        selectedEmoticon = nil;
    }
    
    
    if (selectedImageData) {
//        [selectedImageData release];
        selectedImageData = nil;
    }
    selectedImageData = [[NSData alloc] initWithData:[SharedAppDelegate.root imageWithImage:image scaledToSizeWithSameAspectRatio:CGSizeMake(640, 960)]];
    
    
    
    CGSize imageSize = [UIImage imageWithData:selectedImageData].size;
    CGFloat imageScale = imageSize.height/100;
    imageSize.width = imageSize.width/imageScale;
    
    if(imageSize.width>300)
        imageSize.width = 300;
    
    //	if (imageSize.width > imageSize.height) {
    //		imageScale = 100/imageSize.width;
    //		imageSize.width = 100;
    //		imageSize.height = imageSize.height*imageScale;
    //	} else if (imageSize.width < imageSize.height) {
    //		imageScale = 100/imageSize.height;
    //		imageSize.width = imageSize.width*imageScale;
    //		imageSize.height = 100;
    //	} else {
    //		imageSize.width = 100;
    //		imageSize.height = 100;
    //	}
    
    NSLog(@"imageSize %@",NSStringFromCGSize(imageSize));
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
        
        //        photoView.frame = CGRectMake(10,10,imageSize.width, 100);
        //        photoView.image = image;
        //        preView.hidden = NO;
        
        qnaView.hidden = NO;
        preView.frame = CGRectMake(0, 130, 320, 60);
        preView.hidden = NO;
        qnaOptionView.frame = CGRectMake(0, CGRectGetMaxY(preView.frame)+5, 320, 90);
        CGRect qFrame = qnaView.frame;
        qFrame.size.height = CGRectGetMaxY(qnaOptionView.frame);
        qnaView.frame = qFrame;
        myTable.contentSize = CGSizeMake(myTable.contentSize.width, CGRectGetMaxY(qnaView.frame));
        
        UIImageView *inImageView = [[UIImageView alloc]init];
        inImageView.frame = CGRectMake(10, 3, 52, 52);
        [inImageView setContentMode:UIViewContentModeScaleAspectFill];
        [inImageView setClipsToBounds:YES];
        
        inImageView.image = image;
        [preView addSubview:inImageView];
        inImageView.userInteractionEnabled = YES;
        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,52,52)];
        [deleteButton setBackgroundImage:[UIImage imageNamed:@"wrt_photobgdel.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteEachPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [inImageView addSubview:deleteButton];
//        [deleteButton release];
//        [inImageView release];
        //        [preView release];
        return;
        
    }
    photoView.frame = CGRectMake(10,10,imageSize.width, 100);
    photoView.image = image;
    
    //	[self imageWithImage:[UIImage imageWithData:imageData] scaledToSizeWithSameAspectRatio:CGSizeMake(imageSize.width, imageSize.height) toPath:thumbFilePath];
    
    
    photoBackgroundView.hidden = NO;
    
    //	[addPhoto setBackgroundImage:image forState:UIControlStateNormal];
    
    NSLog(@"selectedImageData length %d",(int)[selectedImageData length]);
#ifdef BearTalk
#else
    if([selectedImageData length]>0)
        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
#endif
    
    
//    if(photoBackgroundView.hidden == NO){
        photoBackgroundView.frame = CGRectMake(0, replyView.frame.origin.y - 120, 320, 120);
//    }
    
}

- (void)deleteEachPhoto:(id)sender{
    NSLog(@"deleteEach %d",(int)[sender tag]);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"사진 삭제"
                                                                                 message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self confirmDeletePhoto];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"사진 삭제" message:@"선택한 사진이 삭제됩니다.\n계속하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
        alert.tag = kDeletePhoto;
        [alert show];
//        [alert release];
    }
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"heightfor");
    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
    NSInteger rfontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalrFontSize"];
    
    if(indexPath.row == 0)
    {
        float height = 0;
        if(![contentsData.writeinfoType isEqualToString:@"0"]){
            

            height += 70; // defaultview // beartalk same

        }
        if([contentsData.contentType intValue]>17 || [contentsData.type intValue]>6 || ([contentsData.writeinfoType intValue]>4 && [contentsData.writeinfoType intValue]!=10)){
            NSLog(@"9 6 4");
            height += 18+5;
        }
        else{
            
            if([contentsData.contentType isEqualToString:@"8"] || [contentsData.contentType isEqualToString:@"9"])
            {
#ifdef BearTalk
                height += 16.5+16.5+24; // titleview
#else
                height -= 70; // defaultview none
                height += 10; // titleview gap
#endif
     
                
#ifdef BearTalk
#else
                if([contentsData.contentType isEqualToString:@"9"] && [[contentsData.targetdic objectFromJSONString][@"category"]isEqualToString:@"2"]){

                    height += 25; // socialLabel;
                    height += 5 + 44; // gap infoView;

                }
                else{
                    height += 44; // infoView
                }
           
                if(!([contentsData.contentType isEqualToString:@"9"] && [[contentsData.targetdic objectFromJSONString][@"category"]isEqualToString:@"3"]))
                {
                    height +=  5 + 16; // gap + createrLabel
                    
                    height += 5 + 16; // gap + createrTime
                    
                }
#endif
                
                // timeView
                
                
                NSString *endTime = contentsData.contentDic[@"scheduleendtime"];
                NSLog(@"endTime %@",endTime);
                if([endTime isEqualToString:@"0"] || endTime == nil)
                    endTime = contentsData.contentDic[@"schedulestarttime"];
                NSString *startTime = contentsData.contentDic[@"schedulestarttime"];
                
                NSString *nowTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
                NSLog(@"starttime %d endtime %d nowtime %d",[startTime intValue],[endTime intValue],[nowTime intValue]);
                
                int valueInterval = [nowTime intValue] - [startTime intValue];
                NSLog(@"valueInterval %d",valueInterval);
                
                if([startTime intValue]==0)
                {
                    
                }
                else{
#ifdef BearTalk
                    height += 18; // last gap
                    height += 18+15;
#else
                    height += 10 + 10 + 16; // gap line gap startLabel
#endif
                    
                    
                    if([startTime isEqualToString:endTime]){
                    }
                    else{
#ifdef BearTalk
                        height += 8+15;
#else
                        height += 16; // endLabel
#endif
                        
                    }
                }
                
                
                if([contentsData.contentDic[@"alarm"]intValue]>0){
                    
#ifdef BearTalk
                    height += 11+15;
#else
                    height += 10 + 10 + 20; // gap line gap alarmLabel;
                    //                    height += 10; // gap !!
#endif
                    
                }
                
                
                
#ifdef BearTalk
#else
                if([contentsData.contentType isEqualToString:@"8"]){// || ([contentsData.contentType isEqualToString:@"9"] && [[contentsData.targetdic objectFromJSONString][@"category"]isEqualToString:@"2"])){
                    
                    int buttonWidth = 0;
                    
                    height += 10; // gap
                    height += 10 + 20; // memberViewTitle;
                    
                    
                    if([contentsData.contentDic[@"attendance"]isEqualToString:@"1"]){
                        
                        
                        
                        
                        // attendance
                        NSArray *membersArray = contentsData.contentDic[@"schedulemember"];
                        NSLog(@"members %@",membersArray);
                        
                        
                        
                        int attendNum = 0;
                        int notAttendNum = 0;
                        int notDecideNum = 0;
                        
                        NSString *attendMemberString = @"";
                        NSString *notAttendMemberString = @"";
                        NSString *notDecideMemberString = @"";
                        
                        for(int i = 0; i < [membersArray count]; i++){
                            NSString *attendValue = @"";
                            NSDictionary *dic = [membersArray[i]objectFromJSONString];
                            NSString *chkUid = dic[@"uid"];
                            for(int j = 0; j < [readArray count]; j++){
                                NSDictionary *readDic = [readArray[j]objectFromJSONString];
                                NSLog(@"ReadDic %@",readDic);
                                NSString *aUid = readDic[@"uid"];
                                if([aUid isEqualToString:chkUid])
                                    attendValue = readDic[@"attendance"];
                                NSLog(@"attendValue %@",attendValue);
                            }
                            if([attendValue isEqualToString:@"2"]){
                                attendNum++;
                                attendMemberString = [attendMemberString stringByAppendingFormat:@"%@, ",dic[@"name"]];
                            }
                            else if([attendValue isEqualToString:@"1"]){
                                notAttendNum++;
                                notAttendMemberString = [notAttendMemberString stringByAppendingFormat:@"%@, ",dic[@"name"]];
                            }
                            else{
                                notDecideNum++;
                                notDecideMemberString = [notDecideMemberString stringByAppendingFormat:@"%@, ",dic[@"name"]];
                            }
                            
                        }
                        
                        
                        attendMemberString = [attendMemberString length]>1?[attendMemberString substringToIndex:[attendMemberString length]-2]:attendMemberString;
                        notAttendMemberString = [notAttendMemberString length]>1?[notAttendMemberString substringToIndex:[notAttendMemberString length]-2]:notAttendMemberString;
                        notDecideMemberString = [notDecideMemberString length]>1?[notDecideMemberString substringToIndex:[notDecideMemberString length]-2]:notDecideMemberString;
                        
                        
                        height += 5 + 23; // attendCountTitle;
                        int memberWidth = 320-40;
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle};
                        CGSize memberSize = [attendMemberString boundingRectWithSize:CGSizeMake(memberWidth, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        //                CGSize memberSize = [attendMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(memberWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        
                        height -= 5; // y
                        height += memberSize.height;
                        height += 23; // notAttendCountTitle
                        
                        
                        paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                        attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle};
                        memberSize = [notAttendMemberString boundingRectWithSize:CGSizeMake(memberWidth, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;

                    //    memberSize = [notAttendMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(memberWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        height -= 5; // y
                        height += memberSize.height;
                        
                        
                        
                        
                        if(valueInterval<=0){
                            height += 30; // setMyAttend button
                            height += 10; // gap
                        }
                        
                        height += 23; // notDecideTitle
                        
                        
                        paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                        attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle};
                        memberSize = [notDecideMemberString boundingRectWithSize:CGSizeMake(memberWidth, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                  //      memberSize = [notDecideMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(memberWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        height -= 5; // y
                        height += memberSize.height;
                        
                        
                    }
                    
                    
                    else{
                        
                        
                        
                        NSString *readMemberString = @"";
                        NSString *notReadMemberString = @"";
                        
                        NSArray *membersArray = contentsData.contentDic[@"schedulemember"];
                        NSLog(@"members %@",membersArray);
                        
                        height += 5 + 23; // readMemberTitle
                        
                        for(int i = 0; i < [readArray count];i++){
                            NSDictionary *dic = [readArray[i]objectFromJSONString];
                            NSString *aName = dic[@"name"];
                            readMemberString = [readMemberString stringByAppendingFormat:@"%@, ",aName];
                        }
                        
                        readMemberString = [readMemberString length]>1?[readMemberString substringToIndex:[readMemberString length]-2]:readMemberString;
                        
                        int memberWidth = 320-40;
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle};
                        CGSize memberSize = [readMemberString boundingRectWithSize:CGSizeMake(memberWidth, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                        
                      //  CGSize memberSize = [readMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(memberWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        height -= 5; // y
                        height += memberSize.height;
                        
                        NSLog(@"membersArray %@",membersArray);
                        
                        NSMutableArray *notReadArray = [NSMutableArray array];
                        
                        for(int i = 0; i < [membersArray count]; i++){
                            BOOL read = NO;
                            NSDictionary *dic = [membersArray[i]objectFromJSONString];
                            NSString *chkUid = dic[@"uid"];
                            for(int j = 0; j < [readArray count]; j++){
                                NSDictionary *readDic = [readArray[j]objectFromJSONString];
                                NSString *aUid = readDic[@"uid"];
                                if([aUid isEqualToString:chkUid])
                                {
                                    read = YES;
                                }
                            }
                            if(read == NO){
                                [notReadArray addObject:dic];
                            }
                        }
                        
                        NSLog(@"notReadArray %@",notReadArray);
                        
                        for(NSDictionary *dic in notReadArray){
                            NSString *aName = dic[@"name"];
                            notReadMemberString = [notReadMemberString stringByAppendingFormat:@"%@, ",aName];
                        }
                        notReadMemberString = [notReadMemberString length]>1?[notReadMemberString substringToIndex:[notReadMemberString length]-2]:notReadMemberString;
                        
                        height += 23; // notReadTitle
                        
                        
                        paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                        attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle};
                        memberSize = [notReadMemberString boundingRectWithSize:CGSizeMake(memberWidth, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                        
                        memberSize = [notReadMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(memberWidth, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        height -= 5; // y
                        height += memberSize.height; // notReadTitle
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
#endif
                
                
                NSString *where = contentsData.contentDic[@"jlocation"];
                NSLog(@"where %@",where);
                NSDictionary *dic = [where objectFromJSONString];//componentsSeparatedByString:@","];
                
                
                if([dic[@"text"]length]>0)//                if(where != nil && [where length]>0)
                {
                    
#ifdef BearTalk
                    height += 18+15+18;
#else
                    height += 10; // gap
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
                    CGSize whSize = [dic[@"text"] boundingRectWithSize:CGSizeMake(280-15, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
              //      CGSize whSize = [dic[@"text"] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
                    height += 10;  // gap
                    height += whSize.height;
#endif
                    
                }
                else{
                    
                }
                
                
                
                NSString *content = contentsData.contentDic[@"msg"];
                
                if([content length]>0){
                    
#ifdef BearTalk
                    CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:15] width:self.view.frame.size.width - 16*2 - 15*2 realZeroInsets:NO];
                    height += 18+cSize.height + 18;
#else
                    height += 10; // gap
                    
                    CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:12] width:280 realZeroInsets:NO];
                    height += 10; // gap
                    height += cSize.height;
#endif
                    
                    
                }
                else{
#ifdef BearTalk
                    height += 18; // gap
#else
                    height += 5; // ???
#endif
                }
                
#ifdef BearTalk
                height += 18; // last gap
#endif
                
                //                height += 10; //  // gap !!
                
            }
            
            
            else{
                
                
                NSString *content = contentsData.contentDic[@"msg"];
                NSString *where = contentsData.contentDic[@"jlocation"];
                NSString *imageString = contentsData.contentDic[@"image"];
                NSDictionary *pollDic = contentsData.pollDic;
                NSArray *fileArray = contentsData.fileArray;
                
                //                CGSize cSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(295, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:fontSize] width:self.view.frame.size.width - 32 realZeroInsets:NO];
                
                
                //                NSLog(@"else content %@",content);
                NSLog(@"else content %f %f",cSize.width,cSize.height);
                height += cSize.height;
                
                NSDictionary *dic = [where objectFromJSONString];//componentsSeparatedByString:@","];
                if([dic[@"text"]length]>0) //                if(where != nil && [where length]>0)
                {
                    NSLog(@"else where");
                    height += 14;
                }
                
                if(imageString != nil && [imageString length]>0)
                {
                    NSArray *imageArray;
                    
#ifdef BearTalk
                    imageArray = [imageString objectFromJSONString][@"filename"];
#else
                    
                    imageArray = [imageString objectFromJSONString][@"thumbnail"];
#endif
                    for(int i = 0; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
                        NSDictionary *sizeDic;
                        if([[imageString objectFromJSONString][@"thumbnailinfoarray"]count]>0)
                            sizeDic = [imageString objectFromJSONString][@"thumbnailinfoarray"][i];
                        else
                            sizeDic = [imageString objectFromJSONString][@"thumbnailinfo"];
                        
                        
                        CGFloat imageScale = 0.0f;
                        imageScale = (self.view.frame.size.width - 32)/[sizeDic[@"width"]floatValue];
                        
                        NSLog(@"else image");
                        height += (imageScale * [sizeDic[@"height"]floatValue]+10);//300 *[[imageString objectFromJSONString][@"thumbnail"]count];//imageScale * [sizeDic[@"height"]floatValue];
                    }
//                    height += 5;
                }
                
                
                if(pollDic != nil){
                    
#ifdef BearTalk
                    height += 10; // gap
                    
                    NSString *ing_ed;
                    if([pollDic[@"is_close"]isEqualToString:@"1"]){
                        ing_ed = @"종료 ";
                    }
                    else{
                        ing_ed = @"진행중 ";
                        
                    }
                    
                    NSString *subtitle = @"";
                    if([pollDic[@"is_anon"]isEqualToString:@"1"])
                        subtitle = [subtitle stringByAppendingString:@"무기명 "];
                    
                    if([pollDic[@"is_multi"]isEqualToString:@"1"])
                        subtitle = [subtitle stringByAppendingString:@"(복수 선택 가능)"];
                    
                    
                    NSString *msg = [NSString stringWithFormat:@"%@ %@\n%@",ing_ed,subtitle,pollDic[@"title"]];
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12], NSParagraphStyleAttributeName:paragraphStyle};
                    CGSize titleSize = [msg boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 32 - (16+24) - 16 - 70-5, 150) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
              //      CGSize titleSize = [msg sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(self.view.frame.size.width - 32 - (16+24) - 16 - 70-5, 150) lineBreakMode:NSLineBreakByWordWrapping];

                    
                    height += titleSize.height>47?titleSize.height+10:47+10; // title
                    height += 1; // line
                    
                    
                    
                    NSArray *optArray = pollDic[@"options"];
                    for(int i = 0; i < [optArray count];i++){
                    NSString *opt = optArray[i][@"name"];
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle};
                        CGSize optSize = [opt boundingRectWithSize:CGSizeMake(self.view.frame.size.width-32 - (14+24+5) - 16 - 30 - 5, 150) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
             //       CGSize optSize = [opt sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(self.view.frame.size.width-32 - (14+24+5) - 16 - 30 - 5, 150) lineBreakMode:NSLineBreakByWordWrapping];
                    
                        height += 14+(optSize.height>24?optSize.height:24)+14+1; // option
                        
                        
                        NSString *name = optArray[i][@"username"];
                        if([pollDic[@"is_anon"]isEqualToString:@"0"] &&
                           [name length]>0 &&
                           [pollDic[@"is_visible_dstatus"]isEqualToString:@"0"])
                        {
                            
                            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11], NSParagraphStyleAttributeName:paragraphStyle};
                            CGSize nameSize = [name boundingRectWithSize:CGSizeMake(optSize.width, 24) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                        //    CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(optSize.width, 24) lineBreakMode:NSLineBreakByWordWrapping];
                            height += nameSize.height+5;
                            
                            if(nameSize.height>24){
                                
                                height += 12+5;
                                
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    
                               if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    height += 10 + 38; // end button
                               
                   
                    
                    //                    [pollBtn release];
                    
                    if([pollDic[@"is_close"]isEqualToString:@"1"]){
                        
                        height -= (10 + 38);
                        
                    }
                    }
                    
                    height += 10; // gap
#else
                    height += 15 + 20 + 10; // gap + subtitle + gap
                    
                    NSString *title = pollDic[@"title"];
                    NSLog(@"title %@",title);
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
                    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(302 - 10, 150) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
 //                   CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(302 - 10, 150) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    height += 5 + titleSize.height; // gap + title
                    
                    height += 15 + 2; // gap + line
                    
                    NSArray *optArray = pollDic[@"options"];
                    
                    for(int i = 0; i < [optArray count]; i++){
                        
                        height += 15;
                        
                        NSString *opt = optArray[i][@"name"];
                        opt = [opt stringByAppendingString:@" - "];
                        
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
                        CGSize optSize = [opt boundingRectWithSize:CGSizeMake(302 - 15 - 15 - 35 - 10 - 40, 150) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                        
                    //    CGSize optSize = [opt sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(302 - 15 - 15 - 35 - 10 - 40, 150) lineBreakMode:NSLineBreakByWordWrapping];
                        height += optSize.height;
                        height += 10;
                        
                        NSString *name = optArray[i][@"username"];
                        if([pollDic[@"is_anon"]isEqualToString:@"0"] &&
                           [pollDic[@"num_pollee"]intValue]<30 &&
                           [name length]>0 &&
                           [pollDic[@"is_visible_dstatus"]isEqualToString:@"0"])
                        {
                            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
                            CGSize nameSize = [name boundingRectWithSize:CGSizeMake(302  - 15 - 15 - 35 - 10 - 30, 100) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    //        CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(302  - 15 - 15 - 35 - 10 - 30, 100) lineBreakMode:NSLineBreakByWordWrapping];
                            height += nameSize.height + 15;
                        }
                        else{
                            height += 5;
                            
                        }
                        
                        height+= 1; //line
                        
                        
                        
                    }
                    
                    if([pollDic[@"is_close"]isEqualToString:@"1"]){
                    }
                    else{
                        height += 10 + 38; // two buttons
                    }
                    
                    if([pollDic[@"is_visible_dstatus"]isEqualToString:@"1"]){
                        height += 10 + 38; // detail button
                    }
                    
                    height += 10; // gap
#endif
                    
                }
                
                if([fileArray count]>0){
                    
#ifdef BearTalk
                    
                 
                    height += 10; // gap;
                    
                    
                    height += 47*[fileArray count]+8*([fileArray count]-1);
                    

                    
#else
                    height += 65*[fileArray count];
#endif
//                    height += 5;
                }
                
            }
            
            
            
            
            
            
            if([contentsData.contentType isEqualToString:@"7"]){
                NSDictionary *yourDic = [SharedAppDelegate.root searchContactDictionary:contentsData.profileImage];
                if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    height += 5+40; // gap + option
                }
                
                else if([yourDic[@"newfield3"]isEqualToString:@"40"]){
                    
                }
                else{
#ifdef MQM
#else
                    height += 5 + 40;// optionview // replynote
#endif
                }
            }
            else if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
            {
            }
            else{
                
                if(!([contentsData.contentType isEqualToString:@"9"] && [[contentsData.targetdic objectFromJSONString][@"category"]isEqualToString:@"3"])){
                    height += 5 + 45;// gap + optionview
                }
                else{
                    if([replyArray count]==0){
                        
                    }
                    else{
                        height += 5 + 45;//  gap + optionview
                    }
                }
            }
        }
        //        height += 10; // gap
      
        return height;
        
    }
    
    else{
        NSLog(@"*************** indexpath.row != 0 ***********************************");
        NSLog(@"here contype %@",contentsData.contentType);
        NSLog(@"here writeinfoType %@",contentsData.writeinfoType);
        if([contentsData.contentType isEqualToString:@"7"]){
            float height = 0;
            height += 40;
            return height;
        }
        else if([contentsData.contentType isEqualToString:@"4"]){ // cafeteria menu
            
            float height = 0;
            
            height += (21+18); // name, gap, bound
            //        height += 15;
            if([replyArray count]>0){
                height += 12; // last gap
                if([replyArray[indexPath.row-1][@"writeinfotype"]intValue]>4 && [replyArray[indexPath.row-1][@"writeinfotype"]intValue]!=10){
                    height += 34;
                }
                else{
                    NSString *replyCon = [replyArray[indexPath.row-1][@"replymsg"]objectFromJSONString][@"msg"];
                    
#ifdef BearTalk
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:rfontSize], NSParagraphStyleAttributeName:paragraphStyle};
                    CGSize rsize = [replyCon boundingRectWithSize:CGSizeMake(self.view.frame.size.width - (16+33+7+16), 10000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
                    
#else
                    
#endif
                    
                    if([replyArray[indexPath.row-1][@"writeinfotype"]isEqualToString:@"1"]){
                        for(NSDictionary *replyDic in replyArray){
                            
                            NSString *searchName = [NSString stringWithFormat:@"@%@",[replyDic[@"writeinfo"]objectFromJSONString][@"name"]];
                            //                            NSLog(@"searchName %@",searchName);
                            NSRange range = [replyCon rangeOfString:searchName];
                            if (range.length > 0){
                                NSLog(@"String contains");
                                
                                NSString *htmlString = @"";
#ifdef Batong
                                htmlString = [NSString stringWithFormat:@"<font color=\"#000000\"><b>%@</b></font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#else
                                htmlString = [NSString stringWithFormat:@"<font color=\"#a01213\">%@</font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#endif
                                //                            NSLog(@"replycon1 %@",replyCon);
                                //                            replyCon = [replyCon stringByReplacingCharactersInRange:range withString:htmlString];
                                replyCon = [replyCon stringByReplacingOccurrencesOfString:searchName withString:htmlString];
                                //                            NSLog(@"replycon2 %@",replyCon);
                            }
                        }
                    }
                    
                    replyCon = [replyCon stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
                    
                    
//                    CGSize replySize;
                    CGRect replyrect;
                    
                    
                        
                        NSString *htmlString = [NSString stringWithFormat:@"<html>"
                                                "<head>"
                                                "<style type=\"text/css\">"
                                                "body {font-family: \"%@\"; font-size: %i; height: auto; }"
                                                "</style>"
                                                "</head>"
                                                "<body>%@</body>"
                                                "</html>", @".SFUIText-Regular",rfontSize, replyCon];
                        
                        NSData *htmlDATA = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
                        
                        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:htmlDATA options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
                        NSLog(@"**attrStr %@",attrStr);
                        

                    
#ifdef BearTalk
                    
                    UITextView *replyContentsTextView = [[UITextView alloc]init];
                          [replyContentsTextView setAttributedText:attrStr];
                    height += [replyContentsTextView sizeThatFits:CGSizeMake(self.view.frame.size.width - (16+33+7+16), 10000)].height;//ceilf(CGRectGetHeight(replyrect));
                    NSLog(@"sizethatfitsize row %d %f",indexPath.row-1,[replyContentsTextView sizeThatFits:CGSizeMake(self.view.frame.size.width - (16+33+7+16), 10000)].height);
                    NSLog(@"replyTextViewFrame3 %f",rsize.height);
                    height -= 12;
#else
                    
                    replyrect = [attrStr boundingRectWithSize:CGSizeMake(240, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
                    height += ceilf(CGRectGetHeight(replyrect)) + 22;
#endif
                    
                    
#if defined(Batong) || defined(BearTalk)
                    NSString *emoticonString = [replyArray[indexPath.row-1][@"replymsg"]objectFromJSONString][@"emoticon"];
                    if([emoticonString length]>0){
#ifdef BearTalk
                        height += 100+7;
#else
                        height += 100-12;
#endif
                    }
#endif
                }
            }
            return height;
            
        }
        else if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
            // like default
            float height = 0;
            
            height += 70; // defaultview
            
            
            
            
            NSLog(@"ReplyArray %@",replyArray);
            NSDictionary *replydic = replyArray[indexPath.row-1];
            
            NSDictionary *replyContentDic = [replydic[@"replymsg"]objectFromJSONString];
            NSString *content = replyContentDic[@"msg"];
            NSString *imageString = replyContentDic[@"image"];
            
            //                CGSize cSize = [content sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(295, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:fontSize] width:300 realZeroInsets:NO];
            
            //                NSLog(@"else content %@",content);
            NSLog(@"else content %f %f",cSize.width,cSize.height);
            height += cSize.height + 5;
            
            if(imageString != nil && [imageString length]>0)
            {
                
                NSArray *imageArray;
                
#ifdef BearTalk
                imageArray = [imageString objectFromJSONString][@"filename"];
#else
                
                imageArray = [imageString objectFromJSONString][@"thumbnail"];
#endif
                for(int i = 0; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
                    NSDictionary *sizeDic;
                    if([[imageString objectFromJSONString][@"thumbnailinfoarray"]count]>0)
                        sizeDic = [imageString objectFromJSONString][@"thumbnailinfoarray"][i];
                    else
                        sizeDic = [imageString objectFromJSONString][@"thumbnailinfo"];
                    
                    
                    CGFloat imageScale = 0.0f;
                    imageScale = 300/[sizeDic[@"width"]floatValue];
                    
                    NSLog(@"else image");
                    height += (imageScale * [sizeDic[@"height"]floatValue]+10);//300 *[[imageString objectFromJSONString][@"thumbnail"]count];//imageScale * [sizeDic[@"height"]floatValue];
                }
                height += 5;
            }
            
            if([replydic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
                height += 50;
            }
            
            
            
#if defined(Batong) || defined(BearTalk)
            if([replyContentDic[@"emoticon"]length]>0)
                height += 100+7;//+5;
#endif
            
            
            
            
            return height;
            
            
            
        }
        else{// if([contentsData.type isEqualToString:@"1"]){
            
#ifdef GreenTalkCustomer
            
            
            if([contentsData.contentType isEqualToString:@"1"] && [contentsData.writeinfoType isEqualToString:@"0"]){
                
                NSLog(@"here e");
                int row = 0;
                row = (int)indexPath.row-1;
                
                
                
                float height = 0;
                
                height += (21+18); // name, gap, bound
                //        height += 15;
                if([replyArray count]>0){
                    if([replyArray[row][@"writeinfotype"]intValue]>4 && [replyArray[row][@"writeinfotype"]intValue]!=10){
                        height += 34;
                    }
                    else{
                        NSString *replyCon = [replyArray[row][@"replymsg"]objectFromJSONString][@"msg"];

                        
                        //                        CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                        if([replyArray[row][@"writeinfotype"]isEqualToString:@"1"]){
                            for(NSDictionary *replyDic in replyArray){
                                
                                NSString *searchName = [NSString stringWithFormat:@"@%@",[replyDic[@"writeinfo"]objectFromJSONString][@"name"]];
                                //                            NSLog(@"searchName %@",searchName);
                                NSRange range = [replyCon rangeOfString:searchName];
                                if (range.length > 0){
                                    NSLog(@"String contains");
                                    
                                    NSString *htmlString = @"";
#ifdef Batong
                                    htmlString = [NSString stringWithFormat:@"<font color=\"#000000\"><b>%@</b></font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#else
                                    htmlString = [NSString stringWithFormat:@"<font color=\"#a01213\">%@</font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#endif
                                    //                            NSLog(@"replycon1 %@",replyCon);
                                    //                            replyCon = [replyCon stringByReplacingCharactersInRange:range withString:htmlString];
                                    replyCon = [replyCon stringByReplacingOccurrencesOfString:searchName withString:htmlString];
                                    //                            NSLog(@"replycon2 %@",replyCon);
                                }
                            }
                        }
                        replyCon = [replyCon stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];

//                        CGSize replySize;
                        CGRect replyrect;
                        
                        
                            
                            
                            NSString *htmlString = [NSString stringWithFormat:@"<html>"
                                                    "<head>"
                                                    "<style type=\"text/css\">"
                                                    "body {font-family: \"%@\"; font-size: %i; height: auto; }"
                                                    "</style>"
                                                    "</head>"
                                                    "<body>%@</body>"
                                                    "</html>",  @".SFUIText-Regular",rfontSize, replyCon];
                            
                            NSData *htmlDATA = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
                            
                            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:htmlDATA options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
                            NSLog(@"**attrStr %@",attrStr);
                            
//                                                    NSLog(@"**attrStr %@",attrStr);
                        
//                                                    NSLog(@"**replySizerect %@",NSStringFromCGRect(rect));
//                                                    replySize = rect.size;//
//                            replySize = [SharedFunctions htmltextViewSizeForString:htmlString font:[UIFont systemFontOfSize:fontSize] width:250 realZeroInsets:NO fontSize:fontSize];
//                            NSLog(@"**replySize %@",NSStringFromCGSize(replySize));
//                            [attrStr release];

                        
                        
                        replyrect = [attrStr boundingRectWithSize:CGSizeMake(240, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
                        height += ceilf(CGRectGetHeight(replyrect)) + 22;

                        
                        
//                        NSLog(@"replyCon %@ replySize %f %f",replyCon,replySize.width,replySize.height);
                        
                        NSString *replyPhotoUrl = [replyArray[row][@"replymsg"]objectFromJSONString][@"image"];
                        NSLog(@"replyphotourl %@",replyPhotoUrl);
                        if([replyPhotoUrl length]>0){
                            
                            NSDictionary *sizeDic = [replyPhotoUrl objectFromJSONString][@"thumbnailinfo"];
                            //                                                CGSize imageSize;
                            //                                                imageSize = image.size;
                            
                            NSLog(@"sizeDic %@",sizeDic);
                            NSLog(@"height %f",height);
                            CGFloat imageScale = 0.0f;
                            if([sizeDic[@"width"]floatValue]>120.0f){
                                imageScale = [sizeDic[@"width"]floatValue]/120.0f;
                                height += [sizeDic[@"height"]floatValue]/imageScale;
                            }
                            else{
                                imageScale = 120.0f/[sizeDic[@"width"]floatValue];
                                height += [sizeDic[@"height"]floatValue]*imageScale;
                                
                            }
                            NSLog(@"height %f",height);
                            //                            CGFloat imageScale = [[sizeDicobjectForKey:@"width"]intValue]/120;
                            //                            height += [[sizeDicobjectForKey:@"height"]intValue]/imageScale + 10;
//                            height += 10;
                            
                            height+= 7; // gap
                        }
                        

                    }
                    
            }
            return height;
                
                
            }
#endif
            
            
#if defined(GreenTalkCustomer) || defined(BearTalk)
#else
            if(indexPath.row == 1 && [likeArray count]>0){
                
                NSLog(@"******************* not gc indexpath.row 1 ***********************************");
                return 36;
                
            }
            else{
#endif
                
                NSLog(@"gc ************************* gc indexpath.row != 0 *******************************");
                int row = 0;
                if([likeArray count]>0){
                    NSLog(@"************************* indexpath.row 2 *************************************");
#ifdef GreenTalkCustomer
                    row = (int)indexPath.row-1;

#else
                    row = (int)indexPath.row-2;
#endif
                }
                else{
                    NSLog(@"*************************  indexpath.row 1 *******************************");
                    row = (int)indexPath.row-1;
                }
#ifdef BearTalk
                if(indexPath.row == 1)
                    return 1+12+20+12+1;
                
                row = (int)indexPath.row - 2;
#endif
                
                
                NSDictionary *replydic = replyArray[row];
                
                
                float height = 0;
#ifdef BearTalk
                height += 12+12+7; // textview y
#else
                height += (21+18); // name, gap, bound
#endif
                //        height += 15;
                if([replyArray count]>0){
                    height += 12; // last gap
                    
                    if([replyArray[row][@"writeinfotype"]intValue]>4 && [replyArray[row][@"writeinfotype"]intValue]!=10){
                        height += 34;
                    }
                    else{
                        
                        
                        NSString *replyCon = [replyArray[row][@"replymsg"]objectFromJSONString][@"msg"];
#ifdef BearTalk
                        NSString *originReplyCon = replyCon;
                        
                        
#else
                        
#endif
                        //                        CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                        if([replyArray[row][@"writeinfotype"]isEqualToString:@"1"]){
                            for(NSDictionary *replyDic in replyArray){
                                
                                NSString *searchName = [NSString stringWithFormat:@"@%@",[replyDic[@"writeinfo"]objectFromJSONString][@"name"]];
                                //                            NSLog(@"searchName %@",searchName);
                                NSRange range = [replyCon rangeOfString:searchName];
                                if (range.length > 0){
                                    NSLog(@"String contains");
                                    
                                    NSString *htmlString = @"";
#ifdef Batong
                                    htmlString = [NSString stringWithFormat:@"<font color=\"#000000\"><b>%@</b></font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#else
                                    htmlString = [NSString stringWithFormat:@"<font color=\"#a01213\">%@</font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#endif
                                    //                            NSLog(@"replycon1 %@",replyCon);
                                    //                            replyCon = [replyCon stringByReplacingCharactersInRange:range withString:htmlString];
                                    replyCon = [replyCon stringByReplacingOccurrencesOfString:searchName withString:htmlString];
                                    //                            NSLog(@"replycon2 %@",replyCon);
                                }
                            }
                        }
                        
                        replyCon = [replyCon stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];

//                        CGSize replySize;
                        CGRect replyrect;
                        
                        
                            NSString *htmlString = [NSString stringWithFormat:@"<html>"
                                                    "<head>"
                                                    "<style type=\"text/css\">"
                                                    "body {font-family: \"%@\"; font-size: %i; height: auto; }"
                                                    "</style>"
                                                    "</head>"
                                                    "<body>%@</body>"
                                                    "</html>",  @".SFUIText-Regular",rfontSize, replyCon];
                            
                            NSData *htmlDATA = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
                            
                            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:htmlDATA options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
                            NSLog(@"**attrStr %@",attrStr);
                            
                        
                        
                        if([replydic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID] && [replydic[@"writeinfotype"]isEqualToString:@"1"]){
                            NSLog(@"replydic %@",replydic);
                            
#ifdef BearTalk
#else
                            replyrect = [attrStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 16 - 33 - 7 - 16 - 33, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
               
#endif
                        }
                        else{
                            
                            replyrect = [attrStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 16 - 33 - 7 - 16, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
                            
                        }
                        
#ifdef BearTalk
                        
                        
                        UITextView *replyContentsTextView = [[UITextView alloc]init];
                        [replyContentsTextView setAttributedText:attrStr];
                        height += [replyContentsTextView sizeThatFits:CGSizeMake(self.view.frame.size.width - (16+33+7+16), 10000)].height;//ceilf(CGRectGetHeight(replyrect));
                        NSLog(@"sizethatfitsize5 %d %f",row,[replyContentsTextView sizeThatFits:CGSizeMake(self.view.frame.size.width - (16+33+7+16), 10000)].height);
                        
                        height -= 12;
                        
#else
                        height += ceilf(CGRectGetHeight(replyrect)) + 22;
                        
#endif
                                                    NSLog(@"**replySizerect %@",NSStringFromCGRect(replyrect));
//                                                    replySize = rect.size;//
//                            replySize = [SharedFunctions htmltextViewSizeForString:htmlString font:[UIFont systemFontOfSize:fontSize] width:250 realZeroInsets:NO fontSize:fontSize];
//                            NSLog(@"**replySize %@",NSStringFromCGSize(replySize));
//                            [attrStr release];

                        
                        
//                        NSLog(@"replyCon %@ replySize %f %f",replyCon,replySize.width,replySize.height);
                        
                        NSString *replyPhotoUrl = [replyArray[row][@"replymsg"]objectFromJSONString][@"image"];
                        NSLog(@"replyphotourl %@",replyPhotoUrl);
                        if([replyPhotoUrl length]>0){
                            
                            NSDictionary *sizeDic = [replyPhotoUrl objectFromJSONString][@"thumbnailinfo"];
                            //                                                CGSize imageSize;
                            //                                                imageSize = image.size;
                            
                            NSLog(@"sizeDic %@",sizeDic);
                            NSLog(@"height %f",height);
                            CGFloat imageScale = 0.0f;
                            if([sizeDic[@"width"]floatValue]>120.0f){
                                imageScale = [sizeDic[@"width"]floatValue]/120.0f;
                                height += [sizeDic[@"height"]floatValue]/imageScale;
                            }
                            else{
                                imageScale = 120.0f/[sizeDic[@"width"]floatValue];
                                height += [sizeDic[@"height"]floatValue]*imageScale;
                                
                            }
                            NSLog(@"height %f",height);
                            //                            CGFloat imageScale = [[sizeDicobjectForKey:@"width"]intValue]/120;
                            //                            height += [[sizeDicobjectForKey:@"height"]intValue]/imageScale + 10;
 //                           height += 10;
                            height+= +7; // gap
                        }
                        
#if defined(Batong) || defined(BearTalk)
                        NSString *emoticonString = [replyArray[row][@"replymsg"]objectFromJSONString][@"emoticon"];
                        if([emoticonString length]>0){
                        
#ifdef BearTalk
                                height += 7+100;
#elif Batong
                                height += 100-12;
#endif
                        }
#endif
                    }
                }
                
                return height;
                
#if defined(GreenTalkCustomer) || defined(BearTalk)
#else
            }
#endif
        }
    }
    
    
}


#pragma mark - menu controller menu items



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if([contentsData.type isEqualToString:@"5"]) // 좋아요 불가 / 댓글 불가 / 상세보기 가능
    {
        if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
            return [replyArray count]>0?[replyArray count]+1:1;
        else
            return [replyArray count]+1; // 받은사람리스트 + 컨텐츠
    }
    else if([contentsData.contentType isEqualToString:@"9"] && [[contentsData.targetdic objectFromJSONString][@"category"]isEqualToString:@"3"])
        return [replyArray count]+1;
    else{
#ifdef GreenTalkCustomer
        return [replyArray count]+1;
#elif BearTalk
        return [replyArray count]+2;
#else
        if([likeArray count]>0)
            return [replyArray count]+2;
        else
            return [replyArray count]+1;
#endif
    }
}

//#define kDetail 1
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didselect %d",(int)indexPath.row);
    NSLog(@"contentsdata.type %@",contentsData.type);
    NSLog(@"tagArray %@",tagArray);
    
//    if(![contentsData.type isEqualToString:@"5"]){
//        if(indexPath.row == 1 && [likeArray count]>0){
//            if([self.parentViewCon respondsToSelector:@selector(pushGood:con:)])
//            [(HomeTimelineViewController *)self.parentViewCon pushGood:likeArray con:self];
//                }
//        
//    }
}

- (void)tagName:(id)sender{
    
    
    NSDictionary *replyDic = [SharedAppDelegate.root searchContactDictionary:[[sender titleLabel]text]];
    if([replyDic[@"uniqueid"]length]<1 || replyDic[@"uniqueid"]==nil)
    {
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"직원 정보가 없습니다." con:self];
        return;
    }
    BOOL alreadyTag = NO;
    NSLog(@"tagArray %@",tagArray);
    for(NSDictionary *dic in tagArray){
        if([dic[@"uniqueid"]isEqualToString:[[sender titleLabel]text]])
            alreadyTag = YES;
    }
    NSLog(@"alreadyTag %@",alreadyTag?@"YES":@"NO");
    if(!alreadyTag)
        [tagArray addObject:replyDic];
    
    [placeHolderLabel setHidden:YES];
#ifdef BearTalk
#else
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
#endif
    
    
    NSString *contentsToAdd = [NSString stringWithFormat:@"@%@ ",replyDic[@"name"]];
    NSLog(@"contentstoAdd %@",contentsToAdd);
    NSRange cursorPosition = [replyTextView selectedRange];
    NSLog(@"replytextview %@",replyTextView.text);
    NSMutableString *tfContent = [[NSMutableString alloc]initWithString:[replyTextView text]];
    [tfContent insertString:contentsToAdd atIndex:cursorPosition.location];
    NSLog(@"replytextview %@",tfContent);
    [replyTextView setText:tfContent];
//    [tfContent release];
    
    //    replyTextView.text = [replyTextView.text stringByAppendingFormat:@"@%@ ",replyDic[@"name"]];
    
    
    NSInteger oldLineCount = msgLineCount;
    
    NSInteger lineCount = (NSInteger)(([self measureHeightOfUITextView:replyTextView origin:@""] - 16) / replyTextView.font.lineHeight);
    //    NSInteger lineCount = (NSInteger)((replyTextView.contentSize.height - 16) / replyTextView.font.lineHeight);
    
    if (msgLineCount != lineCount) {
        if (lineCount > MAX_MESSAGEEND_LINE)
            msgLineCount = MAX_MESSAGEEND_LINE;
        else
            msgLineCount = lineCount;
    }
    
    if (msgLineCount != oldLineCount)
        [self viewResizeUpdate:msgLineCount];
    
    [replyTextView setSelectedRange:NSMakeRange([replyTextView.text length], 0)];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
   SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
#ifdef BearTalk
        cell.rightUtilityButtons = [self rightButtons:(int)indexPath.row];
        cell.delegate = self;
#endif
    }
    
    
    NSInteger fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalFontSize"];
    NSInteger rfontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"GlobalrFontSize"];
    
    NSLog(@"fontSize %d rFontSize %d",fontSize,rfontSize);
    if(indexPath.row == 0){
        
        
#ifdef BearTalk
        NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"themeColor"]; // [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        
        UIView *defaultView = [[UIView alloc]init];
        defaultView.frame = CGRectMake(0, 0, self.view.frame.size.width, 14+42+14);
        [cell.contentView addSubview:defaultView];
        defaultView.backgroundColor = [UIColor clearColor];
        //        [defaultView release];
        if([contentsData.writeinfoType isEqualToString:@"0"]){
            
            defaultView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
        }
        
        
        UIView *contentsView = [[UIView alloc]init];
        contentsView.frame = CGRectMake(0, CGRectGetMaxY(defaultView.frame), self.view.frame.size.width, 0);
        [cell.contentView addSubview:contentsView];
        contentsView.backgroundColor = [UIColor clearColor];
        //        [contentsView release];
        
        UIView *optionView = [[UIView alloc]init];
        optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame), self.view.frame.size.width, 0);
        [cell.contentView addSubview:optionView];
        optionView.backgroundColor = [UIColor clearColor];
        //        [optionView release];
        
        UIImageView *profileImageView;
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 42, 42)];
        NSLog(@"contentsdata.profile %@",contentsData.profileImage);
        profileImageView.userInteractionEnabled = YES;
        [defaultView addSubview:profileImageView];
        //        [profileImageView release];
        
        
        
        UIImageView *roundingView;
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileImageView addSubview:roundingView];
        
        
        UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height)];
        viewButton.adjustsImageWhenHighlighted = NO;
        [viewButton addTarget:self action:@selector(goToYourTimeline:) forControlEvents:UIControlEventTouchUpInside];
        viewButton.titleLabel.text = contentsData.profileImage;
        [profileImageView addSubview:viewButton];
        //        [viewButton release];
        
        
        UILabel *nameLabel;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(profileImageView.frame) + 8, profileImageView.frame.origin.y+5, 85, 17)];
        
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        //		[nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14]];
        //		[nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextColor:RGB(32, 32, 32)];
        
        [defaultView addSubview:nameLabel];
        //        [nameLabel release];
        
        //
        UILabel *positionLabel;
        positionLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(nameLabel.frame.origin.x + [nameLabel.text length] * 14, nameLabel.frame.origin.y, 80, 16)];
        [positionLabel setBackgroundColor:[UIColor clearColor]];
        [positionLabel setTextColor:RGB(151,152,157)];
        [positionLabel setFont:[UIFont systemFontOfSize:12]];
        [defaultView addSubview:positionLabel];

#else
        UIView *defaultView = [[UIView alloc]init];
        defaultView.frame = CGRectMake(0, 0, 320, 70);
        [cell.contentView addSubview:defaultView];
        defaultView.backgroundColor = [UIColor clearColor];
//        [defaultView release];
        if([contentsData.writeinfoType isEqualToString:@"0"]){
            
            defaultView.frame = CGRectMake(0, 0, 320, 0);
        }
        
        
        UIView *contentsView = [[UIView alloc]init];
        contentsView.frame = CGRectMake(0, CGRectGetMaxY(defaultView.frame)+5, 320, 0);
        [cell.contentView addSubview:contentsView];
        contentsView.backgroundColor = [UIColor clearColor];
//        [contentsView release];
        
        UIView *optionView = [[UIView alloc]init];
        optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame)+5, 320, 0);
        [cell.contentView addSubview:optionView];
        optionView.backgroundColor = [UIColor clearColor];
//        [optionView release];
        
        UIImageView *profileImageView;
        profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
        NSLog(@"contentsdata.profile %@",contentsData.profileImage);
        profileImageView.userInteractionEnabled = YES;
        [defaultView addSubview:profileImageView];
//        [profileImageView release];
        
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        UIImageView *roundingView;
        roundingView = [[UIImageView alloc]init];
        roundingView.frame = CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height);
        roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
        [profileImageView addSubview:roundingView];
//        [roundingView release];
#endif
        UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height)];
        viewButton.adjustsImageWhenHighlighted = NO;
        [viewButton addTarget:self action:@selector(goToYourTimeline:) forControlEvents:UIControlEventTouchUpInside];
        viewButton.titleLabel.text = contentsData.profileImage;
        [profileImageView addSubview:viewButton];
//        [viewButton release];
        
        
        UILabel *nameLabel;
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, 12, 80, 16)];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        //		[nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setFont:[UIFont boldSystemFontOfSize:14]];
        //		[nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [defaultView addSubview:nameLabel];
//        [nameLabel release];
        
        //
        UILabel *positionLabel;
        positionLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(nameLabel.frame.origin.x + [nameLabel.text length] * 14, nameLabel.frame.origin.y, 80, 16)];
        [positionLabel setBackgroundColor:[UIColor clearColor]];
        [positionLabel setTextColor:[UIColor grayColor]];
        [positionLabel setFont:[UIFont systemFontOfSize:14]];
        [defaultView addSubview:positionLabel];
//        [positionLabel release];
        
//        UILabel *teamLabel;
//        teamLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(positionLabel.frame.origin.x + [positionLabel.text length] * 14, positionLabel.frame.origin.y, 80, 16)];
//        [teamLabel setBackgroundColor:[UIColor clearColor]];
//        [teamLabel setTextColor:[UIColor grayColor]];
//        [teamLabel setFont:[UIFont systemFontOfSize:14]];
//        [defaultView addSubview:teamLabel];
//        [teamLabel release];
        
#endif
        if([contentsData.writeinfoType isEqualToString:@"2"]){
            [nameLabel setTextColor:RGB(160, 18, 19)];
            [nameLabel setText:contentsData.personInfo[@"deptname"]];
            //        [SharedAppDelegate.root getThumbImageWithURL:[contentsData.personInfoobjectForKey:@"image"] ifNil:@"list_profile_company.png" view:profileImageView scale:7];
            NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:contentsData.personInfo[@"image"] num:0 thumbnail:YES];
            if (imgURL) {
                [profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL
                                                        andPlaceholderImage:[UIImage imageNamed:@"list_profile_company.png"]
                                                                    options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                                   progress:^(NSInteger a, NSInteger b)  {
                                                                   }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                                       NSLog(@"fail %@",[error localizedDescription]);
                                                                       if (image != nil) {
                                                                           [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                                                               [profileImageView setImage:roundedImage];
                                                                           }];
                                                                       }
                                                                       
                                                                       [HTTPExceptionHandler handlingByError:error];
                                                                       
                                                                   }];
            } else {
                profileImageView.image = [UIImage imageNamed:@"list_profile_company.png"];
            }
            //        [profileImageView setImage:[SharedAppDelegate.root roundCornersOfImage:profileImageView.image scale:24]];
            
        }
        else if([contentsData.writeinfoType isEqualToString:@"3"]){
            
            [nameLabel setTextColor:RGB(160, 18, 19)];
            [nameLabel setText:contentsData.personInfo[@"companyname"]];
            //        [SharedAppDelegate.root getThumbImageWithURL:[contentsData.personInfoobjectForKey:@"image"] ifNil:@"list_profile_company.png" view:profileImageView scale:7];
            NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:contentsData.personInfo[@"image"] num:0 thumbnail:YES];
            if (imgURL) {
                [profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL
                                                        andPlaceholderImage:[UIImage imageNamed:@"list_profile_company.png"]
                                                                    options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                                   progress:^(NSInteger a, NSInteger b)  {
                                                                   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                                       NSLog(@"fail %@",[error localizedDescription]);
                                                                       if (image != nil) {
                                                                           [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                                                               [profileImageView setImage:roundedImage];
                                                                           }];
                                                                       }
                                                                       
                                                                       [HTTPExceptionHandler handlingByError:error];
                                                                       
                                                                   }];
            } else {
                profileImageView.image = [UIImage imageNamed:@"list_profile_company.png"];
            }
            
            //        [profileImageView setImage:[SharedAppDelegate.root roundCornersOfImage:profileImageView.image scale:24]];
        }
        else if([contentsData.writeinfoType isEqualToString:@"4"]){
            
            //        subImageView.image = [UIImage imageNamed:@"n01_tl_realic_lemp.png"];
            [nameLabel setText:contentsData.personInfo[@"text"]];
            nameLabel.textColor = RGB(160, 18, 19);
            //        [SharedAppDelegate.root getThumbImageWithURL:[contentsData.personInfoobjectForKey:@"image"] ifNil:@"list_profile_systeam.png" view:profileImageView scale:7];
            NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:contentsData.personInfo[@"image"] num:0 thumbnail:YES];
            if (imgURL) {
                [profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL
                                                        andPlaceholderImage:[UIImage imageNamed:@"list_profile_systeam.png"]
                                                                    options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                                   progress:^(NSInteger a, NSInteger b)  {
                                                                   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                                                                       NSLog(@"fail %@",[error localizedDescription]);
                                                                       if (image != nil) {
                                                                           [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                                                               [profileImageView setImage:roundedImage];
                                                                           }];
                                                                       }
                                                                       
                                                                       [HTTPExceptionHandler handlingByError:error];
                                                                       
                                                                   }];
            } else {
                profileImageView.image = [UIImage imageNamed:@"list_profile_systeam.png"];
            }
            
        }
        else if([contentsData.writeinfoType isEqualToString:@"1"]){
            [nameLabel setText:contentsData.personInfo[@"name"]];
            CGSize size = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
            
#ifdef BearTalk
            positionLabel.frame = CGRectMake(nameLabel.frame.origin.x + (size.width+5>90?90:size.width+5), nameLabel.frame.origin.y, 170, 16);
#else
            [nameLabel setTextColor:RGB(87, 107, 149)];
            positionLabel.frame = CGRectMake(nameLabel.frame.origin.x + (size.width+5>80?80:size.width+5), nameLabel.frame.origin.y, 170, 16);
#endif
            
            
            [SharedAppDelegate.root getProfileImageWithURL:contentsData.profileImage ifNil:@"profile_photo.png" view:profileImageView scale:24];
            
            positionLabel.text = [NSString stringWithFormat:@"%@ | %@",contentsData.personInfo[@"position"],contentsData.personInfo[@"deptname"]];
#ifdef Batong
            if([contentsData.personInfo[@"position"]length]>0)
            positionLabel.text = [NSString stringWithFormat:@"%@ | %@",contentsData.personInfo[@"deptname"],contentsData.personInfo[@"position"]];
            else
                positionLabel.text = [NSString stringWithFormat:@"%@",contentsData.personInfo[@"deptname"]];
#endif
            
        }
        else if([contentsData.writeinfoType isEqualToString:@"10"]){
            [nameLabel setTextColor:RGB(87, 107, 149)];
            
            [nameLabel setText:@"익명"];
            [positionLabel setText:@""];
//            [teamLabel setText:@""];
            
            [profileImageView setImage:[UIImage imageNamed:@"sns_anonym.png"]];
            
            
        }
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        nameLabel.textColor = GreenTalkColor;
#endif
        timeLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(whLabel.frame.origin.x, contentImageView.frame.origin.y + contentImageView.frame.size.height + 6, whLabel.frame.size.width, 13)];//(3, 42, 38, 13)];
        timeLabel.frame = CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame), 300 - nameLabel.frame.origin.x - 40, 20);
#ifdef Beartalk
        timeLabel.frame = CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame) + 6, 100, 14);
        readLabel.frame = CGRectMake(CGRectGetMaxX(timeLabel.frame)+5, timeLabel.frame.origin.y, 100, timeLabel.frame.size.height);
        
#endif
        [timeLabel setText:[NSString formattingDate:contentsData.writetime withFormat:@"yy/MM/dd a h:mm"]];//dateString];
        [timeLabel setTextColor:[UIColor grayColor]];
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [defaultView addSubview:timeLabel];
//        [timeLabel release];
        if([contentsData.writeinfoType isEqualToString:@"0"]){
            
            
            [nameLabel setText:@""];
            [positionLabel setText:@""];
//            [teamLabel setText:@""];
            [timeLabel setText:@""];
            [profileImageView setImage:nil];
        }
        
        NSString *toString = @"";
        UILabel *arrLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:RGB(64,88,115) frame:CGRectMake(profileImageView.frame.origin.x, CGRectGetMaxY(profileImageView.frame)+5, 20, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        UILabel *toLabel = [CustomUIKit labelWithText:@"" fontSize:14 fontColor:RGB(64,88,115) frame:CGRectMake(CGRectGetMaxX(arrLabel.frame), arrLabel.frame.origin.y, 300-20, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
        
#if defined(GreenTalk) || defined(GreenTalkCustomer)
        arrLabel.textColor = GreenTalkColor;
        toLabel.textColor = GreenTalkColor;
#endif
        
        if([contentsData.contentType isEqualToString:@"7"] && [replyArray count]>0){
            
            if([replyArray count]==1)
                toString = [NSString stringWithFormat:@"%@",[replyArray[0]objectFromJSONString][@"name"]];
            
            
            else if([replyArray count]==2)
                toString = [NSString stringWithFormat:@"%@, %@",[replyArray[0]objectFromJSONString][@"name"],[replyArray[1]objectFromJSONString][@"name"]];
            
            
            else if([replyArray count]>2)
                toString = [NSString stringWithFormat:@"%@, %@ 외 %d명",[replyArray[0]objectFromJSONString][@"name"],[replyArray[1]objectFromJSONString][@"name"],(int)[replyArray count]-2];
            
            [toLabel setText:toString];
            [arrLabel setText:@"➤"];
        }
        [defaultView addSubview:arrLabel];
        [defaultView addSubview:toLabel];
        
        
        
        
        UITextView *contentsTextView;
        contentsTextView = [[UITextView alloc] init];//WithFrame:CGRectMake(5, 0, 295, contentSize.height + 25)];
        
        
        [contentsTextView setTextAlignment:NSTextAlignmentLeft];
        contentsTextView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        [contentsTextView setDataDetectorTypes:UIDataDetectorTypeLink];
        [contentsTextView setFont:[UIFont systemFontOfSize:fontSize]];
        [contentsTextView setBackgroundColor:[UIColor clearColor]];
        [contentsTextView setEditable:NO];
        [contentsTextView setDelegate:self];
        contentsTextView.scrollsToTop = NO;
        [contentsTextView setScrollEnabled:NO];
        [contentsTextView sizeToFit];
        [contentsView addSubview:contentsTextView];
//        [contentsTextView release];
        
        UIImageView *whImageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(12, defaultView.frame.origin.y + defaultView.frame.size.height, 12, 17)];
        whImageView.image = [UIImage imageNamed:@"imageview_schedule_icon_location.png"];
        [contentsView addSubview:whImageView];
//        [whImageView release];
        
        
        UILabel *whLabel;
        whLabel = [[UILabel alloc]init];
        [whLabel setTextAlignment:NSTextAlignmentLeft];
        [whLabel setFont:[UIFont systemFontOfSize:14]];
        [whLabel setBackgroundColor:[UIColor clearColor]];
        [whLabel setTextColor:[UIColor grayColor]];//RGB(216, 68, 60)];
        [contentsView addSubview:whLabel];
//        [whLabel release];
        
        contentImageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, contentsTextView.frame.size.height + whLabel.frame.size.height + 5, 290, 0)];
        [contentsView addSubview:contentImageView];
//        [contentImageView release];
        
        
        
        UIImageView *pollView = [[UIImageView alloc]initWithFrame:CGRectMake(3, contentImageView.frame.origin.y + contentImageView.frame.size.height + 5, 302, 0)];
        pollView.image = [UIImage imageNamed:@"vote_deepviewbg.png"];
        [contentsView addSubview:pollView];
//        [pollView release];
        
        UIImageView *fileView = [[UIImageView alloc]init];
        fileView.image = [UIImage imageNamed:@"vote_deepviewbg.png"];
        fileView.userInteractionEnabled = YES;
        [contentsView addSubview:fileView];
//        [fileView release];
        //        pollView.userInteractionEnabled = YES;
        
        
        //        UIView *buttonView = [[UIView alloc]init];//WithFrame:CGRectMake(starttime.frame.origin.x,timeLabel.frame.origin.y + timeLabel.frame.size.height,0,0)];
        
        
        if([contentsData.contentType intValue]>17 || [contentsData.type intValue]>7 || ([contentsData.writeinfoType intValue]>4 && [contentsData.writeinfoType intValue]!=10)){
            
            [profileImageView setImage:[UIImage imageNamed:@"list_profile_systeam.png"]];
            UILabel *title;
            title = [CustomUIKit labelWithText:@"업그레이드가 필요합니다." fontSize:15 fontColor:[UIColor blackColor] frame:CGRectMake(10, 0, 300, 18) numberOfLines:1 alignText:NSTextAlignmentLeft];
            [contentsView addSubview:title];
            contentsView.frame = CGRectMake(0, CGRectGetMaxY(defaultView.frame)+5, 320, CGRectGetMaxY(title.frame));
        }
        else{
            
            
            if([contentsData.contentType isEqualToString:@"8"] || [contentsData.contentType isEqualToString:@"9"])
            {
#ifdef BearTalk
                contentsView.frame = CGRectMake(16, CGRectGetMaxY(defaultView.frame), self.view.frame.size.width-32, 0);
#else
                defaultView.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
                profileImageView.frame = CGRectMake(0, 0, 0, 0);
                profileImageView.image = nil;
                [nameLabel setText:@""];
                [positionLabel setText:@""];
                contentsView.frame = CGRectMake(0, CGRectGetMaxY(defaultView.frame)+5, self.view.frame.size.width, 0);
//                [teamLabel setText:@""];
#endif
                
                
                UIView *titleView;
                titleView = [[UIView alloc]init];
                titleView.frame = CGRectMake(0, 10, self.view.frame.size.width, 0);
                [contentsView addSubview:titleView];
//                [titleView release];
                
                UILabel *socialLabel;
                socialLabel = [CustomUIKit labelWithText:@"" fontSize:15 fontColor:RGB(54, 54, 55) frame:CGRectMake(10, 0, titleView.frame.size.width - 20, 0) numberOfLines:1 alignText:NSTextAlignmentLeft];
                [titleView addSubview:socialLabel];
                
                UIImageView *infoView = [[UIImageView alloc]init];
                infoView.frame = CGRectMake(socialLabel.frame.origin.x, socialLabel.frame.origin.y + socialLabel.frame.size.height, 41, 44);
                [titleView addSubview:infoView];
//                [infoView release];
                
                if([contentsData.contentType isEqualToString:@"9"] && [[contentsData.targetdic objectFromJSONString][@"category"]isEqualToString:@"2"]){
#ifdef BearTalk
#else
                    socialLabel.frame = CGRectMake(10, 0, titleView.frame.size.width - 20, 25);
                    NSDictionary *tDic = [contentsData.targetdic objectFromJSONString];
                    socialLabel.text = [NSString stringWithFormat:@"[%@]",tDic[@"categoryname"]];
#endif
                    infoView.frame = CGRectMake(socialLabel.frame.origin.x, socialLabel.frame.origin.y + socialLabel.frame.size.height + 5, 41, 44);
                }
                
                
                //                UILabel *infoLabel;
                //                infoLabel = [CustomUIKit labelWithText:@"" fontSize:13 fontColor:[UIColor blackColor] frame:CGRectMake(0, 0, 41, 20) numberOfLines:1 alignText:NSTextAlignmentCenter];
                //                [infoView addSubview:infoLabel];
                
                UILabel *subInfoLabel;
                subInfoLabel = [CustomUIKit labelWithText:@"" fontSize:9 fontColor:RGB(54, 54, 55) frame:CGRectMake(0, 44-15, 41, 15) numberOfLines:1 alignText:NSTextAlignmentCenter];
             

                
                NSString *endTime = contentsData.contentDic[@"scheduleendtime"];
                NSLog(@"endTime %@",endTime);
                if([endTime isEqualToString:@"0"] || endTime == nil)
                    endTime = contentsData.contentDic[@"schedulestarttime"];
                NSString *startTime = contentsData.contentDic[@"schedulestarttime"];
                
                NSString *nowTime = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
                NSLog(@"starttime %d endtime %d nowtime %d",[startTime intValue],[endTime intValue],[nowTime intValue]);
                
                int valueInterval = [nowTime intValue] - [startTime intValue];
                NSLog(@"valueInterval %d",valueInterval);
                
                
#define kStart 1
#define kIng 2
#define kEnd 3
                
                
                if([startTime intValue] == 0){
                    //                    infoLabel.text = @"취소 됨";
                    infoView.image = [CustomUIKit customImageNamed:@"imageview_schedule_info_cancel.png"];
                    subInfoLabel.text = @"일정 취소";
#ifdef BearTalk
                    
                    subInfoLabel.textColor = RGB(151,152,157);
#endif
                }
                else if([endTime intValue] <= [nowTime intValue])
                {
                    //                    infoLabel.text = @"종료 됨";
                    infoView.image = [CustomUIKit customImageNamed:@"imageview_schedule_info_end.png"];
                    subInfoLabel.text = [NSString stringWithFormat:@"%@",[NSString calculateDateDifferNow:endTime mode:kEnd]];
#ifdef BearTalk
                    subInfoLabel.textColor = RGB(151,152,157);
#endif
                }
                else if([endTime intValue] > [nowTime intValue] && [nowTime intValue] >= [startTime intValue]){
                    //                    infoLabel.text = @"진행 중";
                    infoView.image = [CustomUIKit customImageNamed:@"imageview_schedule_info_ing.png"];
                    subInfoLabel.text = [NSString stringWithFormat:@"%@",[NSString calculateDateDifferNow:startTime mode:kIng]];
#ifdef BearTalk
                    subInfoLabel.textColor =  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
#endif
                }
                else if([nowTime intValue] < [startTime intValue]){
                    //                    infoLabel.text = @"시작 전";
                    infoView.image = [CustomUIKit customImageNamed:@"imageview_schedule_info_start.png"];
                    
                    
                    if(valueInterval<3600){
                        subInfoLabel.text = [NSString stringWithFormat:@"%@",[NSString calculateDateDifferNow:startTime mode:kStart]];
                    }
#ifdef BearTalk
                    subInfoLabel.textColor =  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
#endif
                    
                }
                else{
                    NSLog(@"is there else?");
                }
                
                
#ifdef BearTalk
                
                CGFloat borderWidth = 0.5f;
                titleView.backgroundColor = RGB(251,251,251);
                //    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
                titleView.layer.borderColor = RGB(234, 234, 234).CGColor;
                titleView.layer.borderWidth = borderWidth;
                
                infoView.frame = CGRectMake(15, 16.5, 24, 24);
                infoView.image = [CustomUIKit customImageNamed:@"btn_schedule_off.png"];
                subInfoLabel.frame = CGRectMake(CGRectGetMaxX(infoView.frame)+9, 15, 100, 12);
                subInfoLabel.font = [UIFont systemFontOfSize:12];

                subInfoLabel.textAlignment = NSTextAlignmentLeft;
                //               subInfoLabel.frame = CGRectMake(CGRect)
                   [titleView addSubview:subInfoLabel];
                
#else
                   [infoView addSubview:subInfoLabel];
#endif
                
                
                
                
                UILabel *title;
                title = [CustomUIKit labelWithText:contentsData.contentDic[@"scheduletitle"] fontSize:15 fontColor:RGB(54, 54, 55) frame:CGRectMake(infoView.frame.origin.x + infoView.frame.size.width + 10, infoView.frame.origin.y + 5, titleView.frame.size.width - (infoView.frame.origin.x + infoView.frame.size.width + 10), 40) numberOfLines:2 alignText:NSTextAlignmentLeft];
                [titleView addSubview:title];
                
#ifdef BearTalk
                titleView.frame = CGRectMake(0, 0, contentsView.frame.size.width, 16.5+16.5+24);
                title.frame = CGRectMake(subInfoLabel.frame.origin.x, CGRectGetMaxY(subInfoLabel.frame)+5, titleView.frame.size.width - 16 - subInfoLabel.frame.origin.x, 14);
                title.font = [UIFont systemFontOfSize:14];
                
#else
                titleView.frame = CGRectMake(0, 10, self.view.frame.size.width, title.frame.origin.y + title.frame.size.height);
                
#endif
                
                
                
#ifdef BearTalk
#else
                if(!([contentsData.contentType isEqualToString:@"9"] && [[contentsData.targetdic objectFromJSONString][@"category"]isEqualToString:@"3"]))
                {
                    NSLog(@"ontentsData.personInfo %@",contentsData.personInfo);
                    CGSize createrSize = [contentsData.personInfo[@"name"] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100, 20) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    UILabel *createrLabel = [CustomUIKit labelWithText:contentsData.personInfo[@"name"] fontSize:12 fontColor:RGB(42, 108, 177) frame:CGRectMake(infoView.frame.origin.x, infoView.frame.origin.y + infoView.frame.size.height + 5, createrSize.width, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
#ifdef GreenTalk
                    createrLabel.textColor = GreenTalkColor;
#endif
                    [titleView addSubview:createrLabel];
                    
                    NSString *createrPosition = @"";;// = [NSString stringWithFormat:@"%@ | %@",contentsData.personInfo[@"position"],contentsData.personInfo[@"deptname"]];
                    
                    if([contentsData.personInfo[@"position"]length]>0)
                    {
                        if([contentsData.personInfo[@"deptname"]length]>0){
                            createrPosition = [NSString stringWithFormat:@"%@ | %@",contentsData.personInfo[@"position"],contentsData.personInfo[@"deptname"]];
#ifdef Batong
                            createrPosition = [NSString stringWithFormat:@"%@ | %@",contentsData.personInfo[@"deptname"],contentsData.personInfo[@"position"]];
#endif
                        }
                        else
                            createrPosition = [NSString stringWithFormat:@"%@",contentsData.personInfo[@"position"]];
                    }
                    else{
                        if([contentsData.personInfo[@"deptname"]length]>0)
                            createrPosition = [NSString stringWithFormat:@"%@",contentsData.personInfo[@"deptname"]];
                    }
                    
                    
                    UILabel *createrPositionLabel = [CustomUIKit labelWithText:createrPosition fontSize:12 fontColor:RGB(54, 54, 55) frame:CGRectMake(createrLabel.frame.origin.x + createrLabel.frame.size.width+3, createrLabel.frame.origin.y, titleView.frame.size.width - createrLabel.frame.size.width - 5, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
                    
                    [titleView addSubview:createrPositionLabel];
                    titleView.userInteractionEnabled = YES;
                    UIButton *infoButton;
                    infoButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(yourInfo:) frame:CGRectMake(createrLabel.frame.origin.x, createrLabel.frame.origin.y, createrLabel.frame.size.width, createrLabel.frame.size.height) cachedImageNamedBullet:nil cachedImageNamedNormal:nil cachedImageNamedPressed:nil];
                    [titleView addSubview:infoButton];
//                    [infoButton release];
                    
                    UILabel *createrTimeLabel = [CustomUIKit labelWithText:[NSString formattingDate:contentsData.writetime withFormat:@"yyyy. M. dd. (EE) a h:mm"] fontSize:12 fontColor:RGB(54, 54, 55) frame:CGRectMake(createrLabel.frame.origin.x, createrLabel.frame.origin.y + createrLabel.frame.size.height, 160, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
                    [titleView addSubview:createrTimeLabel];
                    
                    readLabel.font = [UIFont systemFontOfSize:12];
                    readLabel.textColor = RGB(54, 54, 55);
                    readLabel.frame = CGRectMake(165, titleView.frame.origin.y + createrTimeLabel.frame.origin.y, 130, createrTimeLabel.frame.size.height);
                    
                    titleView.frame = CGRectMake(0, 10, 320, createrTimeLabel.frame.origin.y + createrTimeLabel.frame.size.height);
                }
                
               
                [timeLabel setText:@""];//dateString];
#endif
                UIView *timeView;
                timeView = [[UIView alloc]init];
                timeView.frame = CGRectMake(0, titleView.frame.origin.y + titleView.frame.size.height, self.view.frame.size.width, 0);
                [contentsView addSubview:timeView];
//                [timeView release];
                
                UIImageView *line;
                UIImageView *iconImageView;
                
                if([contentsData.contentDic[@"schedulestarttime"]intValue]==0)
                {
                    //                    timeString = @"일정이 취소되었습니다.";
                    [SharedAppDelegate.root cancelNoti:contentsData.idx];
                    
                }
                else{
                    line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline2px_light.png"]];
                    line.frame = CGRectMake(0, 10, 320,0.5);

                    [timeView addSubview:line];
//                    [line release];
                    
                    
                    NSString *startTimeString = @"";
                    NSString *endTimeString = @"";
                    
                    NSString *startDay = [NSString formattingDate:startTime withFormat:@"yyyyMMdd"];
                    NSString *endDay = [NSString formattingDate:endTime withFormat:@"yyyyMMdd"];
                    if([startTime isEqualToString:endTime]){
                        startTimeString = [NSString stringWithFormat:@"시작: %@",[NSString formattingDate:startTime withFormat:@"yyyy. M. d. (EE) a h:mm"]];
                    }
                    else{
                        
                        if([contentsData.contentDic[@"allday"]isEqualToString:@"1"]){
                            if([startDay isEqualToString:endDay]){
                                // same day
                                
                                startTimeString = [NSString stringWithFormat:@"시작: %@ 하루종일 (오전 9:00)",[NSString formattingDate:startTime withFormat:@"yyyy. M. d. (EE)"]];
                                endTimeString = [NSString stringWithFormat:@"종료: %@ 하루종일 (오후 11:59)",[NSString formattingDate:endTime withFormat:@"yyyy. M. d. (EE)"]];
                            }
                            else{
                                
                                startTimeString = [NSString stringWithFormat:@"시작: %@ 하루종일 (오전 9:00)",[NSString formattingDate:startTime withFormat:@"yyyy. M. d. (EE)"]];
                                endTimeString = [NSString stringWithFormat:@"종료: %@ 하루종일 (오후 11:59)",[NSString formattingDate:endTime withFormat:@"yyyy. M. d. (EE)"]];
                            }
                        }
                        else{
                            if([startDay isEqualToString:endDay]){
                                startTimeString = [NSString stringWithFormat:@"시작: %@",[NSString formattingDate:startTime withFormat:@"yyyy. M. d. (EE) a h:mm"]];
                                endTimeString = [NSString stringWithFormat:@"종료: %@",[NSString formattingDate:endTime withFormat:@"yyyy. M. d. (EE) a h:mm"]];
                            }
                            else{
                                startTimeString = [NSString stringWithFormat:@"시작: %@",[NSString formattingDate:startTime withFormat:@"yyyy. M. d. (EE) a h:mm"]];
                                endTimeString = [NSString stringWithFormat:@"종료: %@",[NSString formattingDate:endTime withFormat:@"yyyy. M. d. (EE) a h:mm"]];
                            }
                        }
                    }
                    
                    
                    
                    iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imageview_schedule_icon_time.png"]];
                    iconImageView.frame = CGRectMake(10, line.frame.origin.y + line.frame.size.height + 10 + 1, 14, 14);
                    [timeView addSubview:iconImageView];
//                    [iconImageView release];
                    
                    UILabel *startLabel;
                    startLabel = [CustomUIKit labelWithText:startTimeString fontSize:12 fontColor:RGB(54, 54, 55) frame:CGRectMake(30, line.frame.origin.y + line.frame.size.height + 10, timeView.frame.size.width - 40, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
                    [timeView addSubview:startLabel];
                    
                    
                    UILabel *endLabel;
                    endLabel = [CustomUIKit labelWithText:endTimeString fontSize:12 fontColor:RGB(54, 54, 55) frame:CGRectMake(startLabel.frame.origin.x, startLabel.frame.origin.y + startLabel.frame.size.height, startLabel.frame.size.width, 16) numberOfLines:1 alignText:NSTextAlignmentLeft];
                    [timeView addSubview:endLabel];
                    if([startTime isEqualToString:endTime]){
                        endLabel.frame = CGRectMake(startLabel.frame.origin.x, startLabel.frame.origin.y + startLabel.frame.size.height, startLabel.frame.size.width, 0);
                    }
                    
#ifdef BearTalk
                    
//                    CGFloat borderWidth = 0.5f;
//                    timeView.backgroundColor = [UIColor whiteColor];
//                    //    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
//                    timeView.layer.borderColor = RGB(234, 234, 234).CGColor;
//                    timeView.layer.borderWidth = borderWidth;
                    
                    line.hidden = YES;

                    iconImageView.hidden = YES;
                    
                    timeView.frame = CGRectMake(0, titleView.frame.origin.y + titleView.frame.size.height, contentsView.frame.size.width, 18+15+8+15);
                    
                    startLabel.frame = CGRectMake(15, 18, timeView.frame.size.width - 30, 15);
                    startLabel.font = [UIFont systemFontOfSize:15];
                    endLabel.frame = CGRectMake(15, CGRectGetMaxY(startLabel.frame)+8, timeView.frame.size.width - 30, 15);
                    endLabel.font = [UIFont systemFontOfSize:15];
                    
                    
                    if([startTime isEqualToString:endTime]){
                        endLabel.frame = CGRectMake(15, CGRectGetMaxY(startLabel.frame), timeView.frame.size.width - 30, 0);
                        timeView.frame = CGRectMake(0, titleView.frame.origin.y + titleView.frame.size.height, contentsView.frame.size.width, 18+15);
                    }
                    


#else
                    timeView.frame = CGRectMake(0, titleView.frame.origin.y + titleView.frame.size.height, 320, endLabel.frame.origin.y + endLabel.frame.size.height);
#endif
                }
                
                UIView *alarmView;
                alarmView = [[UIView alloc]init];
                alarmView.frame = CGRectMake(0, timeView.frame.origin.y + timeView.frame.size.height, 320, 0);
                [contentsView addSubview:alarmView];
//                [alarmView release];
                
#ifdef BearTalk
                
////                CGFloat borderWidth = 0.5f;
//                alarmView.backgroundColor = [UIColor whiteColor];
//                //    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
//                alarmView.layer.borderColor = RGB(234, 234, 234).CGColor;
//                alarmView.layer.borderWidth = borderWidth;
                
                alarmView.frame = CGRectMake(0, timeView.frame.origin.y + timeView.frame.size.height+18, contentsView.frame.size.width, 0);
#endif
                
                if([contentsData.contentDic[@"alarm"]intValue]>0){
                    
                    
                    UIImageView *line;
                    line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline2px_light.png"]];
                    line.frame = CGRectMake(0, 10, 320,0.5);
                    [alarmView addSubview:line];
//                    [line release];
                    
                    
                    iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imageview_schedule_icon_alert.png"]];
                    iconImageView.frame = CGRectMake(10, line.frame.origin.y + line.frame.size.height + 10 + 3, 14, 14);
                    [alarmView addSubview:iconImageView];
//                    [iconImageView release];
                    
                    UILabel *alarmLabel;
                    alarmLabel = [CustomUIKit labelWithText:@"" fontSize:12 fontColor:RGB(54, 54, 55) frame:CGRectMake(30, line.frame.origin.y + line.frame.size.height + 10, alarmView.frame.size.width - 40, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
                    [alarmView addSubview:alarmLabel];
                    
                    //                    UIImageView *alarm = [[UIImageView alloc]initWithFrame:CGRectMake(contentView.frame.size.width - 83 - 22, line.frame.origin.y + line.frame.size.height + 10, 20, 14)];
                    //                    alarm.image = [UIImage imageNamed:@"noti_ic.png"];
                    //                    [contentView addSubview:alarm];
//                                        [alarm release];
                    
                    
                    switch ([contentsData.contentDic[@"alarm"] intValue]) {
                        case 30:
                            alarmLabel.text = @"30분 전 알림";
                            break;
                        case 60:
                            alarmLabel.text = @"1시간 전 알림";
                            break;
                        case 120:
                            alarmLabel.text = @"2시간 전 알림";
                            break;
                        case 1440:
                            alarmLabel.text = @"1일 전 알림";
                            break;
                        case 28800:
                            alarmLabel.text = @"2일 전 알림";
                            break;
                        case 10:
                            alarmLabel.text = @"10분 전 알림";
                            break;
                        default:
                            alarmLabel.text = @"";
                            break;
                    }
                    
#ifdef BearTalk
                    iconImageView.image = [UIImage imageNamed:@"social_schedule_alarm.png"];
                    iconImageView.frame = CGRectMake(15, 0, 12, 15);
                    line.hidden = YES;
                    alarmLabel.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame)+6, iconImageView.frame.origin.y, 200, 15);
                    alarmLabel.textColor = RGB(51,51,51);
                    alarmLabel.font = [UIFont systemFontOfSize:15];
                    alarmView.frame = CGRectMake(0, timeView.frame.origin.y + timeView.frame.size.height+11, contentsView.frame.size.width, 15+18);
                    
#else
                    alarmView.frame = CGRectMake(0, timeView.frame.origin.y + timeView.frame.size.height, 320, alarmLabel.frame.origin.y + alarmLabel.frame.size.height);
#endif
                }
                
                
                
                UIView *memberView;
                memberView = [[UIView alloc]init];
                memberView.frame = CGRectMake(0, alarmView.frame.origin.y + alarmView.frame.size.height, self.view.frame.size.width, 0);
                [contentsView addSubview:memberView];
//                [memberView release];
                
                
#ifdef BearTalk
#else
                if([contentsData.contentType isEqualToString:@"8"]){// || ([contentsData.contentType isEqualToString:@"9"] && [[contentsData.targetdic objectFromJSONString][@"category"]isEqualToString:@"2"])){
                    
                    int buttonWidth = 0;
                    
                    UIImageView *line;
                    line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline2px_light.png"]];
                    line.frame = CGRectMake(0, 10, 320,0.5);
                    [memberView addSubview:line];
//                    [line release];
        
                    
                    UILabel *memberViewTitle;
                    memberViewTitle = [CustomUIKit labelWithText:@"" fontSize:13 fontColor:RGB(54, 54, 55) frame:CGRectMake(30, line.frame.origin.y + line.frame.size.height + 10, 80, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
                    [memberView addSubview:memberViewTitle];
                    
                    UILabel *allMemberCount;
                    allMemberCount = [CustomUIKit labelWithText:@"" fontSize:12 fontColor:RGB(54, 54, 55) frame:CGRectMake(memberViewTitle.frame.origin.x + memberViewTitle.frame.size.width, memberViewTitle.frame.origin.y, 100, 20) numberOfLines:1 alignText:NSTextAlignmentLeft];
                    [memberView addSubview:allMemberCount];
                    
                    if([contentsData.contentDic[@"attendance"]isEqualToString:@"1"]){
                        
                        memberViewTitle.text = @"참석 여부 확인";
                        
                        iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imageview_schedule_icon_attend.png"]];
                        iconImageView.frame = CGRectMake(10, line.frame.origin.y + line.frame.size.height + 10 + 3, 14, 14);
                        [memberView addSubview:iconImageView];
//                        [iconImageView release];
                        
                        
                        if(valueInterval<=0)
                        {
                            buttonWidth = 40;
                        }
                        else{
                            buttonWidth = 0;
                        }
                        
                        
                        
                        // attendance
                        NSArray *membersArray = contentsData.contentDic[@"schedulemember"];
                        NSLog(@"members %@",membersArray);
                        
                        UILabel *attendMember = [[UILabel alloc]init];
                        attendMember.backgroundColor = [UIColor clearColor];
                        attendMember.textColor = RGB(42, 108, 177);
                        [attendMember setFont:[UIFont systemFontOfSize:11]];
                        [attendMember setAdjustsFontSizeToFitWidth:NO];
                        [attendMember setNumberOfLines:0];
                        [memberView addSubview:attendMember];
//                        [attendMember release];
                        //                    [attedMember setText:attendMemberString];
                        
                        UILabel *notAttendMember = [[UILabel alloc]init];
                        notAttendMember.backgroundColor = [UIColor clearColor];
                        notAttendMember.textColor = [UIColor grayColor];
                        [notAttendMember setFont:[UIFont systemFontOfSize:11]];
                        [notAttendMember setAdjustsFontSizeToFitWidth:NO];
                        [notAttendMember setNumberOfLines:0];
                        [memberView addSubview:notAttendMember];
//                        [notAttendMember release];
                        
                        
                        UILabel *notDecideMember = [[UILabel alloc]init];
                        notDecideMember.backgroundColor = [UIColor clearColor];
                        notDecideMember.textColor = [UIColor grayColor];
                        [notDecideMember setFont:[UIFont systemFontOfSize:11]];
                        [notDecideMember setAdjustsFontSizeToFitWidth:NO];
                        [notDecideMember setNumberOfLines:0];
                        [memberView addSubview:notDecideMember];
//                        [notDecideMember release];
                        
                        
                        
                        int attendNum = 0;
                        int notAttendNum = 0;
                        int notDecideNum = 0;
                        
                        NSString *attendMemberString = @"";
                        NSString *notAttendMemberString = @"";
                        NSString *notDecideMemberString = @"";
                        
                        for(int i = 0; i < [membersArray count]; i++){
                            NSString *attendValue = @"";
                            NSDictionary *dic = [membersArray[i]objectFromJSONString];
                            for(int j = 0; j < [readArray count]; j++){
                                NSDictionary *readDic = [readArray[j]objectFromJSONString];
                                NSLog(@"ReadDic %@",readDic);
                                if([readDic[@"uid"]isEqualToString:dic[@"uid"]])
                                    attendValue = readDic[@"attendance"];
                                NSLog(@"attendValue %@",attendValue);
                            }
                            if([attendValue isEqualToString:@"2"]){
                                attendNum++;
                                attendMemberString = [attendMemberString stringByAppendingFormat:@"%@, ",dic[@"name"]];
                            }
                            else if([attendValue isEqualToString:@"1"]){
                                notAttendNum++;
                                notAttendMemberString = [notAttendMemberString stringByAppendingFormat:@"%@, ",dic[@"name"]];
                            }
                            else{
                                notDecideNum++;
                                notDecideMemberString = [notDecideMemberString stringByAppendingFormat:@"%@, ",dic[@"name"]];
                            }
                            
                        }
                        allMemberCount.text = [NSString stringWithFormat:@"(%d명 참여 / 총 %d명)",attendNum+notAttendNum,attendNum+notAttendNum+notDecideNum];
                        
                        attendMemberString = [attendMemberString length]>1?[attendMemberString substringToIndex:[attendMemberString length]-2]:attendMemberString;
                        notAttendMemberString = [notAttendMemberString length]>1?[notAttendMemberString substringToIndex:[notAttendMemberString length]-2]:notAttendMemberString;
                        notDecideMemberString = [notDecideMemberString length]>1?[notDecideMemberString substringToIndex:[notDecideMemberString length]-2]:notDecideMemberString;
                        
                        NSString *myAttend = @"";
                        for(int j = 0; j < [readArray count]; j++){
                            NSDictionary *readDic = [readArray[j]objectFromJSONString];
                            if([readDic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
                                myAttend = readDic[@"attendance"];
                            }
                        }
                        NSLog(@"myAttend %@",myAttend);
                        
                        
                        
                        UILabel *attendCountTitle = [CustomUIKit labelWithText:@"참석" fontSize:13 fontColor:RGB(54, 54, 55) frame:CGRectMake(10 + buttonWidth, memberViewTitle.frame.origin.y + memberViewTitle.frame.size.height + 5, 320-20, 23) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:attendCountTitle];
                        
                        UILabel *addCount = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d",attendNum] fontSize:13 fontColor:RGB(42, 108, 177) frame:CGRectMake(attendCountTitle.frame.origin.x + 27, attendCountTitle.frame.origin.y, 150, attendCountTitle.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:addCount];
                        
                        [attendMember performSelectorOnMainThread:@selector(setText:) withObject:attendMemberString waitUntilDone:NO];
                        CGSize memberSize = [attendMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(attendCountTitle.frame.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        attendMember.frame = CGRectMake(attendCountTitle.frame.origin.x, attendCountTitle.frame.origin.y + attendCountTitle.frame.size.height - 5, attendCountTitle.frame.size.width, memberSize.height);
                        
                        NSLog(@"memberSize height %f",memberSize.height);
                        
                        
                        
                        
                        UILabel *notAttendCountTitle = [CustomUIKit labelWithText:@"불참" fontSize:13 fontColor:RGB(54, 54, 55) frame:CGRectMake(attendCountTitle.frame.origin.x, attendMember.frame.origin.y + attendMember.frame.size.height, 320-20, 23) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:notAttendCountTitle];
                        
                        addCount = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d",notAttendNum] fontSize:13 fontColor:RGB(42, 108, 177) frame:CGRectMake(notAttendCountTitle.frame.origin.x + 27, notAttendCountTitle.frame.origin.y, 150, notAttendCountTitle.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:addCount];
                        
                        [notAttendMember performSelectorOnMainThread:@selector(setText:) withObject:notAttendMemberString waitUntilDone:NO];
                        memberSize = [notAttendMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(notAttendCountTitle.frame.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        NSLog(@"memberSize height %f",memberSize.height);
                        notAttendMember.frame = CGRectMake(notAttendCountTitle.frame.origin.x, notAttendCountTitle.frame.origin.y + notAttendCountTitle.frame.size.height - 5, notAttendCountTitle.frame.size.width, memberSize.height);
                        int gap = 0;
                        UIButton *setMyAttend;
                        setMyAttend = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(setRegiGroup:) frame:CGRectMake(25, notAttendMember.frame.origin.y + notAttendMember.frame.size.height, 269, 0) cachedImageNamedBullet:nil cachedImageNamedNormal:@"bluecheck_btn.png" cachedImageNamedPressed:nil];
                        
                        
                        if(valueInterval<=0){
                            gap = 10;
                            setMyAttend.frame = CGRectMake(25, notAttendMember.frame.origin.y + notAttendMember.frame.size.height, 269, 30);
                            [memberView addSubview:setMyAttend];
                            setMyAttend.tag = 2;
//                            [setMyAttend release];
                            
                            UILabel *checkLabel = [CustomUIKit labelWithText:@"확인" fontSize:15 fontColor:[UIColor whiteColor] frame:CGRectMake(0, 0, setMyAttend.frame.size.width, setMyAttend.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentCenter];
                            [setMyAttend addSubview:checkLabel];
                        }
                        else{
                            
                            memberViewTitle.text = @"참석 결과 확인";
                        }
                        UILabel *notDecideTitle = [CustomUIKit labelWithText:@"미정" fontSize:13 fontColor:RGB(54, 54, 55) frame:CGRectMake(10, setMyAttend.frame.origin.y + setMyAttend.frame.size.height + gap, 320-20, 23) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:notDecideTitle];
                        
                        addCount = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d",notDecideNum] fontSize:13 fontColor:RGB(42, 108, 177) frame:CGRectMake(notDecideTitle.frame.origin.x + 27, notDecideTitle.frame.origin.y, 150, notDecideTitle.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:addCount];
                        
                        [notDecideMember performSelectorOnMainThread:@selector(setText:) withObject:notDecideMemberString waitUntilDone:NO];
                        memberSize = [notDecideMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(notDecideTitle.frame.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        NSLog(@"memberSize height %f",memberSize.height);
                        notDecideMember.frame = CGRectMake(notDecideTitle.frame.origin.x, notDecideTitle.frame.origin.y + notDecideTitle.frame.size.height - 5, notDecideTitle.frame.size.width, memberSize.height);
                        
                        if(valueInterval<=0)
                        {
                            attendButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(regiGroup:) frame:CGRectMake(10, attendCountTitle.frame.origin.y + 5, 30, 30) cachedImageNamedBullet:nil cachedImageNamedNormal:@"vote_check_dft.png" cachedImageNamedPressed:nil];
                            [memberView addSubview:attendButton];
//                            [attendButton release];
                            attendButton.tag = 1;
                            
                            
                            notAttendButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(regiGroup:) frame:CGRectMake(10, notAttendCountTitle.frame.origin.y + 5, 30, 30) cachedImageNamedBullet:nil cachedImageNamedNormal:@"vote_check_dft.png" cachedImageNamedPressed:nil];
                            [memberView addSubview:notAttendButton];
//                            [notAttendButton release];
                            notAttendButton.tag = 0;
                            
                            //                                UIButton *notDecideButton;
                            //                                notDecideButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(regiGroup:) frame:CGRectMake(0, notDecideTitle.frame.origin.y + 5, 30, 30) cachedImageNamedBullet:nil cachedImageNamedNormal:@"vote_check_dft.png" cachedImageNamedPressed:nil];
                            //                                [buttonView addSubview:notDecideButton];
                            //                                [notDecideButton release];
                            //                                notDecideButton.tag = 2;
                            
                            if([myAttend isEqualToString:@"2"]){
                                
                                [attendButton setBackgroundImage:[UIImage imageNamed:@"button_bluecheck.png"] forState:UIControlStateNormal];
                                //                                    myAttendValue = 1;
                                myOriginalAttendValue = 1;
                                
                            }
                            else if([myAttend isEqualToString:@"1"]){
                                
                                [notAttendButton setBackgroundImage:[UIImage imageNamed:@"button_bluecheck.png"] forState:UIControlStateNormal];
                                //                                    myAttendValue = 0;
                                myOriginalAttendValue = 0;
                                
                                
                            }
                            //                                else{
                            //
                            //                                    [notDecideButton setBackgroundImage:[UIImage imageNamed:@"vote_check_prs.png"] forState:UIControlStateNormal];
                            //                                    myAttendValue = 2;
                            //
                            //
                            //                                }
                            
                            
                        }
                        else{
                            
                        }
                        memberView.frame = CGRectMake(0, alarmView.frame.origin.y + alarmView.frame.size.height, 320, notDecideMember.frame.origin.y + notDecideMember.frame.size.height);
                        
                        //
                        //                            line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"schedule_grayline.png"]];
                        //                            line.frame = CGRectMake(5, memberView.frame.origin.y + memberView.frame.size.height + 10, 300,1);
                        //                            [contentView addSubview:line];
                        //                            [line release];
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    else{
                        
                        memberViewTitle.text = @"일정공유 멤버";
                        
                        iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imageview_schedule_icon_member.png"]];
                        iconImageView.frame = CGRectMake(10, line.frame.origin.y + line.frame.size.height + 10 + 3, 14, 14);
                        [memberView addSubview:iconImageView];
//                        [iconImageView release];
                        
                        NSString *readMemberString = @"";
                        NSString *notReadMemberString = @"";
                        //                            NSString *notDecideMemberString = @"";
                        
                        
                        // attendance
                        NSArray *membersArray = contentsData.contentDic[@"schedulemember"];
                        NSLog(@"members %@",membersArray);
                        
                        
                        
                        UILabel *readMember = [[UILabel alloc]init];
                        readMember.backgroundColor = [UIColor clearColor];
                        readMember.textColor = RGB(42, 108, 177);
                        [readMember setFont:[UIFont systemFontOfSize:11]];
                        [readMember setAdjustsFontSizeToFitWidth:NO];
                        [readMember setNumberOfLines:0];
                        [memberView addSubview:readMember];
//                        [readMember release];
                        //                    [attedMember setText:attendMemberString];
                        
                        UILabel *notReadMember = [[UILabel alloc]init];
                        notReadMember.backgroundColor = [UIColor clearColor];
                        notReadMember.textColor = [UIColor grayColor];
                        [notReadMember setFont:[UIFont systemFontOfSize:11]];
                        [notReadMember setAdjustsFontSizeToFitWidth:NO];
                        [notReadMember setNumberOfLines:0];
                        [memberView addSubview:notReadMember];
//                        [notReadMember release];
                        
                        
                        
                        
                        UILabel *readMemberTitle = [CustomUIKit labelWithText:@"읽음" fontSize:13 fontColor:RGB(54, 54, 55) frame:CGRectMake(10 + buttonWidth, memberViewTitle.frame.origin.y + memberViewTitle.frame.size.height + 5, 320-20, 23) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:readMemberTitle];
                        
                        UILabel *addCount = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d",(int)[readArray count]] fontSize:13 fontColor:RGB(42, 108, 177) frame:CGRectMake(readMemberTitle.frame.origin.x + 27, readMemberTitle.frame.origin.y, 150, readMemberTitle.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:addCount];
                        
                        for(int i = 0; i < [readArray count];i++){
                            NSDictionary *dic = [readArray[i]objectFromJSONString];
                            readMemberString = [readMemberString stringByAppendingFormat:@"%@, ",dic[@"name"]];
                        }
                        
                        
                        allMemberCount.text = [NSString stringWithFormat:@"(총 %d명)",(int)[membersArray count]];
                        readMemberString = [readMemberString length]>1?[readMemberString substringToIndex:[readMemberString length]-2]:readMemberString;
                        
                        [readMember performSelectorOnMainThread:@selector(setText:) withObject:readMemberString waitUntilDone:NO];
                        CGSize memberSize = [readMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(readMemberTitle.frame.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        readMember.frame = CGRectMake(readMemberTitle.frame.origin.x, readMemberTitle.frame.origin.y + readMemberTitle.frame.size.height - 5, readMemberTitle.frame.size.width, memberSize.height);
                        
                        NSLog(@"membersArray %@",membersArray);
                        
                        NSMutableArray *notReadArray = [NSMutableArray array];
                        
                        for(int i = 0; i < [membersArray count]; i++){
                            BOOL read = NO;
                            NSDictionary *dic = [membersArray[i]objectFromJSONString];
                            
                            for(int j = 0; j < [readArray count]; j++){
                                NSDictionary *readDic = [readArray[j]objectFromJSONString];
                                
                                if([readDic[@"uid"]isEqualToString:dic[@"uid"]])
                                {
                                    read = YES;
                                }
                            }
                            if(read == NO){
                                [notReadArray addObject:dic];
                            }
                        }
                        
                        NSLog(@"notReadArray %@",notReadArray);
                        
                        for(NSDictionary *dic in notReadArray){
                            notReadMemberString = [notReadMemberString stringByAppendingFormat:@"%@, ",dic[@"name"]];
                        }
                        notReadMemberString = [notReadMemberString length]>1?[notReadMemberString substringToIndex:[notReadMemberString length]-2]:notReadMemberString;
                        
                        UILabel *notReadTitle = [CustomUIKit labelWithText:@"안읽음" fontSize:13 fontColor:RGB(54, 54, 55) frame:CGRectMake(readMember.frame.origin.x, readMember.frame.origin.y + readMember.frame.size.height, 320-20, 23) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:notReadTitle];
                        
                        addCount = [CustomUIKit labelWithText:[NSString stringWithFormat:@"%d",(int)[notReadArray count]] fontSize:13 fontColor:RGB(42, 108, 177) frame:CGRectMake(notReadTitle.frame.origin.x + 38, notReadTitle.frame.origin.y, 150, notReadTitle.frame.size.height) numberOfLines:1 alignText:NSTextAlignmentLeft];
                        [memberView addSubview:addCount];
                        
                        [notReadMember performSelectorOnMainThread:@selector(setText:) withObject:notReadMemberString waitUntilDone:NO];
                        memberSize = [notReadMemberString sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(notReadTitle.frame.size.width, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                        if(memberSize.height < 23.0f)
                            memberSize.height = 23.0f;
                        NSLog(@"memberSize height %f",memberSize.height);
                        notReadMember.frame = CGRectMake(notReadTitle.frame.origin.x, notReadTitle.frame.origin.y + notReadTitle.frame.size.height - 5, notReadTitle.frame.size.width, memberSize.height);
                        
                        
                        memberView.frame = CGRectMake(0, alarmView.frame.origin.y + alarmView.frame.size.height, 320, notReadMember.frame.origin.y + notReadMember.frame.size.height);
                        
                        
                        //                            line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"schedule_grayline.png"]];
                        //                            line.frame = CGRectMake(5,memberView.frame.origin.y + memberView.frame.size.height + 10,300,1);
                        //                            [contentView addSubview:line];
                        //                            [line release];
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
#endif
                
                NSString *where = contentsData.contentDic[@"jlocation"];
                NSLog(@"where %@",where);
                NSDictionary *dic = [where objectFromJSONString];//componentsSeparatedByString:@","];
                
                
#ifdef BearTalk
#else
                if([dic[@"text"]length]>0)//                if(where != nil && [where length]>0)
                {
                    UIImageView *line;
                    
                    line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline2px_light.png"]];
                    line.frame = CGRectMake(0, memberView.frame.origin.y + memberView.frame.size.height + 10, 320,0.5);
                    
                    [contentsView addSubview:line];
//                    [line release];
                    
                    whLabel.font = [UIFont systemFontOfSize:12];
                    CGSize whSize = [dic[@"text"] sizeWithFont:whLabel.font constrainedToSize:CGSizeMake(280-15, 40) lineBreakMode:NSLineBreakByWordWrapping];
                    [whLabel setText:[NSString stringWithFormat:@"%@",dic[@"text"]]];
                    whImageView.frame = CGRectMake(10, line.frame.origin.y + line.frame.size.height + 10, 14, 14);
                    whLabel.numberOfLines = 2;
                    whLabel.textColor = RGB(54, 54, 55);
                    whLabel.frame = CGRectMake(whImageView.frame.origin.x + whImageView.frame.size.width + 3, whImageView.frame.origin.y, 320 - 30, whSize.height);
                    //                        whLabel.text = @"위치";
                }
                else{
                    [whLabel setText:@""];
                    whImageView.frame = CGRectMake(10, memberView.frame.origin.y + memberView.frame.size.height, 14, 0);
                    whLabel.frame = CGRectMake(whImageView.frame.origin.x + whImageView.frame.size.width + 3, whImageView.frame.origin.y, 320 - 30, 0);
                    
                }
#endif
                
                
                NSString *content = contentsData.contentDic[@"msg"];
                
                if([content length]>0){
                    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline2px_light.png"]];
                    [contentsView addSubview:line];
//                    [line release];
#ifdef BearTalk
                    line.frame = CGRectMake(15, CGRectGetMaxY(memberView.frame), contentsView.frame.size.width - 30,0.5);
                    
#else
                    line.frame = CGRectMake(0, whLabel.frame.origin.y + whLabel.frame.size.height + 10,320,0.5);
#endif
                    
                    //                UILabel *expTitle = [[UILabel alloc]initWithFrame:CGRectMake(title.frame.origin.x, line.frame.origin.y + line.frame.size.height + 10, 295, 20)];
                    //                [expTitle setTextAlignment:NSTextAlignmentLeft];
                    //                [expTitle setFont:[UIFont systemFontOfSize:15]];
                    //                [expTitle setBackgroundColor:[UIColor clearColor]];
                    //                [expTitle setTextColor:[UIColor grayColor]];//RGB(142,136,134)];
                    //                [contentsView addSubview:expTitle];
                    //                expTitle.text = @"설명";
                    //                [expTitle release];
                    
                    NSLog(@"content %@",content);
                    //        NSString *imageString = [contentsData.contentDicobjectForKey:@"image"];
                    [contentsTextView setText:content];
                    [contentsTextView setFont:[UIFont systemFontOfSize:12]];
                    contentsTextView.textColor = RGB(54, 54, 55);
                    
                    iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imageview_schedule_icon_explain.png"]];
                    iconImageView.frame = CGRectMake(10, line.frame.origin.y + line.frame.size.height + 10 + 3, 14, 14);
                    [contentsView addSubview:iconImageView];
//                    [iconImageView release];
                    
#ifdef BearTalk
                    iconImageView.hidden = YES;
////                    CGFloat borderWidth = 0.5f;
//                    contentsTextView.backgroundColor = [UIColor whiteColor];
//                    //    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
//                    contentsTextView.layer.borderColor = RGB(234, 234, 234).CGColor;
//                    contentsTextView.layer.borderWidth = borderWidth;
                    [contentsTextView setFont:[UIFont systemFontOfSize:15]];
                    contentsTextView.textColor = RGB(51, 51, 51);
                    CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:15] width:line.frame.size.width realZeroInsets:NO];
                    contentsTextView.frame = CGRectMake(line.frame.origin.x, CGRectGetMaxY(line.frame)+18, line.frame.size.width, cSize.height+18);
#else
                    CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:12] width:280 realZeroInsets:NO];
                    
                    contentsTextView.frame = CGRectMake(24, line.frame.origin.y + line.frame.size.height + 5, 280, cSize.height);
#endif
                    
                    
                }
                else{
#ifdef BearTalk
                    
                    contentsTextView.frame = CGRectMake(line.frame.origin.x, CGRectGetMaxY(memberView.frame), line.frame.size.width, 0);
#else
                    
                    contentsTextView.frame = CGRectMake(24, whLabel.frame.origin.y + whLabel.frame.size.height, 280, 0);
#endif
                }
                
                
                
#ifdef BearTalk
                
//                CGFloat borderWidth = 0.5f;
                contentsView.backgroundColor = [UIColor whiteColor];
                //    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
                contentsView.layer.borderColor = RGB(234, 234, 234).CGColor;
                contentsView.layer.borderWidth = borderWidth;
                if([dic[@"text"]length]>0)//                if(where != nil && [where length]>0)
                {
                    UIImageView *line;
                    
                    line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline2px_light.png"]];
                    line.frame = CGRectMake(15, CGRectGetMaxY(contentsTextView.frame), contentsView.frame.size.width - 30,0.5);
                    [contentsView addSubview:line];
                    
                    [whLabel setText:[NSString stringWithFormat:@"%@",dic[@"text"]]];
                    whLabel.numberOfLines = 1;
                    whLabel.textColor = RGB(51, 51, 51);
                    whLabel.frame = CGRectMake(15, CGRectGetMaxY(line.frame)+18, line.frame.size.width, 15);
                    whLabel.font = [UIFont systemFontOfSize:15];
                    whImageView.frame = CGRectMake(10, line.frame.origin.y + line.frame.size.height + 10, 0, 0);
                    //                        whLabel.text = @"위치";
                    
//                    line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline2px_light.png"]];
//                    line.frame = CGRectMake(15, CGRectGetMaxY(whLabel.frame)+18, contentsView.frame.size.width - 30,0.5);
//                    [contentsView addSubview:line];
                    
                    contentsView.frame = CGRectMake(16, CGRectGetMaxY(defaultView.frame), self.view.frame.size.width-32, CGRectGetMaxY(whLabel.frame)+18);
                }
                else{
                    [whLabel setText:@""];
                    whImageView.frame = CGRectMake(10, memberView.frame.origin.y + memberView.frame.size.height, 14, 0);
                    whLabel.frame = CGRectMake(0, CGRectGetMaxY(contentsTextView.frame), 0, 0);
                    contentsView.frame = CGRectMake(16, CGRectGetMaxY(defaultView.frame), self.view.frame.size.width-32, CGRectGetMaxY(whLabel.frame));
                    
                }
                
                NSLog(@"titleview %@",NSStringFromCGRect(titleView.frame));
                NSLog(@"timeView %@",NSStringFromCGRect(timeView.frame));
                NSLog(@"alarmView %@",NSStringFromCGRect(alarmView.frame));
                NSLog(@"memberView %@",NSStringFromCGRect(memberView.frame));
                NSLog(@"contentsTextView %@",NSStringFromCGRect(contentsTextView.frame));
                NSLog(@"whLabel %@",NSStringFromCGRect(whLabel.frame));
                NSLog(@"contentsView %@",NSStringFromCGRect(contentsView.frame));
#else
                contentsView.frame = CGRectMake(profileImageView.frame.origin.x, profileImageView.frame.origin.y + profileImageView.frame.size.height, 320, contentsTextView.frame.origin.y + contentsTextView.frame.size.height);
#endif
            }
            
            
            
            else
            {//([contentsData.contentType isEqualToString:@"1"]){
                
                
                
                
                NSString *content = contentsData.contentDic[@"msg"];
                NSString *where = contentsData.contentDic[@"jlocation"];
                NSString *imageString = contentsData.contentDic[@"image"];
                NSDictionary *pollDic = contentsData.pollDic;
                
                [contentsTextView setText:content];
                
                CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:fontSize] width:self.view.frame.size.width - 32 realZeroInsets:NO];
                
                contentsTextView.frame = CGRectMake(16, 0, self.view.frame.size.width - 32, cSize.height);
                
                
                NSDictionary *dic = [where objectFromJSONString];//componentsSeparatedByString:@","];
                if([dic[@"text"]length]>0) //              if(where != nil && [where length]>0)
                {
                    //                    NSDictionary *dic = [where objectFromJSONString];//componentsSeparatedByString:@","];
                    //
                    //                    if([dic[@"text"]length]<1)
                    //                        whLabel.text = @"위치";
                    //
                    //                    else
                    [whLabel setText:[NSString stringWithFormat:@"%@",dic[@"text"]]];
                    whImageView.frame = CGRectMake(16, CGRectGetMaxY(contentsTextView.frame), 14, 14);
                    whLabel.frame = CGRectMake(16+15, CGRectGetMaxY(contentsTextView.frame), 280-15, 16);
                }
                else{
                    [whLabel setText:@""];
                    whImageView.frame = CGRectMake(16, CGRectGetMaxY(contentsTextView.frame), 14, 0);
                    whLabel.frame = CGRectMake(16+15, CGRectGetMaxY(contentsTextView.frame), 280-15, 0);
                    
                }
                
                if(modifyImageArray){
//                    [modifyImageArray release];
                    modifyImageArray = nil;
                }
                modifyImageArray = [[NSMutableArray alloc]init];
                
                
                if(imageString != nil && [imageString length]>0)
                {
                    contentImageView.userInteractionEnabled = YES;
                    //        contentImageView.hidden = NO;
                    NSLog(@"imageString %@",imageString);
                    NSLog(@"contentsdata.imagecontent %@",contentsData.imageContent);
                    
                    
                    NSArray *imageArray;
                    
#ifdef BearTalk
                    imageArray = [imageString objectFromJSONString][@"filename"];
#else
                    
                    imageArray = [imageString objectFromJSONString][@"thumbnail"];
#endif
                    CGFloat imageHeight = 0.0f;
                    for(int i = 0; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
                        NSDictionary *sizeDic;
                        if([[imageString objectFromJSONString][@"thumbnailinfoarray"]count]>0)
                            sizeDic = [imageString objectFromJSONString][@"thumbnailinfoarray"][i];
                        else
                            sizeDic = [imageString objectFromJSONString][@"thumbnailinfo"];
                        NSLog(@"sizeDic %@",sizeDic);
                        CGFloat imageScale = 0.0f;
                        imageScale = (self.view.frame.size.width - 32)/[sizeDic[@"width"]floatValue];
                        UIImageView *inImageView = [[UIImageView alloc]init];
                        inImageView.frame = CGRectMake(0,imageHeight,self.view.frame.size.width - 32,imageScale * [sizeDic[@"height"]floatValue]);
                        imageHeight += inImageView.frame.size.height + 10;
                        NSLog(@"inimageview frame %@",NSStringFromCGRect(inImageView.frame));
                        inImageView.backgroundColor = [UIColor blackColor];
                        [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
                        [inImageView setClipsToBounds:YES];
                        NSURL *imgURL;
#ifdef BearTalk
                        
                        imgURL = [ResourceLoader resourceURLfromJSONString:imageString num:i thumbnail:NO];
                        NSData *imageData = [NSData dataWithContentsOfURL:imgURL];
                        NSLog(@"imgURL %@ imageData length %d",imgURL,[imageData length]);
                        UIImage *image = [UIImage imageWithData:imageData];
                        [modifyImageArray addObject:@{@"data" : imageData, @"image" : image}];
                               inImageView.image = [UIImage sd_animatedGIFWithData:imageData];
#else
                        imgURL = [ResourceLoader resourceURLfromJSONString:imageString num:i thumbnail:YES];
                        [inImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
                            
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                            NSLog(@"fail %@",[error localizedDescription]);

                            NSData *imageData = UIImagePNGRepresentation(image);
                            [modifyImageArray addObject:@{@"data" : imageData, @"image" : image}];

                            [HTTPExceptionHandler handlingByError:error];
                            
                        }];
#endif
                        [contentImageView addSubview:inImageView];
                        inImageView.userInteractionEnabled = YES;
                        
                        UIButton *viewImageButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,inImageView.frame.size.width,inImageView.frame.size.height)];
                        //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
                        [viewImageButton addTarget:self action:@selector(viewImage:) forControlEvents:UIControlEventTouchUpInside];
                        viewImageButton.tag = i;
                        [inImageView addSubview:viewImageButton];
//                        [viewImageButton release];
//                        [inImageView release];
                        
                        
                        //                    contentImageView.backgroundColor = [UIColor blackColor];
                        //                        viewImageButton.backgroundColor = [UIColor redColor];
                        
                        
                    }
                    
                    contentImageView.frame = CGRectMake(16, CGRectGetMaxY(whImageView.frame)+5, self.view.frame.size.width - 32, imageHeight);
                    
                    
                }
                else{
                    contentImageView.frame = CGRectMake(16, CGRectGetMaxY(whImageView.frame), self.view.frame.size.width - 32, 0);
                }
                
                pollView.userInteractionEnabled = YES;
                pollView.frame = CGRectMake(16, CGRectGetMaxY(contentImageView.frame), self.view.frame.size.width - 32, 0);
                
                if(pollDic != nil){
               
                    if(answerArray){
//                        [answerArray release];
                        answerArray = nil;
                    }
                    answerArray = [[NSMutableArray alloc]init];
                    if(myAnswerArray){
//                        [myAnswerArray release];
                        myAnswerArray = nil;
                    }
                    myAnswerArray = [[NSMutableArray alloc]init];
                    if(btnArray){
//                        [btnArray release];
                        btnArray = nil;
                    }
                    btnArray = [[NSMutableArray alloc]init];
                    
                    NSLog(@"pollDic %@",pollDic);
                    
#ifdef BearTalk
                    pollView.image = nil;
                    pollView.frame = CGRectMake(16, CGRectGetMaxY(contentImageView.frame)+10, contentsView.frame.size.width-32, 0);
                    
                    
                    pollView.clipsToBounds = YES;
                    pollView.layer.borderWidth = 1.0;
                    pollView.layer.cornerRadius = 3.0;
                    pollView.layer.borderColor = [RGB(245, 245, 245) CGColor];
                    
                    
                    UIImageView *clipIcon;
                    UILabel *fileInfo;
                    
                    
                    
                    pollView.backgroundColor = [UIColor whiteColor];
                    
                    
                    UIImageView *titleBgview;
                    titleBgview = [[UIImageView alloc]init];
                    titleBgview.userInteractionEnabled = YES;
                    titleBgview.tag = 100;
                    titleBgview.backgroundColor = RGB(251,251,251);
                    titleBgview.frame = CGRectMake(0,0,pollView.frame.size.width,57);
                    [pollView addSubview:titleBgview];
                    
                    
                    clipIcon = [[UIImageView alloc]init];
                    clipIcon.userInteractionEnabled = YES;
                    clipIcon.tag = 100;
                    clipIcon.image = [UIImage imageNamed:@"btn_survey_off.png"];
                    clipIcon.frame = CGRectMake(16, 16, 24, 24);
                    
                    [titleBgview addSubview:clipIcon];
                    fileInfo = [[UILabel alloc]init];
                    fileInfo.userInteractionEnabled = YES;
                    fileInfo.tag = 300;
                    [titleBgview addSubview:fileInfo];
                    
                    fileInfo.textAlignment = NSTextAlignmentLeft;
                    fileInfo.font = [UIFont systemFontOfSize:14];
                    fileInfo.numberOfLines = 0;
                    
                    
                    
                    NSString *ing_ed;
                    if([pollDic[@"is_close"]isEqualToString:@"1"]){
                        ing_ed = @"종료 ";
                    }
                    else{
                        ing_ed = @"진행중 ";
                        
                    }
                    
                    NSString *subtitle = @"";
                    if([pollDic[@"is_anon"]isEqualToString:@"1"])
                        subtitle = [subtitle stringByAppendingString:@"무기명 "];
                    
                    if([pollDic[@"is_multi"]isEqualToString:@"1"])
                        subtitle = [subtitle stringByAppendingString:@"(복수 선택 가능)"];
                    
                    
                    NSString *msg = [NSString stringWithFormat:@"%@ %@\n%@",ing_ed,subtitle,pollDic[@"title"]];
                    NSArray *texts=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@ ",ing_ed],[NSString stringWithFormat:@"%@\n",subtitle],pollDic[@"title"],nil];
                    NSLog(@"msg %@",msg);
                    
                    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
                    [string addAttribute:NSForegroundColorAttributeName value: [NSKeyedUnarchiver unarchiveObjectWithData:colorData] range:[msg rangeOfString:texts[0]]];
                    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[0]]];
                    [string addAttribute:NSForegroundColorAttributeName value:RGB(153, 153, 153) range:[msg rangeOfString:texts[1]]];
                    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[1]]];
                    [string addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51) range:[msg rangeOfString:texts[2]]];
                    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[msg rangeOfString:texts[2]]];
                    [fileInfo setAttributedText:string];
                    fileInfo.numberOfLines = 0;
                    
                    CGSize titleSize = [fileInfo.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(titleBgview.frame.size.width - (CGRectGetMaxX(clipIcon.frame)) - 16 - 70-5, 150) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    fileInfo.frame = CGRectMake(CGRectGetMaxX(clipIcon.frame)+5, 5, titleBgview.frame.size.width - (CGRectGetMaxX(clipIcon.frame)) - 16 - 70-5, titleSize.height>47?titleSize.height:47);
                    NSLog(@"text %@ fileinfo %@",fileInfo.text,NSStringFromCGRect(fileInfo.frame));
                    
                    titleBgview.frame = CGRectMake(0,0,pollView.frame.size.width,titleSize.height>47?titleSize.height+10:47+10);
                    
                    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleBgview.frame.size.width - 16-70, 0, 70, titleBgview.frame.size.height)];
                    [countLabel setTextAlignment:NSTextAlignmentRight];
                    [countLabel setFont:[UIFont systemFontOfSize:12]];
                    [countLabel setBackgroundColor:[UIColor clearColor]];
                    [countLabel setTextColor:RGB(151, 152, 157)];
                    [titleBgview addSubview:countLabel];
                    countLabel.text = [NSString stringWithFormat:@"%@명 참여",pollDic[@"poll_answer"]];
                    
                    
                    
                    UIImageView *line = [[UIImageView alloc]init];
                    line.backgroundColor = RGB(237, 237, 237);
                    line.frame = CGRectMake(0,CGRectGetMaxY(titleBgview.frame),pollView.frame.size.width,1);
                    [pollView addSubview:line];
                    //                    [line release];
                    
                    float optHeight = 0;
                    float optViewHeight = CGRectGetMaxY(titleBgview.frame)+1;
                    
                    NSArray *optArray = pollDic[@"options"];
                    for(int i = 0; i < [optArray count]; i++){
                        
                        
                        UIView *optionView = [[UIView alloc]init];
                        optionView.frame = CGRectMake(0,optViewHeight,pollView.frame.size.width, 0);
                        [pollView addSubview:optionView];
                        
                        UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(16,14,24,24)];
                        checkBtn.adjustsImageWhenHighlighted = NO;
                        checkBtn.titleLabel.text = optArray[i][@"number"];
                        checkBtn.layer.borderWidth = 1.0f;
                        checkBtn.layer.borderColor = [RGB(223,223,223)CGColor];
                        checkBtn.backgroundColor =  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
                        checkBtn.layer.cornerRadius = checkBtn.frame.size.width/2;
                        [optionView addSubview:checkBtn];
                        
                        UIImageView *checkImageView;
                        checkImageView = [[UIImageView alloc]init];
                        checkImageView.userInteractionEnabled = YES;
                        checkImageView.backgroundColor = RGB(251,251,251);
                        checkImageView.image = [UIImage imageNamed:@"select_check_white.png"];
                        checkImageView.frame = CGRectMake(24/2-16/2, 24/2-13/2, 16, 13);
                        checkImageView.backgroundColor = [UIColor clearColor];
                        [checkBtn addSubview:checkImageView];
                    
                        
                        
                        
                        
                        if([pollDic[@"is_multi"]isEqualToString:@"1"]){
                            NSLog(@"is_multi yes");
                            [checkBtn addTarget:self action:@selector(cmdMultiCheck:) forControlEvents:UIControlEventTouchUpInside];
                            
                            if([optArray[i][@"myvote"]isEqualToString:@"1"]){
                                checkBtn.backgroundColor =  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
//                                checkImageView.hidden = NO;
                                checkBtn.selected = YES;
                                [answerArray addObject:[NSDictionary dictionaryWithObject:optArray[i][@"number"] forKey:@"number"]];
                                [myAnswerArray addObject:[NSDictionary dictionaryWithObject:optArray[i][@"number"] forKey:@"number"]];
                                
                            }
                            else{
                                checkBtn.backgroundColor = RGB(249, 249, 249);
//                                checkImageView.hidden = YES;
//                                checkImageView.image = nil;
                                checkBtn.selected = NO;
                                
                            }
                            
                            
                        }
                        else{
                            NSLog(@"is_multi no");
                            [checkBtn addTarget:self action:@selector(cmdSingularCheck:) forControlEvents:UIControlEventTouchUpInside];
                            
                            if([optArray[i][@"myvote"]isEqualToString:@"1"]){
                                checkBtn.backgroundColor =  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
//                                checkImageView.hidden = NO;
                                checkBtn.selected = YES;
                                checkBtn.selected = YES;
                                [answerArray addObject:[NSDictionary dictionaryWithObject:optArray[i][@"number"] forKey:@"number"]];
                                [myAnswerArray addObject:[NSDictionary dictionaryWithObject:optArray[i][@"number"] forKey:@"number"]];
//                                [checkBtn setBackgroundImage:[UIImage imageNamed:@"radio_prs.png"] forState:UIControlStateNormal];
                            }
                            else{
                                checkBtn.backgroundColor = RGB(249, 249, 249);
//                                checkImageView.hidden = YES;
                                checkBtn.selected = NO;
//                                [checkBtn setBackgroundImage:[UIImage imageNamed:@"radio_dft.png"] forState:UIControlStateNormal];
                            }
                            
                            
                            [btnArray addObject:checkBtn];
                            
                        }
                        
                        
                        if([pollDic[@"is_close"]isEqualToString:@"1"]){
                            checkBtn.hidden = YES;
                            checkBtn.frame = CGRectMake(10,14,0,24);
                        }
                        else{
                            checkBtn.hidden = NO;
                            checkBtn.frame = CGRectMake(16,14,24,24);
                        }
                        
                        NSString *opt = optArray[i][@"name"];
                        
                        
                        CGSize optSize = [opt sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(optionView.frame.size.width - (CGRectGetMaxX(checkBtn.frame)+5) - 16 - 30 - 5, 150) lineBreakMode:NSLineBreakByWordWrapping];
                        
                        NSLog(@"optHeight %f",optHeight);
                        
                        optHeight = optSize.height>24?optSize.height:24;
                        
                        UILabel *optLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(checkBtn.frame)+5, checkBtn.frame.origin.y, optionView.frame.size.width - (CGRectGetMaxX(checkBtn.frame)+5) - 16 - 30 - 5, optHeight)];
                        
                        [optLabel setTextAlignment:NSTextAlignmentLeft];
                        [optLabel setFont:[UIFont systemFontOfSize:14]];
                        [optLabel setNumberOfLines:0];
                        [optLabel setBackgroundColor:[UIColor clearColor]];
                        [optLabel setTextColor:RGB(51, 51, 51)];//RGB(142,136,134)];
                        [optionView addSubview:optLabel];
                        optLabel.text = opt;
                        //                        [optLabel release];
                        //                        CGSize size = [opt sizeWithFont:optLabel.font];
                        
                        UILabel *eachcountLabel = [[UILabel alloc]initWithFrame:CGRectMake(optionView.frame.size.width - 30 - 16, optLabel.frame.origin.y, 30, 24)];
                        [eachcountLabel setTextAlignment:NSTextAlignmentRight];
                        [eachcountLabel setFont:[UIFont systemFontOfSize:12]];
                        [eachcountLabel setBackgroundColor:[UIColor clearColor]];
                        [eachcountLabel setTextColor:RGB(151, 152, 157)];
                        [optionView addSubview:eachcountLabel];
                        eachcountLabel.text = [NSString stringWithFormat:@"%@명",optArray[i][@"count"]];
                        //                        [countLabel release];
                        
                        
                        
                        if([optArray[i][@"myvote"]isEqualToString:@"1"]){
                            optLabel.textColor =  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
                            eachcountLabel.textColor =  [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
                        }
                        else{
                            optLabel.textColor = RGB(51, 51, 51);
                            eachcountLabel.textColor = RGB(151, 152, 157);
                        }
                        
                    
                    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(optLabel.frame.origin.x, CGRectGetMaxY(optLabel.frame)+5, optLabel.frame.size.width, 0)];
                    [nameLabel setTextAlignment:NSTextAlignmentLeft];
                    [nameLabel setNumberOfLines:2];
                    [nameLabel setFont:[UIFont systemFontOfSize:11]];
                    [nameLabel setBackgroundColor:[UIColor clearColor]];
                    [nameLabel setTextColor:RGB(151,152,157)];//RGB(142,136,134)];
                    [optionView addSubview:nameLabel];
                    
                    
                    NSString *name = optArray[i][@"username"];
                    if([pollDic[@"is_anon"]isEqualToString:@"0"] &&
                       [name length]>0 &&
                       [pollDic[@"is_visible_dstatus"]isEqualToString:@"0"])
                    {
                        NSLog(@"optHeight4 %.0f",optHeight);
                        CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:11] constrainedToSize:CGSizeMake(optLabel.frame.size.width, 24) lineBreakMode:NSLineBreakByWordWrapping];
                        nameLabel.frame = CGRectMake(optLabel.frame.origin.x, CGRectGetMaxY(optLabel.frame)+5, optLabel.frame.size.width, nameSize.height);
                        nameLabel.text = name;
                        optHeight += nameLabel.frame.size.height+5;
                        nameLabel.userInteractionEnabled = YES;
                        
                        UIButton *viewButton = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor: [NSKeyedUnarchiver unarchiveObjectWithData:colorData] target:self selector:@selector(viewDetailMember:) frame:CGRectMake(0, 0, nameLabel.frame.size.width, nameLabel.frame.size.height) cachedImageNamedBullet:nil cachedImageNamedNormal:@"" cachedImageNamedPressed:nil];
                        [nameLabel addSubview:viewButton];
                        viewButton.titleLabel.text = opt;
                        
                        if(nameSize.height>24){
                            
                            UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame)+5, nameLabel.frame.size.width, 12)];
                            [detailLabel setTextAlignment:NSTextAlignmentLeft];
                            [detailLabel setNumberOfLines:1];
                            [detailLabel setFont:[UIFont systemFontOfSize:11]];
                            [detailLabel setBackgroundColor:[UIColor clearColor]];
                            [detailLabel setTextColor:RGB(151,152,157)];//RGB(142,136,134)];
                            [optionView addSubview:detailLabel];
                            detailLabel.text = @"전체보기";
                            optHeight += detailLabel.frame.size.height+5;
                            detailLabel.userInteractionEnabled = YES;
                            
                            viewButton = [CustomUIKit buttonWithTitle:@"" fontSize:0 fontColor: [NSKeyedUnarchiver unarchiveObjectWithData:colorData] target:self selector:@selector(viewDetailMember:) frame:CGRectMake(0, 0, detailLabel.frame.size.width, detailLabel.frame.size.height) cachedImageNamedBullet:nil cachedImageNamedNormal:@"" cachedImageNamedPressed:nil];
                            [detailLabel addSubview:viewButton];
                            
                            viewButton.titleLabel.text = opt;
                        }
                    }
                    
                        optionView.frame = CGRectMake(0,optViewHeight,pollView.frame.size.width,14+optHeight+14+1);
                        
                        
                        UIImageView *line = [[UIImageView alloc]init];
                        line.backgroundColor = RGB(237, 237, 237);
                        line.frame = CGRectMake(15, optionView.frame.size.height-1, optionView.frame.size.width-32,1);
                        [optionView addSubview:line];
                        
                        optViewHeight += optionView.frame.size.height;
                        
                        NSLog(@"optHeight %f",optHeight);
                    NSLog(@"optViewHeight %f",optViewHeight);
                        NSLog(@"optionView %@",NSStringFromCGRect(optionView.frame));
                    }
                    
                    
                    UIButton *endBtn = [CustomUIKit buttonWithTitle:@"" fontSize:14 fontColor: [NSKeyedUnarchiver unarchiveObjectWithData:colorData] target:self selector:@selector(endPoll:) frame:CGRectMake(20, optViewHeight+10, 104, 0) cachedImageNamedBullet:nil cachedImageNamedNormal:@"" cachedImageNamedPressed:nil];
                    [pollView addSubview:endBtn];
                 
                    //                    [endBtn release];
                    
//                    UIButton *pollBtn = [CustomUIKit buttonWithTitle:@"투표하기" fontSize:14 fontColor: [NSKeyedUnarchiver unarchiveObjectWithData:colorData] target:self selector:@selector(cmdPoll) frame:CGRectMake(pollView.frame.size.width/2 - 104/2, CGRectGetMaxY(optionView.frame)+10, 104, 38) cachedImageNamedBullet:nil cachedImageNamedNormal:@"" cachedImageNamedPressed:nil];
//                    [pollView addSubview:pollBtn];
//                    pollBtn.layer.borderWidth = 1;
//                    pollBtn.layer.borderColor = [ [NSKeyedUnarchiver unarchiveObjectWithData:colorData] CGColor];
//                    pollBtn.backgroundColor = [UIColor clearColor];
//                    pollBtn.layer.cornerRadius = 2;
                    
                    if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        [endBtn setTitle:@"종료하기" forState:UIControlStateNormal & UIControlStateHighlighted & UIControlStateSelected];
//                        endBtn.frame = CGRectMake(16, CGRectGetMaxY(optionView.frame)+10, 104, 38);
                        endBtn.frame = CGRectMake(pollView.frame.size.width/2-104/2, optViewHeight+10, 104, 38);
                        endBtn.layer.borderWidth = 1;
                        endBtn.layer.borderColor = [ [NSKeyedUnarchiver unarchiveObjectWithData:colorData] CGColor];
                        endBtn.backgroundColor = [UIColor clearColor];
                        endBtn.layer.cornerRadius = 2;
                    }
                    
                    //                    [pollBtn release];
                    
                    if([pollDic[@"is_close"]isEqualToString:@"1"]){
                        endBtn.hidden = YES;
                        endBtn.frame = CGRectMake(20, optViewHeight+10, 102, 0);
//                        pollBtn.frame = CGRectMake(pollView.frame.size.width - 20 - 102, endBtn.frame.origin.y, 102, 0);
                    }
                    NSLog(@"endBtn %@",NSStringFromCGRect(endBtn.frame));
                    
                    UIButton *detailBtn = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewDetailMember:) frame:CGRectMake(14, CGRectGetMaxY(endBtn.frame)+10, 274, 0) cachedImageNamedBullet:nil cachedImageNamedNormal:@"" cachedImageNamedPressed:nil];
//                    [pollView addSubview:detailBtn];
//                    
//                    if([pollDic[@"is_visible_dstatus"]isEqualToString:@"1"]){
//                        detailBtn.frame = CGRectMake(14, pollBtn.frame.origin.y + pollBtn.frame.size.height + 10, 274, 38);
//                    }
                    
                    
                    
                    pollView.frame = CGRectMake(pollView.frame.origin.x, pollView.frame.origin.y, pollView.frame.size.width, CGRectGetMaxY(detailBtn.frame));
                    
                    NSLog(@"pollView %@",NSStringFromCGRect(pollView.frame));
                    
                    
#else
                    NSString *subtitle = @"";
                    if([pollDic[@"is_anon"]isEqualToString:@"1"]){
                        subtitle = [subtitle stringByAppendingString:@"무기명 "];
                    }
                    subtitle = [subtitle stringByAppendingString:@"설문 "];
                    if([pollDic[@"is_close"]isEqualToString:@"1"]){
                        subtitle = [subtitle stringByAppendingString:@"종료"];
                    }
                    else{
                        subtitle = [subtitle stringByAppendingString:@"진행중"];
                        
                        if([pollDic[@"is_multi"]isEqualToString:@"1"])
                            subtitle = [subtitle stringByAppendingString:@" (복수 선택 가능)"];
                    }
                    subtitle = [subtitle stringByAppendingString:@" - "];
                    UILabel *subLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, pollView.frame.size.width - 30, 20)];
                    [subLabel setTextAlignment:NSTextAlignmentLeft];
                    [subLabel setFont:[UIFont systemFontOfSize:15]];
                    CGSize size = [subtitle sizeWithAttributes:@{NSFontAttributeName:subLabel.font}];
                    [subLabel setBackgroundColor:[UIColor clearColor]];
                    [subLabel setTextColor:RGB(55, 158, 216)];
                    [pollView addSubview:subLabel];
                    subLabel.text = subtitle;
//                    [subLabel release];
                    
                    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(subLabel.frame.origin.x + size.width, subLabel.frame.origin.y, pollView.frame.size.width - size.width - 10, 20)];
                    [countLabel setTextAlignment:NSTextAlignmentLeft];
                    [countLabel setFont:[UIFont systemFontOfSize:15]];
                    [countLabel setBackgroundColor:[UIColor clearColor]];
                    [countLabel setTextColor:RGB(53, 140, 24)];
                    [pollView addSubview:countLabel];
                    countLabel.text = [NSString stringWithFormat:@"%@명 참여",pollDic[@"poll_answer"]];
//                    [countLabel release];
                    
                    
                    NSString *title = pollDic[@"title"];
                    NSLog(@"title %@",title);
                    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(pollView.frame.size.width - 10, 150) lineBreakMode:NSLineBreakByWordWrapping];
                    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(subLabel.frame.origin.x, subLabel.frame.origin.y + subLabel.frame.size.height + 5, subLabel.frame.size.width, titleSize.height)];
                    [titleLabel setTextAlignment:NSTextAlignmentLeft];
                    [titleLabel setFont:[UIFont systemFontOfSize:15]];
                    [titleLabel setNumberOfLines:0];
                    [titleLabel setBackgroundColor:[UIColor clearColor]];
                    [titleLabel setTextColor:[UIColor blackColor]];//RGB(142,136,134)];
                    [pollView addSubview:titleLabel];
                    titleLabel.text = title;
//                    [titleLabel release];
                    
                    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline2px_light.png"]];
                    line.frame = CGRectMake(titleLabel.frame.origin.x,titleLabel.frame.origin.y + titleLabel.frame.size.height + 15,274,2);
                    [pollView addSubview:line];
//                    [line release];
                    
                    float optHeight = line.frame.origin.y + line.frame.size.height;
                    NSArray *optArray = pollDic[@"options"];
                    
                    for(int i = 0; i < [optArray count]; i++){
                        
                        float eachHeight = 0.0f;
                        float eachY = optHeight;
                        NSLog(@"optHeight1 %.0f",optHeight);
                        optHeight += 15;
                        eachHeight += 15;
                        NSLog(@"optHeight2 %.0f",optHeight);
                        
                        NSString *opt = optArray[i][@"name"];
                        opt = [opt stringByAppendingString:@""];
                        CGSize optSize = [opt sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(pollView.frame.size.width - 15 - 15 - 35 - 10 - 40, 150) lineBreakMode:NSLineBreakByWordWrapping];
                        UILabel *optLabel = [[UILabel alloc]initWithFrame:CGRectMake(line.frame.origin.x, optHeight, pollView.frame.size.width - 15 - 15 - 35 - 10 - 40, optSize.height)];
                        optHeight += optSize.height;
                        eachHeight += optSize.height;
                        [optLabel setTextAlignment:NSTextAlignmentLeft];
                        [optLabel setFont:[UIFont systemFontOfSize:15]];
                        [optLabel setNumberOfLines:0];
                        [optLabel setBackgroundColor:[UIColor clearColor]];
                        [optLabel setTextColor:RGB(108, 123, 160)];//RGB(142,136,134)];
                        [pollView addSubview:optLabel];
                        optLabel.text = opt;
//                        [optLabel release];
                        //                        CGSize size = [opt sizeWithFont:optLabel.font];
                        UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(optLabel.frame.origin.x + optSize.width + 5, optLabel.frame.origin.y + optSize.height/2 - 10, 50, 20)];
                        [countLabel setTextAlignment:NSTextAlignmentLeft];
                        [countLabel setFont:[UIFont systemFontOfSize:15]];
                        [countLabel setBackgroundColor:[UIColor clearColor]];
                        [countLabel setTextColor:RGB(111, 139, 27)];
                        [pollView addSubview:countLabel];
                        countLabel.text = [NSString stringWithFormat:@"- %@명",optArray[i][@"count"]];
//                        [countLabel release];
                        
                        NSLog(@"optHeight3 %.0f",optHeight);
                        optHeight += 10;
                        eachHeight += 10;
                        
                        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(optLabel.frame.origin.x, optHeight, optLabel.frame.size.width, 0)];
                        
                        NSString *name = optArray[i][@"username"];
                        if([pollDic[@"is_anon"]isEqualToString:@"0"] &&
                           [pollDic[@"num_pollee"]intValue]<30 &&
                           [name length]>0 &&
                           [pollDic[@"is_visible_dstatus"]isEqualToString:@"0"])
                        {
                            NSLog(@"optHeight4 %.0f",optHeight);
                            CGSize nameSize = [name sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(pollView.frame.size.width - 15 - 15 - 35 - 10 - 30, 100) lineBreakMode:NSLineBreakByWordWrapping];
                            nameLabel.frame = CGRectMake(optLabel.frame.origin.x, optHeight, nameSize.width, nameSize.height);
                            [nameLabel setTextAlignment:NSTextAlignmentLeft];
                            [nameLabel setNumberOfLines:0];
                            [nameLabel setFont:[UIFont systemFontOfSize:15]];
                            [nameLabel setBackgroundColor:[UIColor clearColor]];
                            [nameLabel setTextColor:[UIColor blackColor]];//RGB(142,136,134)];
                            [pollView addSubview:nameLabel];
                            nameLabel.text = name;
                            optHeight += nameSize.height + 15;
                            eachHeight += nameSize.height + 15;
                        }
                        else{
                            NSLog(@"optHeight5 %.0f",optHeight);
                            optHeight += 5;
                            eachHeight += 5;
                            
                        }
                        
                        
                        NSLog(@"optHeight6 %.0f",optHeight);
                        UIImageView *lightline = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gryline1px.png"]];
                        lightline.frame = CGRectMake(nameLabel.frame.origin.x,optHeight,274,1);
                        [pollView addSubview:lightline];
//                        [lightline release];
//                        [nameLabel release];
                        
                        UIButton *checkBtn = [[UIButton alloc]initWithFrame:CGRectMake(pollView.frame.size.width - 15 - 35,
                                                                                       (eachY + eachHeight/2) - 17,
                                                                                       35, 35)];
                        
                        
                        checkBtn.adjustsImageWhenHighlighted = NO;
                        checkBtn.titleLabel.text = optArray[i][@"number"];
                        if([pollDic[@"is_multi"]isEqualToString:@"1"]){
                            NSLog(@"is_multi yes");
                            [checkBtn addTarget:self action:@selector(cmdMultiCheck:) forControlEvents:UIControlEventTouchUpInside];
                            
                            if([optArray[i][@"myvote"]isEqualToString:@"1"]){
                                checkBtn.selected = YES;
                                [answerArray addObject:[NSDictionary dictionaryWithObject:optArray[i][@"number"] forKey:@"number"]];
                                [myAnswerArray addObject:[NSDictionary dictionaryWithObject:optArray[i][@"number"] forKey:@"number"]];
                                [checkBtn setBackgroundImage:[UIImage imageNamed:@"vote_check_prs.png"] forState:UIControlStateNormal];
                            }
                            else{
                                checkBtn.selected = NO;
                                [checkBtn setBackgroundImage:[UIImage imageNamed:@"vote_check_dft.png"] forState:UIControlStateNormal];
                            }
                            
                        }
                        else{
                            NSLog(@"is_multi no");
                            [checkBtn addTarget:self action:@selector(cmdSingularCheck:) forControlEvents:UIControlEventTouchUpInside];
                            
                            if([optArray[i][@"myvote"]isEqualToString:@"1"]){
                                checkBtn.selected = YES;
                                [answerArray addObject:[NSDictionary dictionaryWithObject:optArray[i][@"number"] forKey:@"number"]];
                                [myAnswerArray addObject:[NSDictionary dictionaryWithObject:optArray[i][@"number"] forKey:@"number"]];
                                [checkBtn setBackgroundImage:[UIImage imageNamed:@"radio_prs.png"] forState:UIControlStateNormal];
                            }
                            else{
                                checkBtn.selected = NO;
                                [checkBtn setBackgroundImage:[UIImage imageNamed:@"radio_dft.png"] forState:UIControlStateNormal];
                            }
                            
                            [btnArray addObject:checkBtn];
                            
                        }
                        [pollView addSubview:checkBtn];
                        
                        if([pollDic[@"is_close"]isEqualToString:@"1"]){
                            checkBtn.enabled = NO;
                        }
                        else{
                            checkBtn.enabled = YES;
                        }
//                        [checkBtn release];
                        
                        
                        
                    }
                    
                    
                    UIButton *endBtn = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(endPoll:) frame:CGRectMake(20, optHeight + 10, 102, 0) cachedImageNamedBullet:nil cachedImageNamedNormal:@"vote_no.png" cachedImageNamedPressed:nil];
                    [pollView addSubview:endBtn];
                    if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                        endBtn.frame = CGRectMake(20, optHeight + 10, 102, 38);
                    }
//                    [endBtn release];
                    
                    UIButton *pollBtn = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdPoll) frame:CGRectMake(pollView.frame.size.width - 20 - 102, endBtn.frame.origin.y, 102, 38) cachedImageNamedBullet:nil cachedImageNamedNormal:@"vote_ok.png" cachedImageNamedPressed:nil];
                    [pollView addSubview:pollBtn];
//                    [pollBtn release];
                    
                    if([pollDic[@"is_close"]isEqualToString:@"1"]){
                        endBtn.frame = CGRectMake(20, optHeight, 102, 0);
                        pollBtn.frame = CGRectMake(pollView.frame.size.width - 20 - 102, endBtn.frame.origin.y, 102, 0);
                    }
                    UIButton *detailBtn = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(viewDetailMember:) frame:CGRectMake(14, pollBtn.frame.origin.y + pollBtn.frame.size.height, 274, 0) cachedImageNamedBullet:nil cachedImageNamedNormal:@"vote_deepseebtn.png" cachedImageNamedPressed:nil];
                    [pollView addSubview:detailBtn];
                    
                    if([pollDic[@"is_visible_dstatus"]isEqualToString:@"1"]){
                        detailBtn.frame = CGRectMake(14, pollBtn.frame.origin.y + pollBtn.frame.size.height + 10, 274, 38);
                    }
                    
//                    [detailBtn release];
                    
                    
                    
                    pollView.frame = CGRectMake(9, CGRectGetMaxY(contentImageView.frame)+5, 302, CGRectGetMaxY(detailBtn.frame)+10);
                    
#endif
                }
                else{
                    
                    pollView.frame = CGRectMake(9, CGRectGetMaxY(contentImageView.frame), 302, 0);
                }
                
                NSArray *fileArray = contentsData.fileArray;
                NSLog(@"fileArray %@",fileArray);
                fileView.frame = CGRectMake(16, CGRectGetMaxY(pollView.frame), self.view.frame.size.width - 32, 0);
                
                if([fileArray count]>0){
                    
#ifdef BearTalk
                    fileView.image = nil;
                      for(int i = 0; i < [fileArray count]; i++){
                          
                          NSDictionary *fileDic = fileArray[i];
                          
                          UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0 + (57+8)*i,fileView.frame.size.width,57)];
                          bgView.userInteractionEnabled = YES;
                          
                          bgView.layer.borderWidth = 1.0;
                          bgView.layer.borderColor = [RGB(244, 244, 244) CGColor];
                          bgView.layer.cornerRadius = 3.0; // rounding label
                          bgView.clipsToBounds = YES;
                          bgView.backgroundColor = RGB(251, 251, 251);
                          [fileView addSubview:bgView];
                    
                    UIImageView *clipIcon;
                    UILabel *fileInfo;
                          UIImageView *downloadImage;
                    
                    
                    fileView.backgroundColor = [UIColor clearColor];
                    
                    
                    clipIcon = [[UIImageView alloc]init];
                    clipIcon.userInteractionEnabled = YES;
                    clipIcon.tag = 100;
                    clipIcon.image = [UIImage imageNamed:@"btn_document_off.png"];
                    clipIcon.frame = CGRectMake(16, 16, 24, 24);
                    
                    [bgView addSubview:clipIcon];
                    
                          
                          downloadImage = [[UIImageView alloc]init];
                          downloadImage.frame = CGRectMake(bgView.frame.size.width - 16 - 28, 14, 28, 28);
                          downloadImage.userInteractionEnabled = YES;
                          downloadImage.tag = 200;
                          [bgView addSubview:downloadImage];
                          downloadImage.image = [UIImage imageNamed:@"btn_file_download.png"];
                    
                    fileInfo = [[UILabel alloc]init];
                    fileInfo.userInteractionEnabled = YES;
                 
                    [bgView addSubview:fileInfo];
                    fileInfo.frame = CGRectMake(CGRectGetMaxX(clipIcon.frame)+5, 0, bgView.frame.size.width - (CGRectGetMaxX(clipIcon.frame)) - 16 - 28-5, bgView.frame.size.height);
                    fileInfo.textAlignment = NSTextAlignmentLeft;
                    fileInfo.font = [UIFont systemFontOfSize:14];
                    
                          
                          
                          
                          NSString *msg = [NSString stringWithFormat:@"파일\n%@",fileDic[@"filename"]];
                          NSLog(@"msg %@",msg);
                          NSArray *texts=[NSArray arrayWithObjects:@"파일\n",fileDic[@"filename"],nil];
                          NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:msg];
                          [string addAttribute:NSForegroundColorAttributeName value: [NSKeyedUnarchiver unarchiveObjectWithData:colorData] range:[msg rangeOfString:texts[0]]];
                          [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[msg rangeOfString:texts[0]]];
                          [string addAttribute:NSForegroundColorAttributeName value:RGB(51, 51, 51) range:[msg rangeOfString:texts[1]]];
                          [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:[msg rangeOfString:texts[1]]];
                          [fileInfo setAttributedText:string];
                          fileInfo.numberOfLines = 0;
                          
                          
//                          NSArray *fileNameArray = [fileDic[@"filename"] componentsSeparatedByString:@"."];
//                          NSString *fileExt = fileNameArray[[fileNameArray count]-1];
//                          
//                          if([[fileDic[@"filename"] pathExtension]length]>0){
//                              fileExt = [fileDic[@"filename"] pathExtension];
//                          }
//                          else{
//                              
//                              
//                              NSArray *fileNameArray = [fileDic[@"file_ext"] componentsSeparatedByString:@"/"];
//                              if([fileNameArray count]>1)
//                              fileExt = fileNameArray[[fileNameArray count]-1];
//                              
//                          }
//    
//                          NSLog(@"fileExt %@",fileExt);
//                          
                          UIButton *viewFileButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,bgView.frame.size.width,bgView.frame.size.height)];
                          //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
//                          if([fileExt hasPrefix:@"hwp"]){
//                              [viewFileButton addTarget:self action:@selector(viewHWPFile:) forControlEvents:UIControlEventTouchUpInside];
//                          }
//                          else{
                              [viewFileButton addTarget:self action:@selector(viewFile:) forControlEvents:UIControlEventTouchUpInside];
//                          }
                          
                          viewFileButton.tag = i;
                          [bgView addSubview:viewFileButton];

                      }
                    
//
//                        
//                        
//
//                        NSString *text = @"";
//                        text = [NSString stringWithFormat:@"%@",fileDic[@"filename"]];
//                        
//                        UIImageView *coverImage = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 10, 41, 44)];
//                        coverImage.frame = CGRectMake(10,10,41,44);
//                        //                        coverImage.image = [UIImage imageNamed:@"vote_listbtn.png"];
//                        //                        coverImage.backgroundColor = [UIColor grayColor];
//                        [bgView addSubview:coverImage];
//                        //                        [coverImage release];
//                        
//                        //                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, coverImage.frame.size.width, coverImage.frame.size.height)];
//                        //                        [label setTextAlignment:NSTextAlignmentCenter];
//                        //                        [label setFont:[UIFont systemFontOfSize:15]];
//                        //                        [label setNumberOfLines:1];
//                        //                        [label setBackgroundColor:[UIColor clearColor]];
//                        //                        [label setTextColor:[UIColor whiteColor]];
//                        //                         [coverImage addSubview:label];
//                        
//                        NSArray *fileInfo = [text componentsSeparatedByString:@"."];
//                        NSString *fileExt = fileInfo[[fileInfo count]-1];
//                        if([fileExt hasPrefix:@"doc"]){
//                            coverImage.image = [UIImage imageNamed:@"fileic_doc.png"];
//                        }
//                        else if([fileExt hasPrefix:@"ppt"]){
//                            coverImage.image = [UIImage imageNamed:@"fileic_ppt.png"];
//                        }
//                        else if([fileExt hasPrefix:@"xls"]){
//                            coverImage.image = [UIImage imageNamed:@"fileic_xls.png"];
//                        }
//                        else if([fileExt hasPrefix:@"pdf"]){
//                            coverImage.image = [UIImage imageNamed:@"fileic_pdf.png"];
//                        }
//                        else if([fileExt hasPrefix:@"hwp"]){
//                            coverImage.image = [UIImage imageNamed:@"fileic_hwp.png"];
//                        }
//                        else{
//                            coverImage.image = [UIImage imageNamed:@"etc.png"];
//                            
//                        }
//                        
//                        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(coverImage.frame.origin.x + coverImage.frame.size.width + 10,
//                                                                                       coverImage.frame.origin.y,
//                                                                                       210, coverImage.frame.size.height)];
//                        [titleLabel setNumberOfLines:2];
//                        [titleLabel setTextAlignment:NSTextAlignmentLeft];
//                        [titleLabel setFont:[UIFont systemFontOfSize:14]];
//                        [titleLabel setBackgroundColor:[UIColor clearColor]];
//                        [titleLabel setTextColor:RGB(54, 157, 215)];
//                        [bgView addSubview:titleLabel];
//                        titleLabel.text = text;
//                        //                        [titleLabel release];
//                        
//                        
//                        UIButton *viewFileButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,bgView.frame.size.width,bgView.frame.size.height)];
//                        //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
//                        if([fileExt hasPrefix:@"hwp"]){
//                            [viewFileButton addTarget:self action:@selector(viewHWPFile:) forControlEvents:UIControlEventTouchUpInside];
//                        }
//                        else
//                            [viewFileButton addTarget:self action:@selector(viewFile:) forControlEvents:UIControlEventTouchUpInside];
//                        viewFileButton.tag = i;
//                        [bgView addSubview:viewFileButton];
//                        //                        [viewFileButton release];
//                        
//                        [fileView addSubview:bgView];
//                        //                        [bgView release];
//                        
//                        if(i != [fileArray count]-1){
//                            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(12,bgView.frame.origin.y + bgView.frame.size.height,277,1)];
//                            line.image = [UIImage imageNamed:@"gryline3px.png"];
//                            [fileView addSubview:line];
//                            //                            [line release];
//                        }
//                        
//                    }
//                    
                    
                    
                    fileView.frame = CGRectMake(16, CGRectGetMaxY(pollView.frame)+10, self.view.frame.size.width - 32, 47*[fileArray count]+8*([fileArray count]-1));

                    
#else
                    
                    for(int i = 0; i < [fileArray count]; i++){

                        
                        UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0 + 65*i,fileView.frame.size.width,64)];
                        bgView.userInteractionEnabled = YES;
                        NSDictionary *fileDic = fileArray[i];
                        
                        NSString *text = @"";
                        text = [NSString stringWithFormat:@"%@",fileDic[@"filename"]];
                        
                        UIImageView *coverImage = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, 10, 41, 44)];
                        coverImage.frame = CGRectMake(10,10,41,44);
                        //                        coverImage.image = [UIImage imageNamed:@"vote_listbtn.png"];
                        //                        coverImage.backgroundColor = [UIColor grayColor];
                        [bgView addSubview:coverImage];
//                        [coverImage release];
                        
                        //                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, coverImage.frame.size.width, coverImage.frame.size.height)];
                        //                        [label setTextAlignment:NSTextAlignmentCenter];
                        //                        [label setFont:[UIFont systemFontOfSize:15]];
                        //                        [label setNumberOfLines:1];
                        //                        [label setBackgroundColor:[UIColor clearColor]];
                        //                        [label setTextColor:[UIColor whiteColor]];
                        //                         [coverImage addSubview:label];
                        
                        NSArray *fileInfo = [text componentsSeparatedByString:@"."];
                        NSString *fileExt = fileInfo[[fileInfo count]-1];
                        if([fileExt hasPrefix:@"doc"]){
                            coverImage.image = [UIImage imageNamed:@"fileic_doc.png"];
                        }
                        else if([fileExt hasPrefix:@"ppt"]){
                            coverImage.image = [UIImage imageNamed:@"fileic_ppt.png"];
                        }
                        else if([fileExt hasPrefix:@"xls"]){
                            coverImage.image = [UIImage imageNamed:@"fileic_xls.png"];
                        }
                        else if([fileExt hasPrefix:@"pdf"]){
                            coverImage.image = [UIImage imageNamed:@"fileic_pdf.png"];
                        }
                        else if([fileExt hasPrefix:@"hwp"]){
                            coverImage.image = [UIImage imageNamed:@"fileic_hwp.png"];
                        }
                        else{
                            coverImage.image = [UIImage imageNamed:@"etc.png"];
                            
                        }
                        
                        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(coverImage.frame.origin.x + coverImage.frame.size.width + 10,
                                                                                       coverImage.frame.origin.y,
                                                                                       210, coverImage.frame.size.height)];
                        [titleLabel setNumberOfLines:2];
                        [titleLabel setTextAlignment:NSTextAlignmentLeft];
                        [titleLabel setFont:[UIFont systemFontOfSize:14]];
                        [titleLabel setBackgroundColor:[UIColor clearColor]];
                        [titleLabel setTextColor:RGB(54, 157, 215)];
                        [bgView addSubview:titleLabel];
                        titleLabel.text = text;
//                        [titleLabel release];
                        
                        
                        UIButton *viewFileButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,bgView.frame.size.width,bgView.frame.size.height)];
                        //                        [viewImageButton setBackgroundImage:[UIImage imageNamed:@"datview_bg.png"] forState:UIControlStateNormal];
                        if([fileExt hasPrefix:@"hwp"]){
                            [viewFileButton addTarget:self action:@selector(viewHWPFile:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        else
                            [viewFileButton addTarget:self action:@selector(viewFile:) forControlEvents:UIControlEventTouchUpInside];
                        viewFileButton.tag = i;
                        [bgView addSubview:viewFileButton];
//                        [viewFileButton release];
                        
                        [fileView addSubview:bgView];
//                        [bgView release];
                        
                        if(i != [fileArray count]-1){
                            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(12,bgView.frame.origin.y + bgView.frame.size.height,277,1)];
                            line.image = [UIImage imageNamed:@"gryline3px.png"];
                            [fileView addSubview:line];
//                            [line release];
                        }
                        
                    }
                    
                    
                    
                    fileView.frame = CGRectMake(16, CGRectGetMaxY(pollView.frame)+5, self.view.frame.size.width - 32, 65*[fileArray count]);
                    
#endif
                    
                }
                else{
                    
                    fileView.frame = CGRectMake(16, CGRectGetMaxY(pollView.frame), self.view.frame.size.width - 32, 0);
                }
                
                
                contentsView.frame = CGRectMake(0, CGRectGetMaxY(defaultView.frame), self.view.frame.size.width, CGRectGetMaxY(fileView.frame));
                
            }
            
            
            
            
            
            if([contentsData.contentType isEqualToString:@"7"]){
                
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                UIImageView *profileOuterView;
                profileOuterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"imageview_profile_rounding_1.png"]];
                profileOuterView.frame = CGRectMake(0, 0, profileImageView.frame.size.width, profileImageView.frame.size.height);
                [profileImageView addSubview:profileOuterView];
//                [profileOuterView release];
#endif
                NSDictionary *yourDic = [SharedAppDelegate.root searchContactDictionary:contentsData.profileImage];
                if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    
                    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
                    image.image = [UIImage imageNamed:@"balon_grayline_deep.png"];
                    [optionView addSubview:image];
//                    [image release];
                    
                    UILabel *toLabel = [[UILabel alloc]init];
                    toLabel.frame = CGRectMake(10, 10, 300-100, 20);
                    [toLabel setTextColor:[UIColor darkGrayColor]];
                    [toLabel setFont:[UIFont systemFontOfSize:14]];
                    [toLabel setBackgroundColor:[UIColor clearColor]];
                    [toLabel setText:[NSString stringWithFormat:@"받는사람(%d/%d)",(int)[readArray count]-1,(int)[replyArray count]]];
                    [optionView addSubview:toLabel];
//                    [toLabel release];
                    
                    
                    //                    UIButton *resendButton = [[UIButton alloc]initWithFrame:CGRectMake(320-10-119,4, 119, 41)];
                    //                    [resendButton setBackgroundImage:[UIImage imageNamed:@"button_note_resend.png"] forState:UIControlStateNormal];
                    //                    [resendButton addTarget:self action:@selector(reSend) forControlEvents:UIControlEventTouchUpInside];
                    //                    [optionView addSubview:resendButton];
                    //                    [resendButton release];
#ifdef MQM
#else
                    UIButton *resendButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(reSend) frame:CGRectMake(320-93, 0, 93, 38) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
                    [optionView addSubview:resendButton];
                    

                    UILabel *label = [CustomUIKit labelWithText:@"다시보내기" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(10, 7, resendButton.frame.size.width-15, resendButton.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
                    label.backgroundColor = [UIColor grayColor];
                    label.layer.cornerRadius = 3.0; // rounding label
                    label.clipsToBounds = YES;
                    [resendButton addSubview:label];
#endif
//                    [resendButton release];
                    
                    
                    
//                    [image release];
                    
                    
                    optionView.backgroundColor = RGB(246, 246, 246);
                    optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame)+5, 320, 40); // heightFor에선 45 지만 밑에 5까지 차지해서 백그라운드에 색 넣기.
                    
                }
                else if([yourDic[@"newfield3"]isEqualToString:@"40"]){
                    
                    optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame), 320, 0);
                }
                else{
                    //                    UIButton *replyButton = [[UIButton alloc]initWithFrame:CGRectMake(120, 10, 97, 41)];
                    //                    [replyButton setBackgroundImage:[UIImage imageNamed:@"button_note_reply.png"] forState:UIControlStateNormal];
                    //                    [replyButton addTarget:self action:@selector(cmdReplyNote) forControlEvents:UIControlEventTouchUpInside];
                    //                    [optionView addSubview:replyButton];
                    //                    [replyButton release];
                    
#ifdef MQM
                    optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame), 320, 0);
#else
                    
                    UIButton *replyButton = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(cmdReplyNote) frame:CGRectMake(115, 0, 93, 38) imageNamedBullet:nil imageNamedNormal:nil imageNamedPressed:nil];
                    [optionView addSubview:replyButton];
                    
                    UILabel *label = [CustomUIKit labelWithText:@"답장하기" fontSize:14 fontColor:[UIColor whiteColor] frame:CGRectMake(10, 7, replyButton.frame.size.width-15, replyButton.frame.size.height - 10) numberOfLines:1 alignText:NSTextAlignmentCenter];
                    label.backgroundColor = [UIColor grayColor];
                    label.layer.cornerRadius = 3.0; // rounding label
                    label.clipsToBounds = YES;
                    [replyButton addSubview:label];
//                    [replyButton release];
                    
                    optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame)+5, 320, 40);
                    
#endif
                    
                }
            }
            else{
                //                if(![contentsData.type isEqualToString:@"5"]){
                
#ifdef BearTalk
#else
                UIButton *shareButton;
                UILabel *likeLabel;
                UILabel *shareLabel;
                UIButton *likeIconButton, *replyIconButton, *likeButton2;
                UILabel *likeCountLabel2, *replyCountLabel;
                likeIconButton = [[UIButton alloc]init];
                [likeIconButton setBackgroundImage:[UIImage imageNamed:@"goodicon.png"] forState:UIControlStateNormal];
                [optionView addSubview:likeIconButton];
//                [likeIconButton release];
                
                likeCountLabel2 = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
                [likeCountLabel2 setTextAlignment:NSTextAlignmentLeft];
                [likeCountLabel2 setTextColor:[UIColor grayColor]];
                [likeCountLabel2 setFont:[UIFont systemFontOfSize:14.0]];
                [likeCountLabel2 setBackgroundColor:[UIColor clearColor]];
                [optionView addSubview:likeCountLabel2];
//                [likeCountLabel2 release];
                
                replyIconButton = [[UIButton alloc]init];
                [replyIconButton setBackgroundImage:[UIImage imageNamed:@"commentic.png"] forState:UIControlStateNormal];
                [optionView addSubview:replyIconButton];
//                [replyIconButton release];
                
                replyCountLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
                [replyCountLabel setTextAlignment:NSTextAlignmentLeft];
                [replyCountLabel setTextColor:[UIColor grayColor]];
                [replyCountLabel setFont:[UIFont systemFontOfSize:14.0]];
                [replyCountLabel setBackgroundColor:[UIColor clearColor]];
                [optionView addSubview:replyCountLabel];
//                [replyCountLabel release];
                
                
                likeLabel = [CustomUIKit labelWithText:@"좋아요" fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
                likeLabel.backgroundColor = [UIColor whiteColor];
                likeLabel.layer.borderWidth = 0.5;
                likeLabel.layer.borderColor = [UIColor grayColor].CGColor;
                likeLabel.layer.cornerRadius = 3.0; // rounding label
                likeLabel.clipsToBounds = YES;
                likeLabel.userInteractionEnabled = YES;
                [optionView addSubview:likeLabel];
        
                
                likeButton2 = [[UIButton alloc]init];
                [likeButton2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                
                for(NSDictionary *dic in likeArray){
                    if([dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID]) {
//                        [likeButton2 setBackgroundImage:[UIImage imageNamed:@"button_timeline_like_selected.png"] forState:UIControlStateNormal];
                        
                        likeLabel.textColor = [UIColor whiteColor];
                        likeLabel.backgroundColor = RGB(167, 204, 69);
#ifdef LempMobile
                        likeLabel.backgroundColor = RGB(39, 128, 248);
                        
#endif
                        
                    }
                }
                
                [likeLabel addSubview:likeButton2];
                [likeButton2 addTarget:self action:@selector(sendLike:) forControlEvents:UIControlEventTouchUpInside];
//                [likeButton2 release];
                
                shareLabel = [CustomUIKit labelWithText:@"공유" fontSize:10 fontColor:[UIColor grayColor] frame:CGRectMake(0,0,0,0) numberOfLines:1 alignText:NSTextAlignmentCenter];
                shareLabel.backgroundColor = [UIColor whiteColor];
                shareLabel.layer.borderWidth = 0.5;
                shareLabel.layer.borderColor = [UIColor grayColor].CGColor;
                shareLabel.layer.cornerRadius = 3.0; // rounding label
                shareLabel.clipsToBounds = YES;
                shareLabel.userInteractionEnabled = YES;
                [optionView addSubview:shareLabel];
                
                shareButton = [[UIButton alloc]init];
                [shareButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [shareLabel addSubview:shareButton];
//                [shareButton addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
//                [shareButton release];
                shareLabel.frame = CGRectMake(320,7,0,0);

                
                if ([likeArray count] > 0) {
                    likeIconButton.frame = CGRectMake(10,15,17,14);
                    likeCountLabel2.frame = CGRectMake(CGRectGetMaxX(likeIconButton.frame)+5,7,35,30);
                    [likeCountLabel2 setText:[NSString stringWithFormat:@"%d",(int)[likeArray count]]];
                    
                    
                } else {
                    
                    likeIconButton.frame = CGRectMake(10,15,0,14);
                    likeCountLabel2.frame = CGRectMake(CGRectGetMaxX(likeIconButton.frame),7,0,30);
                    [likeCountLabel2 setText:@""];
                    
                }
                if([replyArray count]>0){
                    
                    replyIconButton.frame = CGRectMake(CGRectGetMaxX(likeCountLabel2.frame),15,17,14);
                    replyCountLabel.frame = CGRectMake(CGRectGetMaxX(replyIconButton.frame)+5,7,35,30);
                    [replyCountLabel setText:[NSString stringWithFormat:@"%d",(int)[replyArray count]]];
                    
                }
                
                if(!([contentsData.contentType isEqualToString:@"9"] && [[contentsData.targetdic objectFromJSONString][@"category"]isEqualToString:@"3"])){
                    likeLabel.frame = CGRectMake(320-10-40, 7, 40, 24);
                    optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame)+5, 320, 45);
                }
                else{
                    if([replyArray count]==0){
                        
                        optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame), 320, 0);
                    }
                    else{
                        
                        optionView.frame = CGRectMake(0, CGRectGetMaxY(contentsView.frame)+5, 320, 45);
                    }
                }

                
                
#ifdef MQM
                
                
                NSString *attribute2 = SharedAppDelegate.root.home.groupDic[@"groupattribute2"];
                
                
                if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID] && [attribute2 isEqualToString:@"00"]){
                shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-50, likeLabel.frame.origin.y, 50, 24);
                shareLabel.text = @"읽음확인"; // 리더 & 유저레벨 80만 가능하도록 변경해야
                [shareButton addTarget:self action:@selector(showRead) forControlEvents:UIControlEventTouchUpInside];
                }
                else if(![attribute2 isEqualToString:@"00"] && [[SharedAppDelegate readPlist:@"myinfo"][@"userlevel"]intValue] > 70){
                    
                    shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-50, likeLabel.frame.origin.y, 50, 24);
                    shareLabel.text = @"읽음확인"; // 리더 & 유저레벨 80만 가능하도록 변경해야
                    [shareButton addTarget:self action:@selector(showRead) forControlEvents:UIControlEventTouchUpInside];
                }

#elif Batong
                NSLog(@"c %@ w %@ s %@",contentsData.contentType,contentsData.writeinfoType,contentsData.sub_category);
                if([contentsData.contentType isEqualToString:@"1"] && [contentsData.writeinfoType isEqualToString:@"1"] && ![contentsData.sub_category isKindOfClass:[NSNull class]] && [contentsData.sub_category length]>1){
                    
                    
                    NSString *share = contentsData.contentDic[@"share"];
                    
                    if([share isEqualToString:@"2"]){
                        // x
                        shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 0, 0);
                    }
                    else if([share isEqualToString:@"1"]){
                        // best
                        
                        UIButton *button;
                        UIBarButtonItem *btnNavi;
                        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 26, 26)
                                             imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
                        
                        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                        self.navigationItem.rightBarButtonItem = btnNavi;
//                        [btnNavi release];
//                        [button release];
                        
                        shareLabel.text = @"BP선정";
                        shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, likeLabel.frame.origin.y, 40, 24);
                        shareLabel.backgroundColor = RGB(46, 107, 165);//[UIColor whiteColor];
                        shareLabel.textColor = [UIColor yellowColor];
                        
                        if([[SharedAppDelegate readPlist:@"isCS"]isEqualToString:@"1"])// i am cs
                        {
                            
                            [shareButton addTarget:self action:@selector(goShareAgain) forControlEvents:UIControlEventTouchUpInside];
                            
                        }
                        else{
                            [shareButton addTarget:SharedAppDelegate.root.home action:@selector(alreadyShareToast) forControlEvents:UIControlEventTouchUpInside];
                            
                        }
                    }
                    else {
                        if([[SharedAppDelegate readPlist:@"isCS"]isEqualToString:@"1"]){ // i am cs
                            
                            
                            UIButton *button;
                            UIBarButtonItem *btnNavi;
                            button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 26, 26)
                                                 imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
                            
                            btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                            self.navigationItem.rightBarButtonItem = btnNavi;
//                            [btnNavi release];
//                            [button release];
                            
                            shareLabel.text = @"공유";
                            shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, likeLabel.frame.origin.y, 40, 24);
                            shareLabel.backgroundColor = [UIColor whiteColor];//[UIColor whiteColor];
                            shareLabel.textColor = [UIColor grayColor];
                            [shareButton addTarget:self action:@selector(goShare) forControlEvents:UIControlEventTouchUpInside];
                        }
                        else{
                            
                            shareLabel.frame = CGRectMake(likeLabel.frame.origin.x-5-40, 0, 0, 0);
                            
                        }
                    }
                    
                    
                }
                
#endif
  
     
                
                
                if([contentsData.type isEqualToString:@"5"] || [contentsData.type isEqualToString:@"6"])
                {
                    likeLabel.hidden = YES;
                    likeCountLabel2.hidden = YES;
                    replyCountLabel.hidden  = YES;
                    replyIconButton.hidden = YES;
                }
                else if([contentsData.type isEqualToString:@"7"]){
                    
                    replyCountLabel.hidden = YES;
                    replyIconButton.hidden = YES;
                }
            
                likeButton2.frame = CGRectMake(0,0,likeLabel.frame.size.width,likeLabel.frame.size.height);
                shareButton.frame = CGRectMake(0,0,shareLabel.frame.size.width,shareLabel.frame.size.height);
                
#endif
            }
        }
        
        
    }
    else{
        NSLog(@"indexpath row != 0");
        if([contentsData.contentType isEqualToString:@"7"])
        {
            
            
            
            //        allReplyView = [[UIView alloc]init];
            
            
            cell.contentView.backgroundColor = RGB(246, 246, 246);//RGB(246,246,246);
            NSLog(@"replyArray count %d",(int)[replyArray count]);
            if([replyArray count]>0)
            {
                if(indexPath.row-1 == 0){
//                    UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"balon_grayline.png"]];
//                    bound.frame = CGRectMake(0,0,320,1);
//                    [cell.contentView addSubview:bound];
//                    [bound release];
                }
                
                NSDictionary *dic = [replyArray[indexPath.row-1]objectFromJSONString];
                NSLog(@"dic %@",dic);
                
                NSDictionary *infoDic = [SQLiteDBManager searchContactDictionaryLight:dic[@"uid"]];//[[dicobjectForKey:@"writeinfo"]objectFromJSONString];
                NSLog(@"infoDic %@",infoDic);
                UIImageView *replyProfileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
                //            [replyProfileImageView setImage:[SharedAppDelegate.root getImage:[dicobjectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"]];
                replyProfileImageView.userInteractionEnabled = YES;
                [SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"profile_photo.png" view:replyProfileImageView scale:24];
                [cell.contentView addSubview:replyProfileImageView];
//                [replyProfileImageView release];
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                
                UIImageView *roundingView;
                roundingView = [[UIImageView alloc]init];
                roundingView.frame = CGRectMake(0,0,replyProfileImageView.frame.size.width,replyProfileImageView.frame.size.height);
                roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1_gray_246.png"];
                [replyProfileImageView addSubview:roundingView];
//                [roundingView release];
#endif
                
                UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
                viewButton.adjustsImageWhenHighlighted = NO;
                [viewButton addTarget:self action:@selector(goToNoteReplyTimeline:) forControlEvents:UIControlEventTouchUpInside];
                viewButton.titleLabel.text = dic[@"uid"];
                //                viewButton.tag = [[dicobjectForKey:@"writeinfotype"]intValue];
                [replyProfileImageView addSubview:viewButton];
                
                
                UILabel *replyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 120, 16)];
                [replyNameLabel setBackgroundColor:[UIColor clearColor]];
                [replyNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
                [replyNameLabel setTextColor:RGB(87, 107, 149)];
                [replyNameLabel setText:dic[@"name"]];
                [cell.contentView addSubview:replyNameLabel];
//                [replyNameLabel release];
                
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                replyNameLabel.textColor = GreenTalkColor;
#endif
                
                UILabel *positionLabel;
                
                CGSize size = [replyNameLabel.text sizeWithAttributes:@{NSFontAttributeName:replyNameLabel.font}];
                positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(replyNameLabel.frame.origin.x + (size.width+5>120?120:size.width+5), replyNameLabel.frame.origin.y, 120, 16)];
                [positionLabel setBackgroundColor:[UIColor clearColor]];
                [positionLabel setTextColor:[UIColor grayColor]];
                [positionLabel setFont:[UIFont systemFontOfSize:14]];
                [positionLabel setText:[NSString stringWithFormat:@"%@ %@",infoDic[@"grade2"],dic[@"team"]]];//?[infoDicobjectForKey:@"grade2"]:[infoDicobjectForKey:@"position"]];
#ifdef Batong
                
                [positionLabel setText:[NSString stringWithFormat:@"%@ %@",infoDic[@"team"],dic[@"grade2"]]];//?[infoDicobjectForKey:@"grade2"]:
#endif
                [cell.contentView addSubview:positionLabel];
//                [positionLabel release];
                
//                UILabel *teamLabel;
//                CGSize size2 = [positionLabel.text sizeWithFont:positionLabel.font];
//                teamLabel = [[UILabel alloc]initWithFrame:CGRectMake(positionLabel.frame.origin.x + (size2.width+5>80?80:size2.width+5), replyNameLabel.frame.origin.y, 110, 16)];
//                [teamLabel setBackgroundColor:[UIColor clearColor]];
//                [teamLabel setTextColor:[UIColor grayColor]];
//                [teamLabel setFont:[UIFont systemFontOfSize:14]];
//                [teamLabel setText:infoDic[@"team"]];
//                [cell.contentView addSubview:teamLabel];
//                [teamLabel release];
                
                UILabel *readCheckLabel;
                readCheckLabel = [[UILabel alloc]initWithFrame:CGRectMake(320-10-50,10,50,16)];
                [readCheckLabel setBackgroundColor:[UIColor clearColor]];
                [readCheckLabel setTextColor:[UIColor grayColor]];
                [readCheckLabel setFont:[UIFont systemFontOfSize:14]];
                [readCheckLabel setTextAlignment:NSTextAlignmentRight];
                [cell.contentView addSubview:readCheckLabel];
//                [readCheckLabel release];
                
                BOOL readCheck = NO;
                for(int i = 0; i < [readArray count]; i++){
                    NSDictionary *readdic = [readArray[i]objectFromJSONString];
                    if([readdic[@"uid"]isEqualToString:dic[@"uid"]]) {
                        readCheck = YES;
                        break;
                    }
                    
                }
                
                if(readCheck == YES)
                    readCheckLabel.text = @"(읽음)";
                else
                    readCheckLabel.text = @"(안읽음)";
                
//                UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"balon_grayline.png"]];
//                bound.frame = CGRectMake(0,39,320,1);
//                [cell.contentView addSubview:bound];
//                [bound release];
                
                
                
            }
            
            
        }
        
        
        else if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
            // like default
            NSLog(@"replyArray11 %@",replyArray);
            
            NSDictionary *replydic = replyArray[indexPath.row-1];
            NSLog(@"dic %@",replydic);
            UIView *defaultView = [[UIView alloc]init];
            defaultView.frame = CGRectMake(0, 0, 320, 70);
            [cell.contentView addSubview:defaultView];
            defaultView.backgroundColor = [UIColor clearColor];
//            [defaultView release];
            
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 320-20, 1)];
            lineView.backgroundColor = GreenTalkColor;
            [defaultView addSubview:lineView];
//            [lineView release];
            
            UIView *contentsView = [[UIView alloc]init];
            contentsView.frame = CGRectMake(0, CGRectGetMaxY(defaultView.frame)+5, 320, 0);
            [cell.contentView addSubview:contentsView];
            contentsView.backgroundColor = [UIColor clearColor];
//            [contentsView release];
            
            UIImageView *profileImageView;
            profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
            profileImageView.userInteractionEnabled = YES;
            [defaultView addSubview:profileImageView];
//            [profileImageView release];
            
#if defined(GreenTalk) || defined(GreenTalkCustomer)
            UIImageView *roundingView;
            roundingView = [[UIImageView alloc]init];
            roundingView.frame = CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height);
            roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1.png"];
            [profileImageView addSubview:roundingView];
//            [roundingView release];
#endif
            UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,profileImageView.frame.size.width,profileImageView.frame.size.height)];
            viewButton.adjustsImageWhenHighlighted = NO;
            [viewButton addTarget:self action:@selector(goToYourTimeline:) forControlEvents:UIControlEventTouchUpInside];
            viewButton.titleLabel.text = replydic[@"uid"];
            [profileImageView addSubview:viewButton];
//            [viewButton release];
            
            
            UILabel *nameLabel;
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(profileImageView.frame.origin.x + profileImageView.frame.size.width + 5, 12, 80, 16)];
            [nameLabel setTextAlignment:NSTextAlignmentLeft];
            //		[nameLabel setTextColor:[UIColor blackColor]];
            [nameLabel setFont:[UIFont boldSystemFontOfSize:14]];
            //		[nameLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            [nameLabel setBackgroundColor:[UIColor clearColor]];
            [defaultView addSubview:nameLabel];
//            [nameLabel release];
            
            //
            UILabel *positionLabel;
            positionLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(nameLabel.frame.origin.x + [nameLabel.text length] * 14, nameLabel.frame.origin.y, 80, 16)];
            [positionLabel setBackgroundColor:[UIColor clearColor]];
            [positionLabel setTextColor:[UIColor grayColor]];
            [positionLabel setFont:[UIFont systemFontOfSize:14]];
            [defaultView addSubview:positionLabel];
//            [positionLabel release];
            
//            UILabel *teamLabel;
//            teamLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(positionLabel.frame.origin.x + [positionLabel.text length] * 14, positionLabel.frame.origin.y, 80, 16)];
//            [teamLabel setBackgroundColor:[UIColor clearColor]];
//            [teamLabel setTextColor:[UIColor grayColor]];
//            [teamLabel setFont:[UIFont systemFontOfSize:14]];
//            [defaultView addSubview:teamLabel];
//            [teamLabel release];
            
            NSLog(@"replyDic %@",replydic);
            NSDictionary *replyPersonDic = [replydic[@"writeinfo"]objectFromJSONString];
            NSLog(@"replyPersonDic %@",replyPersonDic);
            NSLog(@"nameLabel %@",nameLabel);
            if([replydic[@"writeinfotype"] isEqualToString:@"2"]){
                [nameLabel setTextColor:RGB(160, 18, 19)];
                [nameLabel setText:replyPersonDic[@"deptname"]];
                //        [SharedAppDelegate.root getThumbImageWithURL:[replyPersonDicobjectForKey:@"image"] ifNil:@"list_profile_company.png" view:profileImageView scale:7];
                NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:replyPersonDic[@"image"] num:0 thumbnail:YES];
                if (imgURL) {
                    [profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL
                                                            andPlaceholderImage:[UIImage imageNamed:@"list_profile_company.png"]
                                                                        options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                                       progress:^(NSInteger a, NSInteger b)  {
                                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                                           NSLog(@"fail %@",[error localizedDescription]);
                                                                           if (image != nil) {
                                                                               [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                                                                   [profileImageView setImage:roundedImage];
                                                                               }];
                                                                           }
                                                                           
                                                                           [HTTPExceptionHandler handlingByError:error];
                                                                           
                                                                       }];
                } else {
                    profileImageView.image = [UIImage imageNamed:@"list_profile_company.png"];
                }
                //        [profileImageView setImage:[SharedAppDelegate.root roundCornersOfImage:profileImageView.image scale:24]];
                
            }
            else if([replydic[@"writeinfotype"] isEqualToString:@"3"]){
                
                [nameLabel setTextColor:RGB(160, 18, 19)];
                [nameLabel setText:replyPersonDic[@"companyname"]];
                //        [SharedAppDelegate.root getThumbImageWithURL:[contentsData.personInfoobjectForKey:@"image"] ifNil:@"list_profile_company.png" view:profileImageView scale:7];
                NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:replyPersonDic[@"image"] num:0 thumbnail:YES];
                if (imgURL) {
                    [profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL
                                                            andPlaceholderImage:[UIImage imageNamed:@"list_profile_company.png"]
                                                                        options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                                       progress:^(NSInteger a, NSInteger b)  {
                                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                                           NSLog(@"fail %@",[error localizedDescription]);
                                                                           if (image != nil) {
                                                                               [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                                                                   [profileImageView setImage:roundedImage];
                                                                               }];
                                                                           }
                                                                           
                                                                           [HTTPExceptionHandler handlingByError:error];
                                                                           
                                                                       }];
                } else {
                    profileImageView.image = [UIImage imageNamed:@"list_profile_company.png"];
                }
                
                //        [profileImageView setImage:[SharedAppDelegate.root roundCornersOfImage:profileImageView.image scale:24]];
            }
            else if([replydic[@"writeinfotype"] isEqualToString:@"4"]){
                
                //        subImageView.image = [UIImage imageNamed:@"n01_tl_realic_lemp.png"];
                [nameLabel setText:replyPersonDic[@"text"]];
                nameLabel.textColor = RGB(160, 18, 19);
                //        [SharedAppDelegate.root getThumbImageWithURL:[contentsData.personInfoobjectForKey:@"image"] ifNil:@"list_profile_systeam.png" view:profileImageView scale:7];
                NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:replyPersonDic[@"image"] num:0 thumbnail:YES];
                if (imgURL) {
                    [profileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL
                                                            andPlaceholderImage:[UIImage imageNamed:@"list_profile_systeam.png"]
                                                                        options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                                       progress:^(NSInteger a, NSInteger b) {
                                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                                                                           NSLog(@"fail %@",[error localizedDescription]);
                                                                           if (image != nil) {
                                                                               [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                                                                   [profileImageView setImage:roundedImage];
                                                                               }];
                                                                           }
                                                                           
                                                                           [HTTPExceptionHandler handlingByError:error];
                                                                           
                                                                       }];
                } else {
                    profileImageView.image = [UIImage imageNamed:@"list_profile_systeam.png"];
                }
                
            }
            else if([replydic[@"writeinfotype"] isEqualToString:@"1"]){
                [nameLabel setTextColor:RGB(87, 107, 149)];
                
                [nameLabel setText:replyPersonDic[@"name"]];
                CGSize size = [nameLabel.text sizeWithAttributes:@{NSFontAttributeName:nameLabel.font}];
                positionLabel.frame = CGRectMake(nameLabel.frame.origin.x + (size.width+5>80?80:size.width+5), nameLabel.frame.origin.y, 170, 16);
                positionLabel.text = [NSString stringWithFormat:@"%@ %@",contentsData.personInfo[@"position"],contentsData.personInfo[@"deptname"]];
#ifdef Batong
                if([contentsData.personInfo[@"position"]length]>0)
                    positionLabel.text = [NSString stringWithFormat:@"%@ | %@",contentsData.personInfo[@"deptname"],contentsData.personInfo[@"position"]];
                else
                    positionLabel.text = [NSString stringWithFormat:@"%@",contentsData.personInfo[@"deptname"]];
#endif
                
                [SharedAppDelegate.root getProfileImageWithURL:replydic[@"uid"] ifNil:@"profile_photo.png" view:profileImageView scale:24];
                
            }
            else if([replydic[@"writeinfotype"] isEqualToString:@"10"]){
                [nameLabel setTextColor:RGB(87, 107, 149)];
                
                [nameLabel setText:@"익명"];
                [positionLabel setText:@""];
//                [teamLabel setText:@""];
                
                [profileImageView setImage:[UIImage imageNamed:@"sns_anonym.png"]];
                
                
            }
#if defined(GreenTalk) || defined(GreenTalkCustomer)
            [nameLabel setTextColor:GreenTalkColor];
#endif
            
            NSLog(@"nameLabel text %@",nameLabel.text);
            
            timeLabel = [[UILabel alloc] init];//WithFrame:CGRectMake(whLabel.frame.origin.x, contentImageView.frame.origin.y + contentImageView.frame.size.height + 6, whLabel.frame.size.width, 13)];//(3, 42, 38, 13)];
            timeLabel.frame = CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame), 300 - nameLabel.frame.origin.x - 40, 20);
            [timeLabel setText:[NSString formattingDate:replydic[@"writetime"] withFormat:@"yy/MM/dd a h:mm"]];//dateString];
            [timeLabel setTextColor:[UIColor grayColor]];
            [timeLabel setFont:[UIFont systemFontOfSize:12]];
            [timeLabel setBackgroundColor:[UIColor clearColor]];
            [defaultView addSubview:timeLabel];
//            [timeLabel release];
            
            
            UITextView *contentsTextView;
            contentsTextView = [[UITextView alloc] init];//WithFrame:CGRectMake(5, 0, 295, contentSize.height + 25)];
            
            
            [contentsTextView setTextAlignment:NSTextAlignmentLeft];
            contentsTextView.contentInset = UIEdgeInsetsMake(0,0,0,0);
            [contentsTextView setDataDetectorTypes:UIDataDetectorTypeLink];
            [contentsTextView setFont:[UIFont systemFontOfSize:fontSize]];
            [contentsTextView setBackgroundColor:[UIColor clearColor]];
            [contentsTextView setEditable:NO];
            [contentsTextView setDelegate:self];
            
            contentsTextView.scrollsToTop = NO;
            [contentsTextView setScrollEnabled:NO];
            [contentsTextView sizeToFit];
            [contentsView addSubview:contentsTextView];
//            [contentsTextView release];
            
            
            contentImageView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, contentsTextView.frame.size.height + whLabel.frame.size.height + 5, 290, 0)];
            [contentsView addSubview:contentImageView];
//            [contentImageView release];
            
            
            
            
            NSDictionary *replyContentDic = [replydic[@"replymsg"]objectFromJSONString];
            NSString *content = replyContentDic[@"msg"];
            NSString *imageString = replyContentDic[@"image"];
            
            
            [contentsTextView setText:content];
            
            CGSize cSize = [SharedFunctions textViewSizeForString:content font:[UIFont systemFontOfSize:fontSize] width:300 realZeroInsets:NO];
            
            contentsTextView.frame = CGRectMake(10, 0, 300, cSize.height + 5);
            
            
            if(modifyImageArray){
//                [modifyImageArray release];
                modifyImageArray = nil;
            }
            modifyImageArray = [[NSMutableArray alloc]init];
            
            
            if(imageString != nil && [imageString length]>0)
            {
                contentImageView.userInteractionEnabled = YES;
                //        contentImageView.hidden = NO;
                NSLog(@"imageString %@",imageString);
                
                NSArray *imageArray;
                #ifdef BearTalk
                imageArray = [imageString objectFromJSONString][@"filename"];
#else
                
                imageArray = [imageString objectFromJSONString][@"thumbnail"];
#endif
                CGFloat imageHeight = 0.0f;
                for(int i = 0; i < [imageArray count]; i++){// imageScale * [sizeDic[@"height"]floatValue]);
                    NSDictionary *sizeDic;
                    if([[imageString objectFromJSONString][@"thumbnailinfoarray"]count]>0)
                        sizeDic = [imageString objectFromJSONString][@"thumbnailinfoarray"][i];
                    else
                        sizeDic = [imageString objectFromJSONString][@"thumbnailinfo"];
                    NSLog(@"sizeDic %@",sizeDic);
                    CGFloat imageScale = 0.0f;
                    imageScale = 300/[sizeDic[@"width"]floatValue];
                    UIImageView *inImageView = [[UIImageView alloc]init];
                    inImageView.frame = CGRectMake(0,imageHeight,300,imageScale * [sizeDic[@"height"]floatValue]);
                    imageHeight += inImageView.frame.size.height + 10;
                    NSLog(@"inimageview frame %@",NSStringFromCGRect(inImageView.frame));
                    inImageView.backgroundColor = [UIColor blackColor];
                    [inImageView setContentMode:UIViewContentModeScaleAspectFill];//AspectFill];//AspectFit];//ToFill];
                    [inImageView setClipsToBounds:YES];
                    NSURL *imgURL;
#ifdef BearTalk
                    
                    imgURL = [ResourceLoader resourceURLfromJSONString:imageString num:i thumbnail:NO];
                    NSData *imageData = [NSData dataWithContentsOfURL:imgURL];
                    UIImage *image = [UIImage imageWithData:imageData];
                    [modifyImageArray addObject:@{@"data" : imageData, @"image" : image}];
                    inImageView.image = [UIImage sd_animatedGIFWithData:imageData];
                    NSLog(@"imgURL %@ imageData length %d",imgURL,[imageData length]);
#else
                    imgURL = [ResourceLoader resourceURLfromJSONString:imageString num:i thumbnail:YES];

                    [inImageView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b)  {
                        
                    }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                        NSLog(@"fail %@",[error localizedDescription]);
                        

                        
                        NSData *imageData = UIImagePNGRepresentation(image);
                        [modifyImageArray addObject:@{@"data" : imageData, @"image" : image}];

                        
                        [HTTPExceptionHandler handlingByError:error];
                        
                    }];
                   #endif
                    [contentImageView addSubview:inImageView];
                    inImageView.userInteractionEnabled = YES;
                    
                    UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,inImageView.frame.size.width,inImageView.frame.size.height)];
                    viewButton.adjustsImageWhenHighlighted = NO;
                    [viewButton addTarget:self action:@selector(viewReplyImage:) forControlEvents:UIControlEventTouchUpInside];
                    viewButton.titleLabel.text = imageString;
                    [inImageView addSubview:viewButton];
//                    [viewButton release];
                    
                    
                    //                    contentImageView.backgroundColor = [UIColor blackColor];
                    //                        viewImageButton.backgroundColor = [UIColor redColor];
                    
                    
                }
                
                contentImageView.frame = CGRectMake(10, CGRectGetMaxY(contentsTextView.frame)+5, 300, imageHeight);
                
                
            }
            else{
                contentImageView.frame = CGRectMake(10, CGRectGetMaxY(contentsTextView.frame), 300, 0);
            }
            
            
            contentsView.frame = CGRectMake(0, CGRectGetMaxY(defaultView.frame)+5, 320, CGRectGetMaxY(contentImageView.frame));
            
            
            
            
            
            
            
            
            
            
            
            
        }
        else{
            
            int row = 0;
            int restcell = 0;
            
#ifdef GreenTalkCustomer
            
            restcell = 1;
            
//            if([contentsData.contentType isEqualToString:@"1"] && [contentsData.writeinfoType isEqualToString:@"0"]){
            
            
            NSDictionary *dic;
                
                dic = replyArray[indexPath.row-restcell];
                row = (int)indexPath.row-restcell;
                
                
                cell.contentView.backgroundColor = RGB(246, 246, 246);//RGB(246,246,246);
                
                
                if([replyArray count]>0){
                    NSLog(@"replyArray dic %@",dic);
                    //            {
                    //                UIImageView *replyImageView;
                    //                replyImageView = [[UIImageView alloc]init];
                    //                replyImageView.userInteractionEnabled = YES;
                    //            replyImageView.image = [[UIImage imageNamed:@"datwrithe_bg.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:22];
                    
                    NSDictionary *infoDic = [dic[@"writeinfo"]objectFromJSONString];
                    NSLog(@"infoDic %@",infoDic);
                    UIImageView *replyProfileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
                    //            [replyProfileImageView setImage:[SharedAppDelegate.root getImage:[dicobjectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"]];
                    replyProfileImageView.userInteractionEnabled = YES;
                    [cell.contentView addSubview:replyProfileImageView];
//                    [replyProfileImageView release];
                    
                    UIImageView *roundingView;
                    roundingView = [[UIImageView alloc]init];
                    roundingView.frame = CGRectMake(0,0,replyProfileImageView.frame.size.width,replyProfileImageView.frame.size.height);
                    roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1_gray_246.png"];
                    [replyProfileImageView addSubview:roundingView];
//                    [roundingView release];

                    UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
                    viewButton.adjustsImageWhenHighlighted = NO;
                    [viewButton addTarget:self action:@selector(goToReplyTimeline:) forControlEvents:UIControlEventTouchUpInside];
                    viewButton.titleLabel.text = dic[@"uid"];
                    viewButton.tag = [dic[@"writeinfotype"]intValue];
                    [replyProfileImageView addSubview:viewButton];
                    
                    
                    UILabel *replyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 80, 16)];
                    [replyNameLabel setBackgroundColor:[UIColor clearColor]];
                    [replyNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
                    [replyNameLabel setTextColor:RGB(87, 107, 149)];
                    replyNameLabel.userInteractionEnabled = YES;
                    [cell.contentView addSubview:replyNameLabel];
//                    [replyNameLabel release];
                    replyNameLabel.textColor = GreenTalkColor;
                    
                    
                    UIButton *tagNameButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,80, 20)];
                    tagNameButton.adjustsImageWhenHighlighted = NO;
                    if([dic[@"writeinfotype"]isEqualToString:@"1"] && ![dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID])
                        [tagNameButton addTarget:self action:@selector(tagName:) forControlEvents:UIControlEventTouchUpInside];
                    tagNameButton.titleLabel.text = dic[@"uid"];
                    [replyNameLabel addSubview:tagNameButton];
//                    [tagNameButton release];
                    
                    
                    UILabel *positionLabel;
                    positionLabel = [[UILabel alloc]init];
                    [positionLabel setBackgroundColor:[UIColor clearColor]];
                    [positionLabel setTextColor:[UIColor grayColor]];
                    [positionLabel setFont:[UIFont systemFontOfSize:14]];
                    [cell.contentView addSubview:positionLabel];
//                    [positionLabel release];
                    
//                    UILabel *teamLabel;
//                    teamLabel = [[UILabel alloc]init];
//                    [teamLabel setBackgroundColor:[UIColor clearColor]];
//                    [teamLabel setTextColor:[UIColor grayColor]];
//                    [teamLabel setFont:[UIFont systemFontOfSize:14]];
//                    [cell.contentView addSubview:teamLabel];
//                    [teamLabel release];
                    
                    [replyNameLabel setText:infoDic[@"name"]];
                    [positionLabel setText:[NSString stringWithFormat:@"%@ %@",infoDic[@"position"],infoDic[@"deptname"]]];
                    
#ifdef Batong
                    if([cinfoDic[@"position"]length]>0)
                        positionLabel.text = [NSString stringWithFormat:@"%@ | %@",infoDic[@"deptname"],infoDic[@"position"]];
                    else
                        positionLabel.text = [NSString stringWithFormat:@"%@",infoDic[@"deptname"]];
#endif
                    
//                    [teamLabel setText:infoDic[@"deptname"]];
                    
                    CGSize size = [replyNameLabel.text sizeWithAttributes:@{NSFontAttributeName:replyNameLabel.font}];
                    positionLabel.frame = CGRectMake(replyNameLabel.frame.origin.x + (size.width+5>80?80:size.width+5), replyNameLabel.frame.origin.y, 140, 16);
                    
//                    CGSize size2 = [positionLabel.text sizeWithFont:positionLabel.font];
//                    teamLabel.frame = CGRectMake(positionLabel.frame.origin.x + (size2.width+5>70?70:size2.width+5), replyNameLabel.frame.origin.y, 70, 16);
                    
                    UILabel *firstReplyLabel;
                    firstReplyLabel = [[UILabel alloc]init];
                    firstReplyLabel.frame = CGRectMake(320 - 5 - 60, positionLabel.frame.origin.y, 60, positionLabel.frame.size.height);
                    [firstReplyLabel setBackgroundColor:[UIColor clearColor]];
                    [firstReplyLabel setTextColor:[UIColor redColor]];
                    [firstReplyLabel setFont:[UIFont systemFontOfSize:14]];
                    firstReplyLabel.textAlignment = NSTextAlignmentRight;
                    firstReplyLabel.text = @"";
                    [cell.contentView addSubview:firstReplyLabel];
                    firstReplyLabel.hidden = YES;
//                    [firstReplyLabel release];
                    
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
                        if(row == 0)
                            firstReplyLabel.hidden = NO;
                        
                    }
                    else{
                        if(row+1 == [replyArray count])
                            firstReplyLabel.hidden = NO;
                        
                    }
                    UILabel *replyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, replyProfileImageView.frame.origin.y + replyProfileImageView.frame.size.height + 5, 40, 10)];
                    [replyTimeLabel setTextAlignment:NSTextAlignmentCenter];
                    [replyTimeLabel setTextColor:[UIColor darkGrayColor]];
                    [replyTimeLabel setFont:[UIFont systemFontOfSize:10]];
                    [replyTimeLabel setBackgroundColor:[UIColor clearColor]];
                    //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    //        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    //        NSDate *date = [formatter dateFromString:[dicobjectForKey:@"messagedate"]];
                    //        id AppID = [[UIApplication sharedApplication]delegate];
//                    NSString *dateString = [NSString calculateDate:dic[@"writetime"]];// with:currentTime];
                    [replyTimeLabel setText:@""];//dateString];
                    [cell.contentView addSubview:replyTimeLabel];
//                    [replyTimeLabel release];
                    
                    UILabel *replyDetailTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height+2.0, 220.0, 16.0)];
                    [replyDetailTimeLabel setTextColor:[UIColor grayColor]];
                    [replyDetailTimeLabel setBackgroundColor:[UIColor clearColor]];
                    [replyDetailTimeLabel setFont:[UIFont systemFontOfSize:14.0]];
                    
                    NSString *detailDateString = [NSString formattingDate:dic[@"writetime"] withFormat:@"yy/MM/dd a h:mm"];
                    [replyDetailTimeLabel setText:detailDateString];
                    [cell.contentView addSubview:replyDetailTimeLabel];
//                    [replyDetailTimeLabel release];
                    
                    
                    
                    emoticonView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, contentsTextView.frame.size.height + whLabel.frame.size.height + 5, 290, 0)];
                    [cell.contentView addSubview:emoticonView];
//                    [emoticonView release];
                    
                    emoticonView.contentMode = UIViewContentModeScaleAspectFit;

                    
                    NSString *replyCon = [dic[@"replymsg"]objectFromJSONString][@"msg"];
                    //            NSLog(@"replycont %@",replyCon);
                    
                    //                    replyCon = [NSString stringWithFormat:@"<span style=\"font-size: %i\">%@</span>",(int)fontSize,replyCon];
                    
                    //                    CGSize replySize = [replyCon sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(250, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
                    
                    UITextView *replyContentsTextView = [[UITextView alloc]init];//WithFrame:CGRectMake(45, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, replySize.width, replySize.height + 10)];
                 
                    
                    if([dic[@"writeinfotype"]isEqualToString:@"1"]){
                        for(NSDictionary *replyDic in replyArray){
                            
                            NSString *searchName = [NSString stringWithFormat:@"@%@",[replyDic[@"writeinfo"]objectFromJSONString][@"name"]];
                            //                            NSLog(@"searchName %@",searchName);
                            NSRange range = [replyCon rangeOfString:searchName];
                            if (range.length > 0){
                                NSLog(@"String contains");
                                
                                NSString *htmlString = @"";
#ifdef Batong
                                htmlString = [NSString stringWithFormat:@"<font color=\"#000000\"><b>%@</b></font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#else
                                htmlString = [NSString stringWithFormat:@"<font color=\"#a01213\">%@</font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#endif
                                //                            NSLog(@"replycon1 %@",replyCon);
                                //                            replyCon = [replyCon stringByReplacingCharactersInRange:range withString:htmlString];
                                replyCon = [replyCon stringByReplacingOccurrencesOfString:searchName withString:htmlString];
                                //                            NSLog(@"replycon2 %@",replyCon);
                            }
                        }
                    }
                    
                    //                        NSLog(@"\n contains");
                    //                        NSLog(@"replycon3 %@",replyCon);
                    replyCon = [replyCon stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
                    //                        NSLog(@"replycon4 %@",replyCon);
                    
//                    replyCon = [NSString stringWithFormat:@"<font size=%i>%@",(int)fontSize,replyCon];
                
                    

                    //                    UITextView *replyContentsTextView = [[UITextView alloc]init];//WithFrame:CGRectMake(45, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, replySize.width, replySize.height + 10)];
                    [replyContentsTextView setTextAlignment:NSTextAlignmentLeft];
                    replyContentsTextView.contentInset = UIEdgeInsetsMake(0,0,0,0);
                    [replyContentsTextView setBackgroundColor:[UIColor clearColor]];
                    [replyContentsTextView setDataDetectorTypes:UIDataDetectorTypeLink];
                    //                    [replyContentsTextView setBounces:NO];
                    [replyContentsTextView setScrollEnabled:NO];
                    
                    replyContentsTextView.scrollsToTop = NO;
                    [replyContentsTextView setEditable:NO];
                    //                    [replyContentsTextView sizeToFit];
                    //            [replyContentsLabel setAdjustsFontSizeToFitWidth:NO];
                    //                    [replyContentsTextView sizeToFit];
                    //            [replyContentsTextView setUserInteractionEnabled:YES];
                    //            [replyContentsLabel setNumberOfLines:0];
                    //            [replyContentsLabel setLineBreakMode:NSLineBreakByCharWrapping];
                    
//                    CGSize replySize;
                    CGRect replyrect;
             
                    
                        
                        						NSString *htmlString = [NSString stringWithFormat:@"<html>"
                        												"<head>"
                        												"<style type=\"text/css\">"
                        												"body {font-family: \"%@\"; font-size: %i; height: auto; }"
                        												"</style>"
                        												"</head>"
                        												"<body>%@</body>"
                        												"</html>", replyContentsTextView.font.fontName, (int)rfontSize, replyCon];
                        
                        NSData *htmlDATA = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
                        
                        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:htmlDATA options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
                        [replyContentsTextView setAttributedText:attrStr];
                        NSLog(@"**attrStr %@",attrStr);
                        
//                                                NSLog(@"**attrStr %@",attrStr);
                        
                                                replyrect = [attrStr boundingRectWithSize:CGSizeMake(240, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
//                                                NSLog(@"**replySizerect %@",NSStringFromCGRect(rect));
//                                                replySize = rect.size;//
//                        replySize = [SharedFunctions htmltextViewSizeForString:htmlString font:[UIFont systemFontOfSize:fontSize] width:250 realZeroInsets:NO fontSize:fontSize];
//                        NSLog(@"**replySize %@",NSStringFromCGSize(replySize));
//                        [attrStr release];
                        replyContentsTextView.frame = CGRectMake(45, replyDetailTimeLabel.frame.origin.y + replyDetailTimeLabel.frame.size.height, 250, ceilf(CGRectGetHeight(replyrect)) + 22);
                    

                    
                    
                    
                    emoticonView.frame = CGRectMake(replyDetailTimeLabel.frame.origin.x, CGRectGetMaxY(replyContentsTextView.frame)-12, 100, 0);
                    

                    
                    UIImageView *replyPhotoView = [[UIImageView alloc]initWithFrame:CGRectMake(0,replyContentsTextView.frame.size.height + replyContentsTextView.frame.origin.y, 100, 0)];
                    replyPhotoView.userInteractionEnabled = YES;
                    
                    NSString *replyPhotoUrl = [dic[@"replymsg"]objectFromJSONString][@"image"];
                    NSLog(@"replyPhotourl %@",replyPhotoUrl);
                    if([replyPhotoUrl length]>0){
                        
                        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:replyPhotoUrl num:0 thumbnail:YES];
                        
                        
#ifdef BearTalk
                        
                        imgURL = [ResourceLoader resourceURLfromJSONString:replyPhotoUrl num:0 thumbnail:NO];
                        NSData *imageData = [NSData dataWithContentsOfURL:imgURL];
                        NSLog(@"imgURL %@ imageData length %d",imgURL,[imageData length]);
                        replyPhotoView.image = [UIImage sd_animatedGIFWithData:imageData];
#else
                        [replyPhotoView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b) {
                            
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                            NSLog(@"fail %@",[error localizedDescription]);
                            [HTTPExceptionHandler handlingByError:error];
                            
                        }];
#endif
                        
                        NSDictionary *sizeDic = [replyPhotoUrl objectFromJSONString][@"thumbnailinfo"];
                        
                        CGFloat imageScale = 0.0f;
                        if([sizeDic[@"width"]floatValue]>120.0f){
                            imageScale = [sizeDic[@"width"]floatValue]/120.0f;
                            NSLog(@"imageScale %f",imageScale);
                            replyPhotoView.frame = CGRectMake(replyContentsTextView.frame.origin.x + 10,
                                                              replyContentsTextView.frame.size.height + replyContentsTextView.frame.origin.y,
                                                              120, [sizeDic[@"height"]floatValue]/imageScale);
                            NSLog(@"imageScale %f",[sizeDic[@"height"]floatValue]/imageScale);
                        }
                        else{
                            imageScale = 120.0f/[sizeDic[@"width"]floatValue];
                            replyPhotoView.frame = CGRectMake(replyContentsTextView.frame.origin.x + 10,
                                                              replyContentsTextView.frame.size.height + replyContentsTextView.frame.origin.y,
                                                              120, [sizeDic[@"height"]floatValue]*imageScale);
                            
                        }
                        NSLog(@"////////////////frame %@",NSStringFromCGRect(replyPhotoView.frame));
                        
                        
                        UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,replyPhotoView.frame.size.width,replyPhotoView.frame.size.height)];
                        viewButton.adjustsImageWhenHighlighted = NO;
                        [viewButton addTarget:self action:@selector(viewReplyImage:) forControlEvents:UIControlEventTouchUpInside];
                        viewButton.titleLabel.text = replyPhotoUrl;
                        [replyPhotoView addSubview:viewButton];
//                        [viewButton release];
                        
                        
                        
                        replyPhotoView.backgroundColor = [UIColor blackColor];
                        
                    }
                    if([dic[@"writeinfotype"]intValue]>4 && [dic[@"writeinfotype"]intValue]!=10)
                    {
                        [replyNameLabel setText:@""];
                        [positionLabel setText:@""];
//                        [teamLabel setText:@""];
                        [replyProfileImageView setImage:[UIImage imageNamed:@"list_profile_systeam.png"]];
                        [replyContentsTextView setText:@"업그레이드가 필요합니다."];
                        replyContentsTextView.frame = CGRectMake(45, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, 250, 34);
                        replyPhotoView.frame = CGRectMake(0,replyContentsTextView.frame.size.height + replyContentsTextView.frame.origin.y, 120, 0);
                    }
                    else if([dic[@"writeinfotype"]isEqualToString:@"10"]){
                        
                        [replyNameLabel setText:@"익명"];
                        [positionLabel setText:@""];
//                        [teamLabel setText:@""];
                        [replyProfileImageView setImage:[UIImage imageNamed:@"sns_anonym.png"]];
                    }
                    
                    else if([dic[@"writeinfotype"]isEqualToString:@"4"]){
                        firstReplyLabel.hidden = YES;
                        //        subImageView.image = [UIImage imageNamed:@"n01_tl_realic_lemp.png"];
                        [replyNameLabel setText:infoDic[@"text"]];
                        replyNameLabel.textColor = RGB(160, 18, 19);
                        
                        replyNameLabel.textColor = GreenTalkColor;
                        
                        [positionLabel setText:@""];
//                        [teamLabel setText:@""];
                        //        [SharedAppDelegate.root getThumbImageWithURL:[contentsData.personInfoobjectForKey:@"image"] ifNil:@"list_profile_systeam.png" view:profileImageView scale:7];
                        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:infoDic[@"image"] num:0 thumbnail:YES];
                        if (imgURL) {
                            [replyProfileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL
                                                                         andPlaceholderImage:[UIImage imageNamed:@"list_profile_systeam.png"]
                                                                                     options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                                                    progress:^(NSInteger a, NSInteger b) {
                                                                                        
                                                                                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                                                                                        NSLog(@"fail %@",[error localizedDescription]);
                                                                                        if (image != nil) {
                                                                                            [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                                                                                [replyProfileImageView setImage:roundedImage];
                                                                                            }];
                                                                                        }
                                                                                        [HTTPExceptionHandler handlingByError:error];
                                                                                        
                                                                                    }];
                        } else {
                            replyProfileImageView.image = [UIImage imageNamed:@"list_profile_systeam.png"];
                        }
                        
                    }
                    else{
                        
                        [SharedAppDelegate.root getProfileImageWithURL:dic[@"uid"] ifNil:@"profile_photo.png" view:replyProfileImageView scale:24];
                    }
                    [cell.contentView addSubview:replyContentsTextView];
//                    [replyContentsTextView release];
                    
                    [cell.contentView addSubview:replyPhotoView];
//                    [replyPhotoView release];
                    
                    //                UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"datview_bg.png"]];
                    //                bound.frame = CGRectMake(0,replyContentsTextView.frame.size.height+replyContentsTextView.frame.origin.y - 1,320,1);
                    //                [view addSubview:bound];
                    //                [bound release];
                    if([dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID] && [dic[@"writeinfotype"]isEqualToString:@"1"]){
                        NSLog(@"dic %@",dic);
                        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-33,(replyPhotoView.frame.size.height+replyPhotoView.frame.origin.y)/2-16,33,33)];
                        if(emoticonView.frame.size.height>0){
                            deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-33,(CGRectGetMaxY(emoticonView.frame))/2-16,33,33)];
                        }

                        [deleteButton setBackgroundImage:[UIImage imageNamed:@"replayedit_btn.png"] forState:UIControlStateNormal];
                        [deleteButton addTarget:self action:@selector(actionReply:) forControlEvents:UIControlEventTouchUpInside];
                        deleteButton.tag = row;
                        //                        deleteButton.titleLabel.text = dic[@"replyindex"];
                        [cell.contentView addSubview:deleteButton];
                    }
                    
                    CGRect messageFrame = cell.contentView.frame;
                    messageFrame.size.height = replyPhotoView.frame.size.height+replyPhotoView.frame.origin.y;
                    
                    if([replyPhotoUrl length]>0)
                        messageFrame.size.height += 10;
                    
                    [cell.contentView setFrame:messageFrame];
                    
                    
//                    UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"balon_grayline.png"]];
//                    bound.frame = CGRectMake(0,cell.contentView.frame.size.height-1,320,1);
//                    [cell.contentView addSubview:bound];
//                    [bound release];
                    
                    
                }
                
                
            
            
#else
            
#ifdef BearTalk
#else
            if(indexPath.row == 1 && [likeArray count]>0){
        
                
//                UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
//                image.image = [UIImage imageNamed:@"balon_grayline_deep.png"];
//                [cell.contentView addSubview:image];
//                [image release];
                
                
                UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 1, 320.0, 34)];
                [backgroundView setBackgroundColor:RGB(246, 246, 246)];
                [cell.contentView addSubview:backgroundView];
                backgroundView.userInteractionEnabled = YES;
                [cell.contentView sendSubviewToBack:backgroundView];
//                [backgroundView release];
                
//                image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 35, 320, 1)];
//                image.image = [UIImage imageNamed:@"balon_grayline_deep.png"];
//                [cell.contentView addSubview:image];
//                [image release];
                
                detailLike = [[UIImageView alloc]init];
                detailLike.image = [UIImage imageNamed:@"n06_nocal_ary.png"];
                detailLike.frame = CGRectMake(315-10, 10, 7, 13);
                [cell.contentView addSubview:detailLike];
                
                
                detailLike.hidden = NO;
                
                UIImageView *thumbImageView;
                UIImageView *likeProfileImageView;
                for(int i = 0; i < [likeArray count]; i++)
                {
                    if(i > 5)
                        break;
                    
                    likeProfileImageView = [[UIImageView alloc]init];
                    likeProfileImageView.frame = CGRectMake(10 + 35 * i, 4, 28, 28);
                    //            [likeProfileImageView setImage:[SharedAppDelegate.root getImage:[[array i]objectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"]];
                    [SharedAppDelegate.root getProfileImageWithURL:likeArray[i][@"uid"] ifNil:@"goodnophoto.png" view:likeProfileImageView scale:0];
                    [cell.contentView addSubview:likeProfileImageView];
//                    [likeProfileImageView release];
                    
                    
                    
                    thumbImageView = [[UIImageView alloc]init];
                    thumbImageView.frame = CGRectMake(0, 0, 28, 28);
                    [thumbImageView setImage:[UIImage imageNamed:@"goodphoto_cover.png"]];
                    [likeProfileImageView addSubview:thumbImageView];
//                    [thumbImageView release];
                    
                }
                
                if ([likeArray count] > 6) {
                    UIImageView *moreLike = [[UIImageView alloc]init];
                    moreLike.image = [UIImage imageNamed:@"n01_tl_list_profile_more.png"];
                    moreLike.frame = CGRectMake(315-10-32, 4, 26, 26);
                    [cell.contentView addSubview:moreLike];
//                    [moreLike release];
                }
                UIButton *likeMemberButton;
                likeMemberButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, backgroundView.frame.size.width, backgroundView.frame.size.height)];
                [likeMemberButton addTarget:self action:@selector(goodMember:) forControlEvents:UIControlEventTouchUpInside];
                likeMemberButton.tag = contentsData.likeCount;
                [backgroundView addSubview:likeMemberButton];
                
                
                
//                [detailLike release];
                
                
        
            }
            else{
#endif
                
                NSLog(@"indexpath row %d",indexPath.row);
                
                
                NSDictionary *replydic;
                
                if([likeArray count]>0){
                    

                    restcell = 2;

                    
                    
                }
                else{
                    
                    restcell = 1;

                    if(indexPath.row == 1){
//                    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
//                    image.image = [UIImage imageNamed:@"balon_grayline_deep.png"];
//                    [cell.contentView addSubview:image];
//                    [image release];
                    }
                    
                }
                
                
                
#ifdef BearTalk
                
                if(indexPath.row == 1){
                    NSLog(@"indexpath row == 1");
                    
                    
                    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0, cell.contentView.frame.size.width, 1+12+20+12+1)];
                    [backgroundView setBackgroundColor:RGB(247, 247, 249)];
                    [cell.contentView addSubview:backgroundView];
//                    backgroundView.userInteractionEnabled = YES;
//                    [cell.contentView sendSubviewToBack:backgroundView];
//                    cell.contentView.userInteractionEnabled = YES;
                    
                    //        [likeButton release];
                    
                    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, backgroundView.frame.size.width, 1)];
                    lineView.backgroundColor = RGB(239, 239, 239);
                    [backgroundView addSubview:lineView];
                    
                    lineView = [[UIView alloc]initWithFrame:CGRectMake(0, backgroundView.frame.size.height - 1, backgroundView.frame.size.width, 1)];
                    lineView.backgroundColor = RGB(239, 239, 239);
                    [backgroundView addSubview:lineView];
                    
                    UIImageView *likeImage;
                    likeImage = [[UIImageView alloc]init];
                    likeImage.frame = CGRectMake(16, 1+12, 20, 20);
                    likeImage.image = [UIImage imageNamed:@"btn_like_off.png"];
                    [backgroundView addSubview:likeImage];
                    
                    for(NSDictionary *dic in likeArray){
                        NSLog(@"dic uid %@ myuid %@",dic[@"uid"],[ResourceLoader sharedInstance].myUID);
                        if([dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID]) {
                            NSLog(@"it is me");
                            likeImage.image = [UIImage imageNamed:@"btn_like_on.png"];
                            break;
                        }
                    }
                    
                    UILabel *likeCountLabel2;
                    likeCountLabel2 = [[UILabel alloc] init];//WithFrame:CGRectMake(10, 5, 0, 0)];
                    likeCountLabel2.frame = CGRectMake(CGRectGetMaxX(likeImage.frame)+10, likeImage.frame.origin.y, 85, 18);
                    [likeCountLabel2 setTextAlignment:NSTextAlignmentLeft];
                    [likeCountLabel2 setTextColor:RGB(39, 41, 44)];
                    [likeCountLabel2 setFont:[UIFont systemFontOfSize:14]];
                    [likeCountLabel2 setBackgroundColor:[UIColor clearColor]];
                    [backgroundView addSubview:likeCountLabel2];
                    [likeCountLabel2 setText:[NSString stringWithFormat:@"%d",(int)[likeArray count]]];
               
                    
                                        //                [backgroundView release];
                    
                    //                image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 35, 320, 1)];
                    //                image.image = [UIImage imageNamed:@"balon_grayline_deep.png"];
                    //                [cell.contentView addSubview:image];
                    //                [image release];
                    
                    backgroundView.userInteractionEnabled = YES;
                    UIButton *likeButton;
                    likeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(likeCountLabel2.frame), 1+12+20+12+1)];
                    NSLog(@"likebutton frame %@",NSStringFromCGRect(likeButton.frame));
//                    likeButton.backgroundColor = [UIColor blueColor];
                    [likeButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                    [backgroundView addSubview:likeButton];
                    [likeButton addTarget:self action:@selector(sendLike:) forControlEvents:UIControlEventTouchUpInside];
                    
                    detailLike = [[UIImageView alloc]init];
                    detailLike.image = [UIImage imageNamed:@"btn_list_arrow.png"];
                    detailLike.frame = CGRectMake(backgroundView.frame.size.width - 16 - 10, 14, 10, 17);
                    [backgroundView addSubview:detailLike];
                    
                    
                    
                    UIImageView *likeProfileImageView;
                    for(int i = 0; i < [likeArray count]; i++)
                    {
                        if(i > 2)
                            break;
                        
                        likeProfileImageView = [[UIImageView alloc]init];
                        likeProfileImageView.frame = CGRectMake(detailLike.frame.origin.x - 9 - 33 - (i * (33+5)), 7, 33, 33);
                        //            [likeProfileImageView setImage:[SharedAppDelegate.root getImage:[[array i]objectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"]];
                        [SharedAppDelegate.root getProfileImageWithURL:likeArray[i][@"uid"] ifNil:@"profile_photo.png" view:likeProfileImageView scale:0];
                        [backgroundView addSubview:likeProfileImageView];
                        //                    [likeProfileImageView release];
                        
                        
                        likeProfileImageView.layer.cornerRadius = likeProfileImageView.frame.size.width/2; // rounding label
                        likeProfileImageView.clipsToBounds = YES;
                        
                        
                        UIImageView *iconView;
                        iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_view_like.png"]];
                        iconView.frame = CGRectMake(detailLike.frame.origin.x - 9 - 33 - (i * (33+5))+33-14, 7+33-14,14,14);
                        [backgroundView addSubview:iconView];
                        
                    }
                    
//                    if ([likeArray count] > 6) {
//                        UIImageView *moreLike = [[UIImageView alloc]init];
//                        moreLike.image = [UIImage imageNamed:@"n01_tl_list_profile_more.png"];
//                        moreLike.frame = CGRectMake(315-10-32, 4, 26, 26);
//                        [backgroundView addSubview:moreLike];
//                        //                    [moreLike release];
//                    }
                    UIButton *likeMemberButton;
                    likeMemberButton = [[UIButton alloc]initWithFrame:CGRectMake(backgroundView.frame.size.width/2, 0, backgroundView.frame.size.width - backgroundView.frame.size.width/2, backgroundView.frame.size.height)];
                    [likeMemberButton addTarget:self action:@selector(goodMember:) forControlEvents:UIControlEventTouchUpInside];
                    likeMemberButton.tag = contentsData.likeCount;
                    [backgroundView addSubview:likeMemberButton];
                
//                    likeMemberButton.backgroundColor = [UIColor redColor];
                    
                    
                }
                restcell = 2;
#endif
//
                NSLog(@"count %d, indexpath row %d",[replyArray count],indexPath.row);
                if([replyArray count]<=indexPath.row-restcell)
                    return cell;
                
                replydic = replyArray[indexPath.row-restcell];
                row = (int)indexPath.row-restcell;
                
                cell.contentView.backgroundColor = RGB(247, 247, 249);//RGB(246, 246, 246);
                
                
                if([replyArray count]>0){
                    NSLog(@"replyArray replydic %@",replydic);
                    //            {
                    //                UIImageView *replyImageView;
                    //                replyImageView = [[UIImageView alloc]init];
                    //                replyImageView.userInteractionEnabled = YES;
                    //            replyImageView.image = [[UIImage imageNamed:@"datwrithe_bg.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:22];
                    
                    NSDictionary *infoDic = [replydic[@"writeinfo"]objectFromJSONString];
                    NSLog(@"infoDic %@",infoDic);
                    UIImageView *replyProfileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 30, 30)];
                    //            [replyProfileImageView setImage:[SharedAppDelegate.root getImage:[dicobjectForKey:@"uid"] ifNil:@"n01_tl_list_profile.png"]];
                    replyProfileImageView.userInteractionEnabled = YES;
                    [cell.contentView addSubview:replyProfileImageView];
//                    [replyProfileImageView release];
                    
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                    UIImageView *roundingView;
                    roundingView = [[UIImageView alloc]init];
                    roundingView.frame = CGRectMake(0,0,replyProfileImageView.frame.size.width,replyProfileImageView.frame.size.height);
                    roundingView.image = [CustomUIKit customImageNamed:@"imageview_profile_rounding_1_gray_246.png"];
                    [replyProfileImageView addSubview:roundingView];
//                    [roundingView release];
#elif BearTalk
                    replyProfileImageView.frame = CGRectMake(16, 12, 33, 33);
                    replyProfileImageView.layer.cornerRadius = replyProfileImageView.frame.size.width/2; // rounding label
                    replyProfileImageView.clipsToBounds = YES;
#endif
                    
                    UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,replyProfileImageView.frame.size.width,replyProfileImageView.frame.size.height)];
                    viewButton.adjustsImageWhenHighlighted = NO;
                    [viewButton addTarget:self action:@selector(goToReplyTimeline:) forControlEvents:UIControlEventTouchUpInside];
                    viewButton.titleLabel.text = replydic[@"uid"];
                    viewButton.tag = [replydic[@"writeinfotype"]intValue];
                    [replyProfileImageView addSubview:viewButton];
                    
                    
                    UILabel *replyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 80, 16)];
                    [replyNameLabel setBackgroundColor:[UIColor clearColor]];
                    [replyNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
                    [replyNameLabel setTextColor:RGB(87, 107, 149)];
                    replyNameLabel.userInteractionEnabled = YES;
                    [cell.contentView addSubview:replyNameLabel];
//                    [replyNameLabel release];
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                    replyNameLabel.textColor = GreenTalkColor;
#elif BearTalk
                    [replyNameLabel setFont:[UIFont boldSystemFontOfSize:12]];
                    [replyNameLabel setTextColor:RGB(39, 31, 44)];
                    [replyNameLabel setFrame:CGRectMake(CGRectGetMaxX(replyProfileImageView.frame)+7, replyProfileImageView.frame.origin.y, 55, 12)];
#endif
                    
                    UIButton *tagNameButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, replyNameLabel.frame.size.width, replyNameLabel.frame.size.height)];
                    tagNameButton.adjustsImageWhenHighlighted = NO;
                    if([replydic[@"writeinfotype"]isEqualToString:@"1"] && ![replydic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID])
                        [tagNameButton addTarget:self action:@selector(tagName:) forControlEvents:UIControlEventTouchUpInside];
                    tagNameButton.titleLabel.text = replydic[@"uid"];
                    [replyNameLabel addSubview:tagNameButton];
//                    [tagNameButton release];
                    
                    
                    UILabel *positionLabel;
                    positionLabel = [[UILabel alloc]init];
                    [positionLabel setBackgroundColor:[UIColor clearColor]];
                    [positionLabel setTextColor:RGB(153,153,153)];
                    [positionLabel setFont:[UIFont systemFontOfSize:14]];
                    [cell.contentView addSubview:positionLabel];
//                    [positionLabel release];
                    
//                    UILabel *teamLabel;
//                    teamLabel = [[UILabel alloc]init];
//                    [teamLabel setBackgroundColor:[UIColor clearColor]];
//                    [teamLabel setTextColor:[UIColor grayColor]];
//                    [teamLabel setFont:[UIFont systemFontOfSize:14]];
//                    [cell.contentView addSubview:teamLabel];
//                    [teamLabel release];
                    
                    [replyNameLabel setText:infoDic[@"name"]];
                    [positionLabel setText:[NSString stringWithFormat:@"%@ | %@",infoDic[@"position"],infoDic[@"deptname"]]];
#ifdef BearTalk
                    [positionLabel setFont:[UIFont systemFontOfSize:11]];

#elif Batong

                    if([infoDic[@"position"]length]>0)
                        positionLabel.text = [NSString stringWithFormat:@"%@ | %@",infoDic[@"deptname"],infoDic[@"position"]];
                    else
                        positionLabel.text = [NSString stringWithFormat:@"%@",infoDic[@"deptname"]];

#endif
//                    [teamLabel setText:infoDic[@"deptname"]];
                    
                    CGSize size = [replyNameLabel.text sizeWithAttributes:@{NSFontAttributeName:replyNameLabel.font}];
                    positionLabel.frame = CGRectMake(replyNameLabel.frame.origin.x + (size.width+8>80?80:size.width+8), replyNameLabel.frame.origin.y, 150, replyNameLabel.frame.size.height);
                    
//                    CGSize size2 = [positionLabel.text sizeWithFont:positionLabel.font];
//                    teamLabel.frame = CGRectMake(positionLabel.frame.origin.x + (size2.width+5>70?70:size2.width+5), replyNameLabel.frame.origin.y, 70, 16);
                    
//                    UILabel *firstReplyLabel;
//                    firstReplyLabel = [[UILabel alloc]init];
//                    firstReplyLabel.frame = CGRectMake(320 - 5 - 60, positionLabel.frame.origin.y, 60, positionLabel.frame.size.height);
//                    [firstReplyLabel setBackgroundColor:[UIColor clearColor]];
//                    [firstReplyLabel setTextColor:[UIColor redColor]];
//                    [firstReplyLabel setFont:[UIFont systemFontOfSize:14]];
//                    firstReplyLabel.textAlignment = NSTextAlignmentRight;
//                    firstReplyLabel.text = @"";
//                    [cell.contentView addSubview:firstReplyLabel];
//                    firstReplyLabel.hidden = YES;
//                    [firstReplyLabel release];
                    
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
                  
                        
                        
                    }
                    else{
                        
                        
                    }
                    

#ifdef BearTalk
                    
                    
                    
                    UILabel *replyDetailTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 16 - 100, positionLabel.frame.origin.y, 100, positionLabel.frame.size.height)];
                    [replyDetailTimeLabel setTextColor:RGB(184, 184, 184)];
                    [replyDetailTimeLabel setBackgroundColor:[UIColor clearColor]];
                    [replyDetailTimeLabel setFont:[UIFont systemFontOfSize:11]];
                    [replyDetailTimeLabel setTextAlignment:NSTextAlignmentRight];
                    [replyDetailTimeLabel setText:[NSString calculateDate:replydic[@"writetime"]]];
//                    NSString *detailDateString = [NSString formattingDate:replydic[@"writetime"] withFormat:@"yy/MM/dd a h:mm"];
//                    [replyDetailTimeLabel setText:detailDateString];
                    [cell.contentView addSubview:replyDetailTimeLabel];
#else
                    
                    UILabel *replyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, replyProfileImageView.frame.origin.y + replyProfileImageView.frame.size.height + 5, 40, 10)];
                    [replyTimeLabel setTextAlignment:NSTextAlignmentCenter];
                    [replyTimeLabel setTextColor:[UIColor darkGrayColor]];
                    [replyTimeLabel setFont:[UIFont systemFontOfSize:10]];
                    [replyTimeLabel setBackgroundColor:[UIColor clearColor]];
                    //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    //        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    //        NSDate *date = [formatter dateFromString:[dicobjectForKey:@"messagedate"]];
                    //        id AppID = [[UIApplication sharedApplication]delegate];
                    //                    NSString *dateString = [NSString calculateDate:dic[@"writetime"]];// with:currentTime];
                    [replyTimeLabel setText:@""];//dateString];
                    [cell.contentView addSubview:replyTimeLabel];
                    //                    [replyTimeLabel release];
                    
                    UILabel *replyDetailTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height+2.0, 220.0, 16.0)];
                    [replyDetailTimeLabel setTextColor:[UIColor grayColor]];
                    [replyDetailTimeLabel setBackgroundColor:[UIColor clearColor]];
                    [replyDetailTimeLabel setFont:[UIFont systemFontOfSize:14.0]];
                    
                    NSString *detailDateString = [NSString formattingDate:replydic[@"writetime"] withFormat:@"yy/MM/dd a h:mm"];
                    [replyDetailTimeLabel setText:detailDateString];
                    [cell.contentView addSubview:replyDetailTimeLabel];
#endif
                    emoticonView = [[UIImageView alloc]init];//WithFrame:CGRectMake(10, contentsTextView.frame.size.height + whLabel.frame.size.height + 5, 290, 0)];
                    [cell.contentView addSubview:emoticonView];
//                    [emoticonView release];
                    emoticonView.contentMode = UIViewContentModeScaleAspectFit;
                    

                    
                    
                    UITextView *replyContentsTextView = [[UITextView alloc]init];//WithFrame:CGRectMake(45, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, replySize.width, replySize.height + 10)];
                    
                    
                    NSString *replyCon = [replydic[@"replymsg"]objectFromJSONString][@"msg"];
                    
                    

                    
#ifdef BearTalk
                    NSString *originReplyCon = replyCon;
                    NSLog(@"replyCon %@",replyCon);
                    replyContentsTextView.frame = CGRectMake(replyNameLabel.frame.origin.x, 12+12+7, self.view.frame.size.width - 16 - 33 - 7 - 16, 0);//rsize.height);//ceilf(CGRectGetHeight(replyrect))); // ############
                    NSLog(@"replyTextViewFrame0 %@",NSStringFromCGRect(replyContentsTextView.frame));
#else
                    
                    replyContentsTextView.frame = CGRectMake(45, replyDetailTimeLabel.frame.origin.y + replyDetailTimeLabel.frame.size.height, 250, 0);
                    
                    if([replydic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID] && [replydic[@"writeinfotype"]isEqualToString:@"1"]){
                        replyContentsTextView.frame = CGRectMake(45, replyDetailTimeLabel.frame.origin.y + replyDetailTimeLabel.frame.size.height, 250-33-5, 0);
                    }
                    
#endif
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:(int)rfontSize], NSParagraphStyleAttributeName:paragraphStyle};
                    CGSize rsize = [replyCon boundingRectWithSize:CGSizeMake(replyContentsTextView.frame.size.width, 10000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
                    
                    
                    if([replydic[@"writeinfotype"]isEqualToString:@"1"]){
                        for(NSDictionary *replyDic in replyArray){
                            
                            NSString *searchName = [NSString stringWithFormat:@"@%@",[replyDic[@"writeinfo"]objectFromJSONString][@"name"]];
                            //                            NSLog(@"searchName %@",searchName);
                            NSRange range = [replyCon rangeOfString:searchName];
                            if (range.length > 0){
                                NSLog(@"String contains");
                                NSString *htmlString = @"";
#ifdef Batong 
                                htmlString = [NSString stringWithFormat:@"<font color=\"#000000\"><b>%@</b></font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#else
                                htmlString = [NSString stringWithFormat:@"<font color=\"#a01213\">%@</font>",[searchName substringWithRange:NSMakeRange(1,[searchName length]-1)]];
#endif
                                //                            NSLog(@"replycon1 %@",replyCon);
                                //                            replyCon = [replyCon stringByReplacingCharactersInRange:range withString:htmlString];
                                replyCon = [replyCon stringByReplacingOccurrencesOfString:searchName withString:htmlString];
                                //                            NSLog(@"replycon2 %@",replyCon);
                            }
                        }
                    }
                    
                    //                        NSLog(@"\n contains");
                    //                        NSLog(@"replycon3 %@",replyCon);
                    replyCon = [replyCon stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
                    //                        NSLog(@"replycon4 %@",replyCon);
                    
//                    replyCon = [NSString stringWithFormat:@"<font size=%i>%@</font>",(int)fontSize,replyCon];
                    
                    
                    [replyContentsTextView setTextAlignment:NSTextAlignmentLeft];
                    replyContentsTextView.contentInset = UIEdgeInsetsMake(0,0,0,0);
#ifdef BearTalk         
                    replyContentsTextView.contentInset = UIEdgeInsetsMake(-8,-5,0,0);

#endif
                    [replyContentsTextView setFont:[UIFont systemFontOfSize:(int)rfontSize]];
                    [replyContentsTextView setBackgroundColor:[UIColor clearColor]];
                    [replyContentsTextView setDataDetectorTypes:UIDataDetectorTypeLink];
                    //                    [replyContentsTextView setBounces:NO];
                    [replyContentsTextView setScrollEnabled:NO];
                    replyContentsTextView.scrollsToTop = NO;
                    [replyContentsTextView setEditable:NO];
                    
                    //            [replyContentsLabel setAdjustsFontSizeToFitWidth:NO];
                    //                    [replyContentsTextView sizeToFit];
                    //            [replyContentsTextView setUserInteractionEnabled:YES];
                    //            [replyContentsLabel setNumberOfLines:0];
                    //            [replyContentsLabel setLineBreakMode:NSLineBreakByCharWrapping];
                    
//                    CGSize replySize;
                    CGRect replyrect;
                    
                    
                    
                        
                        NSString *htmlString = [NSString stringWithFormat:@"<html>"
                                                "<head>"
                                                "<style type=\"text/css\">"
                                                "body {font-family: \"%@\"; font-size: %i; height: auto; }"
                                                "</style>"
                                                "</head>"
                                                "<body>%@</body>"
                                                "</html>", replyContentsTextView.font.fontName, (int)rfontSize, replyCon];
                        
                        
                        NSData *htmlDATA = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
                        
                        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:htmlDATA options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
                        [replyContentsTextView setAttributedText:attrStr];
                        NSLog(@"**attrStr %@",attrStr);
                        
//                        NSLog(@"**attrStr %@",attrStr);
                    
#ifdef BearTalk
                    
                    
                    NSLog(@"replyContentsTextView.font.fontName %@",replyContentsTextView.font.fontName);
                    replyContentsTextView.frame = CGRectMake(replyNameLabel.frame.origin.x, 12+12+7, replyContentsTextView.frame.size.width,[replyContentsTextView sizeThatFits:CGSizeMake(replyContentsTextView.frame.size.width, 10000)].height);//ceilf(CGRectGetHeight(replyrect))); // ############
                    NSLog(@"sizethatfitsizee %d %f",indexPath.row-restcell,[replyContentsTextView sizeThatFits:CGSizeMake(replyContentsTextView.frame.size.width, 10000)].height);
                    NSLog(@"replyTextViewFrame %@",NSStringFromCGRect(replyContentsTextView.frame));
#else
                    
                    replyrect = [attrStr boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 16 - 33 - 7 - 16, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
                    
                    replyContentsTextView.frame = CGRectMake(45, replyDetailTimeLabel.frame.origin.y + replyDetailTimeLabel.frame.size.height, 250, ceilf(CGRectGetHeight(replyrect)) + 22);
                    
                    
#endif
                    
                    
//
                    
#if defined(Batong) || defined(BearTalk)
                    if([[replydic[@"replymsg"]objectFromJSONString][@"emoticon"]length]>0)
                        emoticonView.frame = CGRectMake(replyDetailTimeLabel.frame.origin.x, CGRectGetMaxY(replyContentsTextView.frame)-12, 100, 100);
    #ifdef BearTalk
                    
                    emoticonView.frame = CGRectMake(replyContentsTextView.frame.origin.x, CGRectGetMaxY(replyContentsTextView.frame), 100, 100);
    #endif
                     emoticonView.image = nil;
                    NSArray *fileName = [[replydic[@"replymsg"]objectFromJSONString][@"emoticon"] componentsSeparatedByString:@"/"];
                    
                    NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/emoticon_%@",NSHomeDirectory(),fileName[[fileName count]-1]];
                    NSLog(@"cachefilePath %@",cachefilePath);
                    UIImage *img = [UIImage imageWithContentsOfFile:cachefilePath];
                    NSLog(@"img %@",img);
                    
                    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[replydic[@"replymsg"]objectFromJSONString][@"emoticon"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
                    NSLog(@"timeout: %f", request.timeoutInterval);
                    //                    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:nil];
                    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                    
                    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
                     {
                         NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
                     }];
                    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        UIGraphicsBeginImageContext(CGSizeMake(240,240));
                        [[UIImage imageWithData:operation.responseData] drawInRect:CGRectMake(0,0,240,240)];
                        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                        UIGraphicsEndImageContext();
                        
                        
                        
                        NSData *dataObj = UIImagePNGRepresentation(newImage);
                        [dataObj writeToFile:cachefilePath atomically:YES];
                        NSLog(@"cachefilePath %@",cachefilePath);
                        
                        emoticonView.image = newImage;
                        
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        [HTTPExceptionHandler handlingByError:error];
                        NSLog(@"failed %@",error);
                    }];
                    [operation start];
#endif
                    
                    UIImageView *replyPhotoView = [[UIImageView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(replyContentsTextView.frame), 120, 0)];
                    replyPhotoView.userInteractionEnabled = YES;
                    
                    NSString *replyPhotoUrl = [replydic[@"replymsg"]objectFromJSONString][@"image"];
                    NSLog(@"replyPhotourl %@",replyPhotoUrl);
                    if([replyPhotoUrl length]>0){
                        
                        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:replyPhotoUrl num:0 thumbnail:YES];
                        
                        
#ifdef BearTalk
                        
                        imgURL = [ResourceLoader resourceURLfromJSONString:replyPhotoUrl num:0 thumbnail:NO];
                        NSData *imageData = [NSData dataWithContentsOfURL:imgURL];
                        NSLog(@"imgURL %@ imageData length %d",imgURL,[imageData length]);
                        replyPhotoView.image = [UIImage sd_animatedGIFWithData:imageData];
#else
                        [replyPhotoView sd_setImageWithPreviousCachedImageWithURL:imgURL andPlaceholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger a, NSInteger b) {
                            
                        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl) {
                            NSLog(@"fail %@",[error localizedDescription]);
                            [HTTPExceptionHandler handlingByError:error];
                            
                        }];
#endif
                        NSDictionary *sizeDic = [replyPhotoUrl objectFromJSONString][@"thumbnailinfo"];
                        
                        CGFloat imageScale = 0.0f;
                        if([sizeDic[@"width"]floatValue]>120.0f){
                            imageScale = [sizeDic[@"width"]floatValue]/120.0f;
                            NSLog(@"imageScale %f",imageScale);
                            replyPhotoView.frame = CGRectMake(replyContentsTextView.frame.origin.x + 10,
                                                              CGRectGetMaxY(replyContentsTextView.frame),
                                                              120, [sizeDic[@"height"]floatValue]/imageScale);
                            NSLog(@"imageScale %f",[sizeDic[@"height"]floatValue]/imageScale);
                        }
                        else{
                            imageScale = 120.0f/[sizeDic[@"width"]floatValue];
                            replyPhotoView.frame = CGRectMake(replyContentsTextView.frame.origin.x + 10,
                                                              CGRectGetMaxY(replyContentsTextView.frame),
                                                              120, [sizeDic[@"height"]floatValue]*imageScale);
                            
                        }
                        NSLog(@"////////////////frame %@",NSStringFromCGRect(replyPhotoView.frame));
                        
                        
                        UIButton *viewButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,replyPhotoView.frame.size.width,replyPhotoView.frame.size.height)];
                        viewButton.adjustsImageWhenHighlighted = NO;
                        [viewButton addTarget:self action:@selector(viewReplyImage:) forControlEvents:UIControlEventTouchUpInside];
                        viewButton.titleLabel.text = replyPhotoUrl;
                        [replyPhotoView addSubview:viewButton];
//                        [viewButton release];
                        
                        
                        
                        replyPhotoView.backgroundColor = [UIColor blackColor];
                        
                    }
                    if([replydic[@"writeinfotype"]intValue]>4 && [replydic[@"writeinfotype"]intValue]!=10)
                    {
                        [replyNameLabel setText:@""];
                        [positionLabel setText:@""];
//                        [teamLabel setText:@""];
                        [replyProfileImageView setImage:[UIImage imageNamed:@"list_profile_systeam.png"]];
                        [replyContentsTextView setText:@"업그레이드가 필요합니다."];
                        replyContentsTextView.frame = CGRectMake(replyNameLabel.frame.origin.x, replyNameLabel.frame.origin.y + replyNameLabel.frame.size.height, 250, 34);
                        replyPhotoView.frame = CGRectMake(0,CGRectGetMaxY(replyContentsTextView.frame), 120, 0);
                    }
                    else if([replydic[@"writeinfotype"]isEqualToString:@"10"]){
                        
                        [replyNameLabel setText:@"익명"];
                        [positionLabel setText:@""];
//                        [teamLabel setText:@""];
                        [replyProfileImageView setImage:[UIImage imageNamed:@"sns_anonym.png"]];
                    }
                    
                    else if([replydic[@"writeinfotype"]isEqualToString:@"4"]){
//                        firstReplyLabel.hidden = YES;
                        //        subImageView.image = [UIImage imageNamed:@"n01_tl_realic_lemp.png"];
                        [replyNameLabel setText:infoDic[@"text"]];
                        replyNameLabel.textColor = RGB(160, 18, 19);
#if defined(GreenTalk) || defined(GreenTalkCustomer)
                        replyNameLabel.textColor = GreenTalkColor;
#endif
                        [positionLabel setText:@""];
//                        [teamLabel setText:@""];
                        //        [SharedAppDelegate.root getThumbImageWithURL:[contentsData.personInfoobjectForKey:@"image"] ifNil:@"list_profile_systeam.png" view:profileImageView scale:7];
                        NSURL *imgURL = [ResourceLoader resourceURLfromJSONString:infoDic[@"image"] num:0 thumbnail:YES];
                        if (imgURL) {
                            [replyProfileImageView sd_setImageWithPreviousCachedImageWithURL:imgURL
                                                                         andPlaceholderImage:[UIImage imageNamed:@"list_profile_systeam.png"]
                                                                                     options:SDWebImageRetryFailed|SDWebImageLowPriority|SDWebImageCacheMemoryOnly
                                                                                    progress:^(NSInteger a, NSInteger b) {
                                                                                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *aUrl){
                                                                                        NSLog(@"fail %@",[error localizedDescription]);
                                                                                        if (image != nil) {
                                                                                            [ResourceLoader roundCornersOfImage:image scale:7 block:^(UIImage *roundedImage) {
                                                                                                [replyProfileImageView setImage:roundedImage];
                                                                                            }];
                                                                                        }
                                                                                        
                                                                                        [HTTPExceptionHandler handlingByError:error];
                                                                                        
                                                                                    }];
                        } else {
                            replyProfileImageView.image = [UIImage imageNamed:@"list_profile_systeam.png"];
                        }
                        
                    }
                    else{
                        
                        [SharedAppDelegate.root getProfileImageWithURL:replydic[@"uid"] ifNil:@"profile_photo.png" view:replyProfileImageView scale:24];
                    }
                    [cell.contentView addSubview:replyContentsTextView];
//                    [replyContentsTextView release];
                    
                    [cell.contentView addSubview:replyPhotoView];
//                    [replyPhotoView release];
                    
                    //                UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"datview_bg.png"]];
                    //                bound.frame = CGRectMake(0,replyContentsTextView.frame.size.height+replyContentsTextView.frame.origin.y - 1,320,1);
                    //                [view addSubview:bound];
                    //                [bound release];
                    if([replydic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID] && [replydic[@"writeinfotype"]isEqualToString:@"1"]){
                        NSLog(@"replydic %@",replydic);
                     
#ifdef BearTalk
                        
#else
                        UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-33,(CGRectGetMaxY(replyPhotoView.frame))/2-16,33,33)];
                        if(emoticonView.frame.size.height>0){
                            deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-33,(CGRectGetMaxY(emoticonView.frame))/2-16,33,33)];
                        }
                        
                        [deleteButton setBackgroundImage:[UIImage imageNamed:@"replayedit_btn.png"] forState:UIControlStateNormal];
                        [deleteButton addTarget:self action:@selector(actionReply:) forControlEvents:UIControlEventTouchUpInside];
                        deleteButton.tag = row;
                        //                        deleteButton.titleLabel.text = dic[@"replyindex"];
                        [cell.contentView addSubview:deleteButton];
#endif
                    }
                    
                    //                    CGRect cFrame = cell.contentView.frame;
                  
                    
                    
                    //                    [cell.contentView setFrame:cFrame];
                    //                    NSLog(@"cFrame %@",NSStringFromCGRect(cFrame));
                    
                    
//                            UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"balon_grayline.png"]];
//                            bound.frame = CGRectMake(0,rHeight-1,320,1);
//                            [cell.contentView addSubview:bound];
//                            [bound release];
              
                }
                //                UIImageView *bound = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"datview_bg.png"]];
                //                bound.frame = CGRectMake(0,cell.contentView.frame.origin.y+cell.contentView.frame.size.height-1,320,1);
                //                [cell.contentView addSubview:bound];
                //                [bound release];
                
                
                //                [cell.contentView addSubview:view];
                //                    [view setUserInteractionEnabled:YES];
                
                
                
                

    #ifdef BearTalk
    #else
            }
    #endif
#endif
        }
        
    }


    
    return cell;
    
}


- (void)actionReply:(id)sender{
    
    NSDictionary *dic = replyArray[[sender tag]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"댓글 수정"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            [self modifyReplyAction:dic];
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"댓글 삭제"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            [self deleteReplyAction:dic];
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
        
        UIActionSheet *actionSheet;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"댓글 수정", @"댓글 삭제", nil];
        
        [actionSheet showInView:SharedAppDelegate.window];
        objc_setAssociatedObject(actionSheet, &paramDic, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        actionSheet.tag = kActionReply;
    }
    
}
- (void)modifyReplyAction:(NSDictionary *)dic{
    
//    PostViewController *post = [[PostViewController alloc]initWithStyle:kPost];//WithViewCon:self];
    //    post.title = [NSString stringWithFormat:@"%@",self.title];
    [SharedAppDelegate.root.home.post initData:kPost];
    SharedAppDelegate.root.home.post.title = @"댓글수정";
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
        SharedAppDelegate.root.home.post.title = @"답변수정";
    
    
    //    NSDictionary *dic = objc_getAssociatedObject(sender, &paramDic);
    NSLog(@"dic %@",dic);
    BOOL hasImage = NO;
    NSString *replyPhotoUrl = [dic[@"replymsg"]objectFromJSONString][@"image"];
    if([replyPhotoUrl length]>0)
        hasImage = YES;
    [SharedAppDelegate.root.home.post setModifyView:[dic[@"replymsg"]objectFromJSONString][@"msg"] idx:dic[@"replyindex"] tag:kModifyReply image:hasImage images:nil poll:nil];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.home.post];
    [self presentViewController:nc animated:YES completion:nil];
//    [post release];
//    [nc release];
}
- (void)deleteReplyAction:(NSDictionary *)dic{
    
    //    NSDictionary *dic = objc_getAssociatedObject(sender, &paramDic);
    NSLog(@"number %@",dic[@"replyindex"]);
    //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
    NSString *title = @"댓글삭제";
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
        title = @"답변삭제";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:title
                                                                                 message:@"정말 삭제하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        [self confirmDeleteReply:dic[@"replyindex"]];
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:title message:@"정말 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
        alert.tag = kDeleteReply;
        objc_setAssociatedObject(alert, &paramNumber, dic[@"replyindex"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [alert show];
//        [alert release];
    }
}
- (void)modifyReply:(id)sender{
    
//    PostViewController *post = [[PostViewController alloc]initWithStyle:kPost];//WithViewCon:self];
    //    post.title = [NSString stringWithFormat:@"%@",self.title];
    [SharedAppDelegate.root.home.post initData:kPost];
    SharedAppDelegate.root.home.post.title = @"댓글수정";
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
        SharedAppDelegate.root.home.post.title = @"답변수정";
    
    
    NSDictionary *dic = objc_getAssociatedObject(sender, &paramDic);
    NSLog(@"dic %@",dic);
    BOOL hasImage = NO;
    NSString *replyPhotoUrl = [dic[@"replymsg"]objectFromJSONString][@"image"];
    if([replyPhotoUrl length]>0)
        hasImage = YES;
    [SharedAppDelegate.root.home.post setModifyView:[dic[@"replymsg"]objectFromJSONString][@"msg"] idx:dic[@"replyindex"] tag:kModifyReply image:hasImage images:nil poll:nil];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:SharedAppDelegate.root.home.post];
    [self presentViewController:nc animated:YES completion:nil];
//    [post release];
//    [nc release];
}
- (void)deleteReply:(id)sender{
    
    NSDictionary *dic = objc_getAssociatedObject(sender, &paramDic);
    NSLog(@"number %@",dic[@"replyindex"]);
    //    NSString *msg = [NSString stringWithFormat:@"%@로 일반 전화를 거시겠습니까?",number];
    NSString *title = @"댓글삭제";
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
        title = @"답변삭제";
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:title
                                                                                 message:@"정말 삭제하시겠습니까?"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okb = [UIAlertAction actionWithTitle:@"예"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action){
                                                        
                                                        
                                                        
                                                        [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                    }];
        
        UIAlertAction *cancelb = [UIAlertAction actionWithTitle:@"아니요"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * action){
                                                            [alertcontroller dismissViewControllerAnimated:YES completion:nil];
                                                        }];
        
        [alertcontroller addAction:cancelb];
        [alertcontroller addAction:okb];
        [self presentViewController:alertcontroller animated:YES completion:nil];
        
    }
    else{
        
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:title message:@"정말 삭제하시겠습니까?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"예", nil];
        alert.tag = kDeleteReply;
        objc_setAssociatedObject(alert, &paramNumber, dic[@"replyindex"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [alert show];
//        [alert release];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)view {
    NSLog(@"scrollViewWillBeginDragging");
    pointNow = view.contentOffset;
}

-(void)scrollViewDidScroll:(UIScrollView *)view {
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
    {
        return;
    }
    if (view.contentOffset.y<pointNow.y && [view isKindOfClass:[UITableView class]]) {
        NSLog(@"down");
        [self.view endEditing:YES];
        
#if defined(Batong) || defined(BearTalk)
        NSLog(@"showEmoticonView %@",showEmoticonView?@"YES":@"NO");
//        if(showEmoticonView){
        
        
        [self hideAllView];
//        }
#endif
    } else if (view.contentOffset.y>pointNow.y) {
        NSLog(@"up");
    }
}

- (void)share:(id)sender{
    NSLog(@"share");
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"소셜로 공유하기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            [SharedAppDelegate.root.home showShareGroupActionsheet:contentsData.idx];
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"외부로 공유하기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            [SharedAppDelegate.root.home showShareOtherAppActionsheet:contentsData.contentDic[@"msg"] con:self];
                            
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    else{
        UIActionSheet *actionSheet;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"소셜로 공유하기", @"외부로 공유하기", nil];
        
        [actionSheet showInView:SharedAppDelegate.window];
        actionSheet.tag = kSelectShare;
    }
    
}

- (void)addOrClear:(id)sender
{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
#ifdef GreenTalkCustomer
    
    if([contentsData.contentType isEqualToString:@"1"]){
        [self share:sender];
    }
    return;
    
#elif GreenTalk
    
    if([contentsData.contentType isEqualToString:@"1"]){
        [self share:sender];
        return;
    }
    
    if(![contentsData.contentType isEqualToString:@"7"]){
        return;
    }
    
#endif
    
    [MBProgressHUD showHUDAddedTo:sender label:nil animated:YES];
    
    NSString *type = @"";
    
    if([sender tag]==kNotFavorite){
        type = @"1";
    }
    else{
        type = @"2";
    }
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/setfavorite.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                type,@"type",@"2",@"category",contentsData.idx,@"contentindex",
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                @"",@"member",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",nil];
    NSLog(@"parameter %@",parameters);
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/setfavorite.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"ResulstDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([sender tag] == kNotFavorite){
                if([contentsData.contentType isEqualToString:@"7"]){
                    [favButton setBackgroundImage:[UIImage imageNamed:@"button_note_detail_bookmark_selected.png"] forState:UIControlStateNormal];
                    OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"쪽지가 이동되었습니다."];
                    
                    toast.position = OLGhostAlertViewPositionCenter;
                    
                    toast.style = OLGhostAlertViewStyleDark;
                    toast.timeout = 2.0;
                    toast.dismissible = YES;
                    [toast show];
//                    [toast release];
                }else{
                    [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_prs.png"] forState:UIControlStateNormal];
#ifdef BearTalk
                [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_on.png"] forState:UIControlStateNormal];
#endif
                }
                favButton.tag = kFavorite;
            }
            else{
                if([contentsData.contentType isEqualToString:@"7"]){
                    [favButton setBackgroundImage:[UIImage imageNamed:@"button_note_detail_bookmark.png"] forState:UIControlStateNormal];
                    OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"쪽지가 이동되었습니다."];
                    
                    toast.position = OLGhostAlertViewPositionCenter;
                    
                    toast.style = OLGhostAlertViewStyleDark;
                    toast.timeout = 2.0;
                    toast.dismissible = YES;
                    [toast show];
//                    [toast release];
                }else{
                    [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_dft.png"] forState:UIControlStateNormal];
#ifdef BearTalk
                [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_off.png"] forState:UIControlStateNormal];
#endif
                }
                favButton.tag = kNotFavorite;
                
            }
            if([contentsData.contentType isEqualToString:@"7"]){
                [SharedAppDelegate.root.note refreshTimeline];
            }
            else if([contentsData.categoryType isEqualToString:@"10"]){
                [SharedAppDelegate.root setNeedsRefresh:YES];
            }
            else{
                
                if ([self.parentViewCon respondsToSelector:@selector(addOrClear:favorite:)])
                    [(HomeTimelineViewController *)self.parentViewCon addOrClear:contentsData.idx favorite:type];
            }
            
            
            //            if([SharedAppDelegate.root.home.category isEqualToString:@"10"])
            //            [SharedAppDelegate.root setNeedsRefresh:YES];
            //                [SharedAppDelegate.root.home refreshTimeline];
            
            
            [MBProgressHUD hideHUDForView:sender animated:YES];
            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            [MBProgressHUD hideHUDForView:sender animated:YES];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:sender animated:YES];
        //            [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"즐겨찾기 하는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
    
}


- (void)viewFile:(id)sender{
    
    NSDictionary *dic = contentsData.fileArray[[sender tag]];
    NSLog(@"viewFile %@",dic);
    /*
     dic 
     file_ext = octet-stream
     filename = ~~~.ext
     url = @"https://~~~.ext"
     */
    
    NSString *name = dic[@"filename"];
    NSString *saveFileName = [NSString stringWithFormat:@"%@_%@",contentsData.idx,name];
    
//    NSData *fileData = nil;
    NSString *cachefilePath;// = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),saveFileName];
    NSString *fileExt;
    
    if([[name pathExtension]length]>0){
        fileExt = [name pathExtension];
    }
    else{
        
            
            NSArray *fileNameArray = [dic[@"file_ext"] componentsSeparatedByString:@"/"];
            if([fileNameArray count]>1)
            fileExt = fileNameArray[[fileNameArray count]-1];
        
    }
    
    fileExt = [fileExt lowercaseString];
    NSLog(@"fileExt %@",fileExt);
    NSURL *fileURL;
    NSString *fileUrlString = @"";
    
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if([saveFileName hasSuffix:fileExt]){
        cachefilePath = [NSString stringWithFormat:@"%@/%@",documentsPath,saveFileName];
        
    }
    else{
    cachefilePath = [NSString stringWithFormat:@"%@/%@.%@",documentsPath,saveFileName,fileExt];
    }
    NSLog(@"cachepath %@",cachefilePath);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
        NSLog(@"fileexist %@",cachefilePath);
        
        
        fileURL = [NSURL fileURLWithPath:cachefilePath];
        //                return;
    }
    else{
        fileUrlString = dic[@"url"];
        NSLog(@"fileUrlString %@",fileUrlString);
        fileUrlString = [fileUrlString substringToIndex:[fileUrlString length]-[name length]];
        NSLog(@"fileUrlString.....%@",fileUrlString);
        fileUrlString = [fileUrlString stringByAppendingString:[name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"fileUrlString.....%@",fileUrlString);
        fileURL = [NSURL URLWithString:fileUrlString];
        NSLog(@"qqqqq.....%@",fileURL);
        
    }
    
    
    
    if([fileExt hasSuffix:@"hwp"]){
        
        
        NSData *fileData;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
            fileData = [NSData dataWithContentsOfFile:cachefilePath];
        }
        else{
            
            fileData = [NSData dataWithContentsOfURL:fileURL];
        }
        
        NSLog(@"fileData length.....%d",(int)[fileData length]);
        if([fileData length]<1){
            // cannot open
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"열 수 있는 파일을 찾을 수 없습니다." con:self];
        }
        else{
            
            [fileData writeToFile:cachefilePath atomically:YES];
        }
        
        
        
        
        
        [self viewHWPFile:sender];
    }
   else if([fileExt hasSuffix:@"mp4"] || [fileExt hasSuffix:@"mov"] || [fileExt hasSuffix:@"m4v"] || [fileExt hasSuffix:@"mp3"]){
       [SharedAppDelegate.root setAudioRoute:YES];
       
       NSData *fileData;
       
       if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
           fileData = [NSData dataWithContentsOfFile:cachefilePath];
       }
       else{
           fileData = [NSData dataWithContentsOfURL:fileURL];
       }
       NSLog(@"fileData length.....%d",(int)[fileData length]);
       
       
       if([fileData length]<1){
           
           [CustomUIKit popupSimpleAlertViewOK:nil msg:@"재생 가능한 파일을 찾을 수 없습니다." con:self];
       }
       else{
           
           if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
           }
           else{
               
               [fileData writeToFile:cachefilePath atomically:YES];
           }
           fileURL = [NSURL fileURLWithPath:cachefilePath];
           NSLog(@"fileURL %@",fileURL);
           NSLog(@"cachefilePath %@",cachefilePath);
           
        
        MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:cachefilePath]] ;
        if(mp)
        {
            //		[mp shouldAutorotateToInterfaceOrientation:YES];
            [mp.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
            [mp.moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
            [[mp view] setBackgroundColor:[UIColor blackColor]];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(MPMovieFinished:)
                                                         name:MPMoviePlayerPlaybackDidFinishNotification
                                                       object:mp.moviePlayer];
            [self presentMoviePlayerViewControllerAnimated:mp];
            [mp.moviePlayer setShouldAutoplay:YES];
            //		[playButton setEnabled:YES];
        } else {
            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"재생 가능한 파일을 찾을 수 없습니다!" con:self];
        }
       }
       
    }
//    else if([fileExt hasSuffix:@"jpg"] || [fileExt hasSuffix:@"png"] || [fileExt hasSuffix:@"jpeg"] || [fileExt hasSuffix:@"gif"]
//            || [fileExt hasSuffix:@"tiff"] || [fileExt hasSuffix:@"tif"] || [fileExt hasSuffix:@"bmp"] || [fileExt hasSuffix:@"ico"]
//            || [fileExt hasSuffix:@"cur"] || [fileExt hasSuffix:@"xbm"]){
//        
//        
//        NSString *msgindex;
//        for(NSDictionary *dic in self.messages){
//            if([dic[@"message"]isEqualToString:text]){
//                msgindex = dic[@"msgindex"];
//            }
//        }
//        NSMutableArray *images = [NSMutableArray array];
//        [images addObject:[NSDictionary dictionaryWithObjectsAndKeys:text,@"message",msgindex,@"msgindex",nil]];
//        
//        NSLog(@"images %@",images);
//        
//        
//        
//        PhotoTableViewController *photoCon;
//        photoCon = [[PhotoTableViewController alloc]initForDownloadWithArray:images parent:self index:(int)0];
//        
//        
//        UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:photoCon];
//        [self presentViewController:nc animated:YES completion:nil];
//        
//        UIViewController *photoCon;
//        photoCon = [[PhotoTableViewController alloc]initForDownload:dic parent:self index:(int)[sender tag]];
//        UINavigationController *nc = [[CBNavigationController alloc] initWithRootViewController:photoCon];
//        [self presentViewController:nc animated:YES completion:nil];
//
//        
//        
//    }
    else{
    WebViewController *webController = [[WebViewController alloc] init];//WithAddress:NO];
    webController.title = name;
        
        UIButton *button = [CustomUIKit backButtonWithTitle:@"" target:webController selector:@selector(backTo)];
        UIBarButtonItem *btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
        webController.navigationItem.leftBarButtonItem = btnNavi;
        
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:webController];
        [self presentViewController:nc animated:YES completion:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            if(![self.navigationController.topViewController isKindOfClass:[webController class]])
//        [self.navigationController pushViewController:webController animated:YES];
            
            NSData *fileData;
            
            if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
                fileData = [NSData dataWithContentsOfFile:cachefilePath];
            }
            else{
                
                fileData = [NSData dataWithContentsOfURL:fileURL];
            }
            
            NSLog(@"fileData length.....%d",(int)[fileData length]);
            if([fileData length]<1){
                
                [CustomUIKit popupSimpleAlertViewOK:nil msg:@"열 수 있는 파일을 찾을 수 없습니다." con:self];
            }
            else{
                
                
                if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
                    NSLog(@"loadfromdb");
                    [webController loadFromDB:cachefilePath];
                }
                else{
                    
                    NSLog(@"fileData length.....%d",(int)[fileData length]);
                    
                    
                    [webController loadURL:fileUrlString];
                    [fileData writeToFile:cachefilePath atomically:YES];
                    
                }
            }
            
        });
  
    
    //        [webController loadURL:dic[@"url"]];
//    [webController loadFromDB:cachefilePath];
    

//    [btnNavi release];
//        [button release];
//    [webController release];
    
    }
    
}

- (void)MPMovieFinished:(NSNotification *)noti {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:[noti valueForKey:@"object"]];
    //	[[VoIPSingleton sharedVoIP] callSpeaker:NO];
    //	id AppID = [[UIApplication sharedApplication] delegate];
    [SharedAppDelegate.root setAudioRoute:NO];
    
    
}

- (void)viewHWPFile:(id)sender{
    
    
    
        NSDictionary *dic = contentsData.fileArray[[sender tag]];
//        NSLog(@"viewHWPFile %@",dic);
//        NSString *fileUrlString = dic[@"url"];
//        NSLog(@"fileUrlString %@",fileUrlString);
//        fileUrlString = [fileUrlString substringToIndex:[fileUrlString length]-[dic[@"filename"]length]];
//        NSLog(@"fileUrlString.....%@",fileUrlString);
//        fileUrlString = [fileUrlString stringByAppendingString:[dic[@"filename"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        NSLog(@"fileUrlString.....%@",fileUrlString);
//        //        fileUrlString = [fileUrlString substringFromIndex:8];//[fileUrlString length]-[dic[@"filename"]length]];
//        NSLog(@"fileUrlString.....%@",fileUrlString);
//        NSURL *fileURL = [NSURL URLWithString:fileUrlString];
//        NSLog(@"qqqqq.....%@",fileURL);
//        NSData *fileData = nil;
        NSString *saveFileName = [NSString stringWithFormat:@"%@_%@",contentsData.idx,dic[@"filename"]];
//        NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),saveFileName];
//        //        NSString *encodeCachePath = [cachefilePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        fileData = [NSData dataWithContentsOfURL:fileURL];
//        NSLog(@"fileData length.....%d",(int)[fileData length]);
//        
//        //        NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),saveFileName];
//        [fileData writeToFile:cachefilePath atomically:YES];
//        
//        NSURL *tempURL = [NSURL fileURLWithPath:cachefilePath];
//        
//        docController = [UIDocumentInteractionController interactionControllerWithURL:tempURL];
//        docController.delegate = self;
//      
//        
//        [docController presentOpenInMenuFromRect:CGRectMake(0.0, 144.0, 100.0, 200.0) inView:self.view animated:YES];
    
    
    
    NSString *cachefilePath;
    NSURL *fileURL;
    NSString* documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    if([saveFileName hasSuffix:@"hwp"]){
        cachefilePath = [NSString stringWithFormat:@"%@/%@",documentsPath,saveFileName];
        
    }
    else{
        cachefilePath = [NSString stringWithFormat:@"%@/%@.hwp",documentsPath,saveFileName];
    }
    NSLog(@"cachepath %@",cachefilePath);
    fileURL = [NSURL fileURLWithPath:cachefilePath];
    
    
    
    
    
    docController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    NSLog(@"docController %@",docController);
    docController.delegate = self;
    
    
    
    BOOL canOpen = [docController presentOpenInMenuFromRect:CGRectMake(0.0, 144.0, 100.0, 200.0) inView:self.view animated:YES];
    NSLog(@"canOpen %@",canOpen?@"YES":@"NO");
    if(canOpen){
        [docController presentOpenInMenuFromRect:CGRectMake(0.0, 144.0, 100.0, 200.0) inView:self.view animated:YES];
    }
    else{
        [CustomUIKit popupAlertViewOK:nil msg:@"첨부 파일을 보기 위한 뷰어 앱이 설치 되어 있지 않습니다. 뷰어 설치를 위해 스토어로 이동하시겠습니까?" delegate:self tag:kInstallHWP sel:@selector(confirmHwp) with:nil csel:nil with:nil];
    }
    
}
//- (void)viewHWPFile3:(id)sender{
//
//    UIImage *image1 = [UIImage imageNamed:@"bookmark_btn_dft.png"];
//    UIImage *image2 = [UIImage imageNamed:@"bookmark_btn_prs.png"];
//    NSArray *itemsToShare = [NSArray arrayWithObjects:image1, image2, nil];
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
////    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,    UIActivityTypeAssignToContact]; //or whichever you don't need
//    [self presentViewController:activityVC animated:YES completion:nil];
//}
//
//- (void)viewHWPFile4:(id)sender{
//
//    NSDictionary *dic = contentsData.fileArray[[sender tag]];
//    NSString *fileUrlString = dic[@"url"];
//    NSLog(@"fileUrlString %@",fileUrlString);
//    fileUrlString = [fileUrlString substringToIndex:[fileUrlString length]-[dic[@"filename"]length]];
//    NSLog(@"fileUrlString.....%@",fileUrlString);
//    fileUrlString = [fileUrlString stringByAppendingString:[dic[@"filename"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"fileUrlString.....%@",fileUrlString);
//    NSURL *fileURL = [NSURL URLWithString:fileUrlString];
//    NSLog(@"qqqqq.....%@",fileURL);
//
//    NSString *saveFileName = [NSString stringWithFormat:@"%@_%@",contentsData.idx,dic[@"filename"]];
//
//    NSData *fileData = nil;
//    NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),saveFileName];
//    fileData = [NSData dataWithContentsOfURL:fileURL];
//    NSLog(@"fileData length.....%d",[fileData length]);
//    [fileData writeToFile:cachefilePath atomically:YES];
//
//    NSURL *tempURL = [NSURL fileURLWithPath:cachefilePath];
//    NSLog(@"cachefilePath.....%@",cachefilePath);
//    NSLog(@"tempURL.....%@",tempURL);
//
//
//
//    NSString *hwpUrl = [NSString stringWithFormat:@"db-2z06lztlavpszkt://%@",tempURL];
//    NSString *polarisUrl = [NSString stringWithFormat:@"db-76y0qkvvslf5i4d://%@",tempURL];
//    BOOL isInstalled = [[UIApplication sharedApplication]openURL:[NSURL URLWithString:hwpUrl]]; // PorlarisOffice = db-76y0qkvvslf5i4d // 한글 db-2z06lztlavpszkt
//    if(!isInstalled){
//        BOOL isInstalled2 = [[UIApplication sharedApplication]openURL:[NSURL URLWithString:polarisUrl]];
//
//        if(!isInstalled2){
//            NSLog(@"is not installed, go appstore");
//
//
//            UIAlertView *alert;
//            alert = [[UIAlertView alloc] initWithTitle:nil message:@"첨부 파일을 보기 위한 뷰어 앱이 설치 되어 있지 않습니다. 뷰어 설치를 위해 스토어로 이동하시겠습니까?" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
//            alert.tag = kInstallHWP;
//            [alert show];
//            [alert release];
//
//        }
//    }
//
//}




//
//- (void)viewHWPFile2:(id)sender{ // 암것도 안 깔려있으면 아무 실행이 안 됨.
//
//    NSDictionary *dic = contentsData.fileArray[[sender tag]];
//    NSLog(@"viewFile %@",dic);
//
//
//
//    NSData *fileData = nil;
//    NSString *saveFileName = [NSString stringWithFormat:@"%@_%@",contentsData.idx,dic[@"filename"]];
//    NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),saveFileName];
//            NSLog(@"cachepath %@",cachefilePath);
//            if([[NSFileManager defaultManager] fileExistsAtPath:cachefilePath]) {
//              NSLog(@"fileexist %@",cachefilePath);
//                fileData = [NSData dataWithContentsOfFile:cachefilePath];
//                NSLog(@"fileData length.....%d",[fileData length]);
//
////                return;
//            }
//            else{
//                NSString *fileUrlString = dic[@"url"];
//                NSLog(@"fileUrlString %@",fileUrlString);
//                fileUrlString = [fileUrlString substringToIndex:[fileUrlString length]-[dic[@"filename"]length]];
//                NSLog(@"fileUrlString.....%@",fileUrlString);
//                fileUrlString = [fileUrlString stringByAppendingString:[dic[@"filename"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//                NSLog(@"fileUrlString.....%@",fileUrlString);
//                NSURL *fileURL = [NSURL URLWithString:fileUrlString];
//                NSLog(@"qqqqq.....%@",fileURL);
//                fileData = [NSData dataWithContentsOfURL:fileURL];
//                NSLog(@"fileData length.....%d",[fileData length]);
//
////                NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/%@",NSHomeDirectory(),dic[@"filename"]];
//                [fileData writeToFile:cachefilePath atomically:YES];
//            }
//
//
////        [[NSFileManager defaultManager] createFileAtPath:cachefilePath contents:fileData attributes:nil];
//
//        NSURL *tempURL = [NSURL fileURLWithPath:cachefilePath];
//
//        UIDocumentInteractionController* docController = [UIDocumentInteractionController interactionControllerWithURL:tempURL];
//        docController.delegate = self;
//        [docController retain];
//
//
//        [docController presentOpenInMenuFromRect:CGRectMake(0.0, 144.0, 100.0, 200.0) inView:self.view animated:YES];
//
//
//
//}

- (void)viewImage:(id)sender{
    
    NSString *imageString = contentsData.contentDic[@"image"];
    NSLog(@"imageString %@",imageString);
    NSDictionary *imgDic = [imageString objectFromJSONString];
    NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][[sender tag]]];
    NSLog(@"imgUrl %@",imgUrl);
    
    
    
    //    [picker.navigationController pushViewController:photoTable animated:YES];
    //    PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][[sender tag]] image:contentImageView.image type:12 parentViewCon:self roomkey:@"" server:imgUrl];
    
    UIViewController *photoCon;
    
    NSLog(@"type %@ / COUNT %d",contentsData.contentType,(int)[[imgDic objectForKey:@"filename"]count]);
    if([contentsData.contentType isEqualToString:@"1"] || [contentsData.contentType isEqualToString:@"7"] || [contentsData.contentType isEqualToString:@"17"]){
        
            photoCon = [[PhotoTableViewController alloc]initForDownload:imgDic parent:self index:(int)[sender tag]];
        
    }
    else{
//        photoCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][[sender tag]] image:contentImageView.image type:12 parentViewCon:self roomkey:@"" server:imgUrl];
        
        photoCon = [[PhotoTableViewController alloc]initForDownload:imgDic parent:self index:0];//(int)[sender tag]];
    }
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
    
    
    [self presentViewController:nc animated:YES completion:nil];
    
    
    
}
- (void)viewReplyImage:(id)sender{
    
    //    UIButton *button = (UIButton *)sender;
    
    NSString *imageString = [[sender titleLabel]text];//[contentsData.contentDicobjectForKey:@"image"];
    NSDictionary *imgDic = [imageString objectFromJSONString];
    NSString *imgUrl = [NSString stringWithFormat:@"https://%@%@%@",imgDic[@"server"],imgDic[@"dir"],imgDic[@"filename"][0]];
    NSLog(@"imgUrl %@",imgUrl);
    

    
    UIViewController *photoCon;
    photoCon = [[PhotoTableViewController alloc]initForDownload:imgDic parent:self index:0];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoCon];
    [self presentViewController:nc animated:YES completion:nil];
    
//    PhotoViewController *photoViewCon = [[PhotoViewController alloc] initWithFileName:imgDic[@"filename"][0] image:nil type:12 parentViewCon:self roomkey:@"" server:imgUrl];
//    
//    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:photoViewCon];
//    
//    
//    [self presentViewController:nc animated:YES completion:nil];

    
    
    
}
- (void)goToNoteReplyTimeline:(id)sender{
    NSLog(@"goToNoteReplyTimeline %d,%@",(int)[sender tag],[[sender titleLabel]text]);
    
    [self.view endEditing:YES];
    [SharedAppDelegate.root settingYours:[[sender titleLabel]text] view:self.view];
    
    //    [SharedAppDelegate.root.home goToYourTimeline:[[sender titleLabel]text]];
    //    NSLog(@"parentViewCon %@",parentViewCon);
}

- (void)goToReplyTimeline:(id)sender{
    NSLog(@"gotoreplytimeline %d %@",(int)[sender tag],[[sender titleLabel]text]);
    if([sender tag]!=1)
        return;
    
    [self.view endEditing:YES];
    [SharedAppDelegate.root settingYours:[[sender titleLabel]text] view:self.view];
    
    //    [SharedAppDelegate.root.home goToYourTimeline:[[sender titleLabel]text]];
    //    NSLog(@"parentViewCon %@",parentViewCon);
}
- (void)goToYourTimeline:(id)sender{
    
    if(![contentsData.writeinfoType isEqualToString:@"1"])
        return;
    
    [self.view endEditing:YES];
    [SharedAppDelegate.root settingYours:[[sender titleLabel]text] view:self.view];
    
    //    [SharedAppDelegate.root.home goToYourTimeline:[[sender titleLabel]text]];
    //    NSLog(@"parentViewCon %@",parentViewCon);
}
- (void)getReply:(BOOL)arriveNew {
    
    NSLog(@"arrivenew %@",arriveNew?@"YES":@"nO");
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    [MBProgressHUD showHUDAddedTo:myTable label:nil animated:YES];
    
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/directmsg.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                contentsData.idx,@"contentindex",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameter %@",parameters);
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/directmsg.lemp" parameters:parameters];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"2");
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [MBProgressHUD hideHUDForView:myTable animated:YES];
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            
            NSDictionary *dic = resultDic[@"messages"][0];
            //            contentsData.idx = dic[@"contentindex"];  //[[imageArrayobjectatindex:i]objectForKey:@"image"];
            contentsData.writeinfoType = dic[@"writeinfotype"];
            contentsData.personInfo = [dic[@"writeinfo"]objectFromJSONString];
            
            //                contentsData.likeCountUse = [[dicobjectForKey:@"goodcount_use"]intValue];
            contentsData.currentTime = resultDic[@"time"];
            contentsData.time = dic[@"operatingtime"];
            contentsData.writetime = dic[@"writetime"];
            
            //                NSLog(@"lastInteger %d",lastInteger);
            
            contentsData.profileImage = dic[@"uid"]!=nil?dic[@"uid"]:@"";
            //            contentsData.deletePermission = [resultDic[@"delete"]intValue];
            contentsData.readArray = dic[@"readcount"];
            //                    contentsData.group = [dic[@"groupname"];
            //                    contentsData.targetname = [dicobjectForKey:@"targetname"];
            contentsData.notice = dic[@"notice"];
            contentsData.targetdic = dic[@"target"];
            //                    contentsData.company = [dicobjectForKey:@"companyname"];
            
            NSDictionary *contentDic = [dic[@"content"][@"msg"]objectFromJSONString];
            //                NSLog(@"contentDic %@",contentDic);
            contentsData.contentDic = contentDic;
            contentsData.pollDic = [dic[@"content"][@"poll_data"]objectFromJSONString];
            contentsData.fileArray = [dic[@"content"][@"attachedfile"]objectFromJSONString];
            NSLog(@"contentsDAta.pollDic %@",contentsData.pollDic);
            //                    contentsData.imageString = [contentDicobjectForKey:@"image"];
            //                    contentsData.content = [contentDicobjectForKey:@"msg"];
            //                    contentsData.where = [contentDicobjectForKey:@"location"];
            contentsData.contentType = dic[@"contenttype"];
            contentsData.type = dic[@"type"];
            contentsData.likeCount = [dic[@"goodmember"]count];
            contentsData.likeArray = dic[@"goodmember"];
            contentsData.replyCount = [dic[@"replymsgcount"]intValue];
            contentsData.replyArray = dic[@"replymsg"];
            if (arriveNew == NO) {
                [self.view endEditing:YES];
            }
            contentsData.sub_category = dic[@"sub_category"];
            
            if(dic[@"noticeyn"] != nil && [dic[@"noticeyn"]length]>0){
                if(noticeyn){
                    noticeyn = nil;
                }
                noticeyn = [[NSString alloc]initWithFormat:@"%@",dic[@"noticeyn"]];
            }
                         
#ifdef Batong
            if(![contentsData.sub_category isKindOfClass:[NSNull class]] && [contentsData.sub_category length]>1){
            NSMutableArray *subArray = (NSMutableArray *)[contentsData.sub_category componentsSeparatedByString:@","];
            NSLog(@"subArray %@",subArray);
            for(int i = 0; i < [subArray count]; i++){
                if([subArray[i] length]<1)
                    [subArray removeObjectAtIndex:i];
            }
                
                spgLabel.frame = CGRectMake(320-5,0,0,0);
                hpgLabel.frame = CGRectMake(320-5,0,0,0);
                nbgLabel.frame = CGRectMake(320-5,0,0,0);
            
            for(NSString *substring in subArray){
                if([substring isEqualToString:@"NBG"]){
                    nbgLabel.frame = CGRectMake(320-10-30,10,30,15);
                    hpgLabel.frame = CGRectMake(320-10-30,10,0,0);
                    spgLabel.frame = CGRectMake(320-10-30,10,0,0);
                    nbgLabel.text = @"NBG";
                }
            }
            
            for(NSString *substring in subArray){
                if([substring isEqualToString:@"HPG"]){
                    hpgLabel.frame = CGRectMake(nbgLabel.frame.origin.x-30-5,10,30,15);
                    spgLabel.frame = CGRectMake(nbgLabel.frame.origin.x-30-5,10,0,0);
                    hpgLabel.text = @"HPG";
                }
            }
            
            for(NSString *substring in subArray){
                if([substring isEqualToString:@"SPG"]){
                    spgLabel.frame = CGRectMake(hpgLabel.frame.origin.x-30-5,10,30,15);
                    spgLabel.text = @"SPG";
                }
            }
            }
#endif
                
            
            NSDictionary *tDic = [contentsData.targetdic objectFromJSONString];
            
            if([contentsData.contentType isEqualToString:@"7"]){
                
                NSDictionary *messagesDic =  resultDic[@"messages"][0];
                
                NSLog(@"myuid %@",contentsData.profileImage);
                if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID])
                {
                    self.title = @"보낸쪽지";
                    [readArray setArray:messagesDic[@"readcount"]];
                    
                    [replyArray setArray:[messagesDic[@"content"][@"msg"]objectFromJSONString][@"to"]];
                    
                }
                else{
                    self.title = @"받은쪽지";
                    
                    [readArray removeAllObjects];
                    [replyArray removeAllObjects];
                }
                NSLog(@"readArray %@",readArray);
                NSLog(@"replyArray %@",replyArray);
                
                
                if([messagesDic[@"favorite"]isEqualToString:@"0"]){
                    if([contentsData.contentType isEqualToString:@"7"])
                        [favButton setBackgroundImage:[UIImage imageNamed:@"button_note_detail_bookmark.png"] forState:UIControlStateNormal];
                    else{
#ifdef BearTalk
                        
                        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_off.png"] forState:UIControlStateNormal];
#else
                        [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_dft.png"] forState:UIControlStateNormal];
#endif
                    }
                    favButton.tag = kNotFavorite;

                }
                else if([messagesDic[@"favorite"]isEqualToString:@"1"]){

                    
                    if([contentsData.contentType isEqualToString:@"7"])
                        [favButton setBackgroundImage:[UIImage imageNamed:@"button_note_detail_bookmark_selected.png"] forState:UIControlStateNormal];
                    else{
#ifdef BearTalk
                        
                        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_on.png"] forState:UIControlStateNormal];
#else
                        [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_prs.png"] forState:UIControlStateNormal];
#endif
                    }
                    favButton.tag = kFavorite;
                    

                }
                else if([messagesDic[@"favorite"]isEqualToString:@"2"]){
                    [favButton setBackgroundImage:nil forState:UIControlStateNormal];
                    favButton.tag = kNothing;
                    
                }
                
                
                
            }
            else{
                
                //            if(currentTime){
                //                [currentTime release];
                //                currentTime = nil;
                //            }
                //
                //            currentTime = [[NSString alloc]initWithFormat:@"%@",[resultDic @"time"]];
                
                if([contentsData.contentType isEqualToString:@"8"]){
                    self.title = @"그룹일정";
                }
                else if([contentsData.contentType isEqualToString:@"9"]){
                    if([tDic[@"category"]isEqualToString:@"3"]){
                        self.title = @"개인일정";
                    }
                    else if([tDic[@"category"]isEqualToString:@"2"]){
                        self.title = @"소셜일정";
                    }
                }
                else{
                    
                    self.title = tDic[@"categoryname"];
                    
                    if([contentsData.contentType isEqualToString:@"11"]){
                        self.title = @"Q&A";
                    }
                    else if([contentsData.contentType isEqualToString:@"14"]){
                        self.title = @"배송요청";
                    }
                }
                NSDictionary *messagesDic =  resultDic[@"messages"][0];
                
                
                [readArray setArray:messagesDic[@"readcount"]];
                
                NSLog(@"readArray %@",readArray);
                
                [likeArray setArray:messagesDic[@"goodmember"]];
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
                    [replyArray setArray:messagesDic[@"replymsg"]];
                } else {
                    [replyArray setArray:[[messagesDic[@"replymsg"] reverseObjectEnumerator] allObjects]];
                }
                NSLog(@"replyArray%@",replyArray);
                NSString *readCount = [NSString stringWithFormat:@"%d명 읽음 ",(int)[readArray count]];
#ifdef BearTalk
#else
                NSString *notice;
                if([messagesDic[@"replynotice"]isEqualToString:@"0"])
                    notice = @"(댓글 알림 꺼짐)";
                else
                    notice = @"(댓글 알림 켜짐)";
                
#endif
                
                if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
                    [readLabel performSelectorOnMainThread:@selector(setText:) withObject:readCount waitUntilDone:NO];
                    readLabel.hidden = NO;
                }
                else if([contentsData.contentType isEqualToString:@"9"] && [tDic[@"category"]isEqualToString:@"3"]){
                    readLabel.hidden = YES;
                }
                else if([contentsData.contentType isEqualToString:@"9"] && [tDic[@"category"]isEqualToString:@"2"]){
                    [readLabel performSelectorOnMainThread:@selector(setText:) withObject:[@"|   " stringByAppendingString:readCount] waitUntilDone:NO];
                    readLabel.hidden = NO;
                }
                else if([contentsData.contentType isEqualToString:@"8"]){
                    
                    if([contentsData.contentDic[@"attendance"]isEqualToString:@"1"]){
                        [readLabel performSelectorOnMainThread:@selector(setText:) withObject:readCount waitUntilDone:NO];
                        readLabel.hidden = YES;
                    }
                    else{
                        readLabel.hidden = YES;
                    }
                }
                else{
                    
#ifdef BearTalk
                    
                    [readLabel performSelectorOnMainThread:@selector(setText:) withObject:readCount waitUntilDone:NO];
#else
                    [readLabel performSelectorOnMainThread:@selector(setText:) withObject:[readCount stringByAppendingString:notice] waitUntilDone:NO];
#endif
                    readLabel.hidden = NO;
                }
                
                
                if([contentsData.writeinfoType isEqualToString:@"0"]){
                    readLabel.hidden = YES;
                }
                
                
                NSLog(@"favorite %@",messagesDic[@"favorite"]);
                if([messagesDic[@"favorite"]isEqualToString:@"0"]){
                    if([contentsData.contentType isEqualToString:@"7"])
                        [favButton setBackgroundImage:[UIImage imageNamed:@"button_note_detail_bookmark.png"] forState:UIControlStateNormal];
                    else{
#ifdef BearTalk
                        
                        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_off.png"] forState:UIControlStateNormal];
#else
                        [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_dft.png"] forState:UIControlStateNormal];
#endif
                    }
                    favButton.tag = kNotFavorite;
                }
                else if([messagesDic[@"favorite"]isEqualToString:@"1"]){
                    if([contentsData.contentType isEqualToString:@"7"])
                        [favButton setBackgroundImage:[UIImage imageNamed:@"button_note_detail_bookmark_selected.png"] forState:UIControlStateNormal];
                    else{
#ifdef BearTalk
                        
                        [favButton setBackgroundImage:[UIImage imageNamed:@"btn_bookmark_on.png"] forState:UIControlStateNormal];
#else
                        [favButton setBackgroundImage:[UIImage imageNamed:@"bookmark_btn_prs.png"] forState:UIControlStateNormal];
#endif
                    }
                    favButton.tag = kFavorite;
                    
                }
                else if([messagesDic[@"favorite"]isEqualToString:@"2"]){
                    [favButton setBackgroundImage:nil forState:UIControlStateNormal];
                    favButton.tag = kNothing;
                    
                }
#ifdef GreenTalk
                
                //                if([contentsData.writeinfoType isEqualToString:@"0"]){
                //
                //                    favButton.hidden = YES;
                //                }
                //                else if([contentsData.contentType isEqualToString:@"1"]){
                //                    if([contentsData.writeinfoType isEqualToString:@"1"]){
                favButton.frame = CGRectMake(320-29-10, 7, 29, 29);
                //                    favButton.hidden = NO;
                [favButton setBackgroundImage:[UIImage imageNamed:@"button_social_share.png"] forState:UIControlStateNormal];
                //                    }
                //                    else{
                //                        favButton.hidden = YES;
                //                    }
                //                }
                //                else{
                //                    favButton.hidden = YES;
                //                }
                
#endif
                
                
                if([contentsData.contentType isEqualToString:@"8"] || [contentsData.contentType isEqualToString:@"9"]){
                    [self checkNoti:contentsData.contentDic];
                }
                
                if (arriveNew == YES && [contentsData.contentType intValue] < 5) {
                    if([self.parentViewCon isKindOfClass:[HomeTimelineViewController class]])
                        [(HomeTimelineViewController *)self.parentViewCon reloadTimeline:contentsData.idx dic:messagesDic];
                    
                    
                    if([self.parentViewCon isKindOfClass:[SocialSearchViewController class]])
                        [(SocialSearchViewController *)self.parentViewCon reloadTimeline:contentsData.idx dic:messagesDic];
                    
                    OLGhostAlertView *toast = [[OLGhostAlertView alloc] initWithTitle:@"새로운 댓글이 등록되었습니다."];
                    if ([replyTextView isFirstResponder]) {
                        toast.position = OLGhostAlertViewPositionCenter;
                    } else {
                        toast.position = OLGhostAlertViewPositionBottom;
                    }
                    toast.style = OLGhostAlertViewStyleDark;
                    toast.timeout = 2.0;
                    toast.dismissible = YES;
                    [toast show];
//                    [toast release];
                }
                
            }
            
            if (arriveNew == NO) {
                if([contentsData.type isEqualToString:@"5"]){
                    
                    replyView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 0);
                    photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 120, 320, 120);
                    //                myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-self.tabBarController.tabBar.frame.size.height);
                    replyView.hidden = YES;
                    //                CGRect frame = myTable.frame;
                    //                frame.size.height += 40;
                    //                myTable.frame = frame;
                    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-replyView.frame.size.height+1);
                    
                    
#if defined(Batong) || defined(BearTalk)
                    
                    aCollectionView.hidden = YES;

                    
                    aCollectionView.frame = CGRectMake(0, self.view.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);

                    NSLog(@"aCollectionView3 %@",aCollectionView);
                    paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
            
#endif
                    NSLog(@"replyview %@",NSStringFromCGRect(replyView.frame));
                    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
                        
                        
                        NSLog(@"11 14 groupMaster %@",groupMaster);
                        
                        if([groupMaster length]<1 || groupMaster == nil){
                            
                            
                            
                            
                        }
                        else{
                            if([groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                                
                                if([replyArray count] == 0){
                                    NSLog(@"1");
                                    //답변전 (질문 삭제)
                                    NSLog(@"here");
                                    UIButton *button;
                                    UIBarButtonItem *btnNavi;
                                    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 26, 26)
                                                         imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
                                    
                                    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                                    self.navigationItem.rightBarButtonItem = btnNavi;
//                                    [btnNavi release];
//                                    [button release];
                                }
                                else{
                                    NSLog(@"2");
                                    //답변후 (답변 수정, 답변 삭제, 질문 삭제
                                    NSLog(@"here");
                                    UIButton *button;
                                    UIBarButtonItem *btnNavi;
                                    button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 26, 26)
                                                         imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
                                    
                                    btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                                    self.navigationItem.rightBarButtonItem = btnNavi;
//                                    [btnNavi release];
//                                    [button release];
                                }
                            }
                            else{
                                
                                if([replyArray count] == 0){
                                    NSLog(@"3");
                                    //답변전 (질문 수정 / 질문 삭제
                                    NSLog(@"contentsData.profileImage %@",contentsData.profileImage);
                                    if([contentsData.profileImage isEqualToString:[ResourceLoader sharedInstance].myUID]){
                                        NSLog(@"31");
                                        
                                        UIButton *button;
                                        UIBarButtonItem *btnNavi;
                                        button = [CustomUIKit buttonWithTitle:nil fontSize:0 fontColor:nil target:self selector:@selector(editPost) frame:CGRectMake(0, 0, 26, 26)
                                                             imageNamedBullet:nil imageNamedNormal:@"etcmenu_btn.png" imageNamedPressed:nil];
                                        
                                        btnNavi = [[UIBarButtonItem alloc]initWithCustomView:button];
                                        self.navigationItem.rightBarButtonItem = btnNavi;
//                                        [btnNavi release];
//                                        [button release];
                                    }
                                    else{
                                        NSLog(@"32");
                                        
                                    }
                                }
                                else{
                                    NSLog(@"4");
                                    //답변후 (메뉴 제공 하지 않음
                                    
                                }
                            }
                            
                        }
                        
                        
                        if(photoBackgroundView.hidden == NO){
                            photoBackgroundView.frame = CGRectMake(0, replyView.frame.origin.y - 120, 320, 120);
                        }
                    }
                }
                else{
                    NSLog(@"replyHeight %f",replyHeight);
                    
#ifdef GreenTalkCustomer
                    if([contentsData.contentType isEqualToString:@"1"] && [contentsData.writeinfoType isEqualToString:@"0"]){
                        if(replyHeight == 0.0f)
                            replyHeight = originReplyHeight;
                        
                        
                        
                        replyView.frame = CGRectMake(0, self.view.frame.size.height-replyHeight, 320, replyHeight);
                        photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 120, 320, 120);
                        myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-replyView.frame.size.height+1);
                        replyView.hidden = NO;
                        NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
                        
                        
                    }
#else
                    if(replyHeight == 0.0f)
                        replyHeight = originReplyHeight;
                    
                    
                    NSLog(@"replyheight %f",replyHeight);
                    replyView.frame = CGRectMake(0, self.view.frame.size.height-replyHeight, 320, replyHeight);
                    photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 120, 320, 120);
                    myTable.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-replyView.frame.size.height+1);
                    replyView.hidden = NO;
                    NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
                    
                    
#if defined(Batong) || defined(BearTalk)
                    
                    aCollectionView.hidden = YES;

                    aCollectionView.frame = CGRectMake(0, self.view.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);

                    NSLog(@"aCollectionView4 %@",aCollectionView);
                    paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
                    
#endif
#endif

                }
            }
            
            [myTable reloadData];
            if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
                
                
                NSLog(@"mytable contentsize %@",NSStringFromCGSize(myTable.contentSize));
                
                if([replyArray count] == 0 && [groupMaster isEqualToString:[ResourceLoader sharedInstance].myUID]){
                    
                    qnaView.hidden = NO;
                    
                    preView.frame = CGRectMake(0, 130, 320, 0);
                    preView.hidden = YES;
                    qnaOptionView.frame = CGRectMake(0, CGRectGetMaxY(preView.frame)+5, 320, 90);
                    CGRect qFrame = qnaView.frame;
                    qFrame.size.height = CGRectGetMaxY(qnaOptionView.frame);
                    qnaView.frame = qFrame;
                    
                    qnaSendButton.enabled = NO;
                    [qnaSendButton setBackgroundImage:[[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
                    qnaSendLabel.textColor = [UIColor grayColor];
                    placeHolderLabel.hidden = NO;
                    
                    if(preView.frame.size.height>0)
                        qnaView.frame = CGRectMake(0, myTable.contentSize.height, 320, 310);
                    else
                        qnaView.frame = CGRectMake(0, myTable.contentSize.height, 320, 240);
                    //                                qnaView.hidden = NO;
                    myTable.contentSize = CGSizeMake(myTable.contentSize.width, CGRectGetMaxY(qnaView.frame));
                    //                                myTable.backgroundColor = [UIColor blueColor];
                }
                else{
                    qnaView.hidden = YES;
                }
                NSLog(@"qnaView hidden %@ %@",qnaView.hidden?@"YES":@"NO",NSStringFromCGRect(qnaView.frame));
                
            }
            
            if(viewReply){
                int row = 0;
                if([myTable numberOfRowsInSection:0] == [replyArray count]+2){
                    row = (int)[replyArray count]+2-1;
                }
                else{
                    row = (int)[replyArray count]+1-1;
                }
                
                if([replyArray count]>0){
                    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
                        
                        [UIView animateWithDuration: 0.35f
                                         animations: ^{
                                             [myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                                         }completion: ^(BOOL finished){
                                         }
                         ];
                        
                        
                    }
                    else{
                        [UIView animateWithDuration: 0.35f
                                         animations: ^{
                                             [myTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                                         }completion: ^(BOOL finished){
                                         }
                         ];
                    }
                    viewReply = NO;
                }
                
            }
            
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:myTable animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
}


- (void)replyNote{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@""
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionButton;
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"답장하기"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            [self cmdReplyNote];
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        actionButton = [UIAlertAction
                        actionWithTitle:@"삭제"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            [self deletePost];
                            //Do some thing here
                            [view dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
        [view addAction:actionButton];
        
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"취소"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
    
    else{
        UIActionSheet *actionSheet;
        actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"취소"
                                    destructiveButtonTitle:nil otherButtonTitles:@"답장하기", @"삭제", nil];
        
        [actionSheet showInView:SharedAppDelegate.window];
        actionSheet.tag = kReply;
    }
}

- (void)cmdReplyNote{
    NSDictionary *dic = [SharedAppDelegate.root searchContactDictionary:contentsData.profileImage];
    if ([dic count] > 0) {
        SendNoteViewController *post = [[SendNoteViewController alloc]initWithStyle:1];//WithViewCon:self];
        UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:post];
        post.title = @"쪽지 보내기";
        [post saveArray:[NSArray arrayWithObjects:dic,nil]];
        //                [SharedAppDelegate.root returnTitle:post.title viewcon:post noti:NO alarm:NO];
        [self presentViewController:nc animated:YES completion:nil];
//        [post release];
//        [nc release];
    } else {
        [SVProgressHUD showErrorWithStatus:@"대상이 존재하지 않습니다!"];
    }
    
}

- (void)yourInfo:(id)sender{
    NSLog(@"personInfo image %@",contentsData.personInfo[@"image"]);
    [SharedAppDelegate.root settingYours:contentsData.profileImage view:self.view];
}

- (void)checkNoti:(NSDictionary *)dic{
    NSLog(@"checkNoti %@",dic);
    
    //    if([contentsData.profileImage isEqualToString:myUID])
    //        return;
    
    if([contentsData.contentType isEqualToString:@"9"])
        [self regiNoti:dic];
    
    if([dic[@"attendance"]isEqualToString:@"0"]){ // member check no
        
        NSLog(@"member check no");
        [self regiNoti:dic];
    }
    else{
        NSLog(@"member check YES");
        BOOL isAttend = NO;
        for(int i = 0; i < [readArray count]; i++){
            NSDictionary *readdic = [readArray[i]objectFromJSONString];
            if([readdic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID])
            {
                
                if([readdic[@"attendance"]isEqualToString:@"2"]){
                    isAttend = YES;
                }
            }
        }
        if(isAttend){
            NSLog(@"isAttend");
            [self regiNoti:dic];
            
        }
        
        
    }
}

- (void)regiNoti:(NSDictionary *)dic{
    
    [SharedAppDelegate.root cancelNoti:contentsData.idx];
    
    //    int calculate = [contentsData.time intValue]- 60 * 10;
    //    [SharedAppDelegate.root regiNoti:calculate title:dic[@"scheduletitle"] idx:contentsData.idx sub:@"10"];
    
    if([dic[@"alarm"]intValue]>0)
    {
        int calculate = [contentsData.time intValue]- 60 * [dic[@"alarm"]intValue];
        [SharedAppDelegate.root regiNoti:calculate title:dic[@"scheduletitle"] idx:contentsData.idx sub:dic[@"alarm"]];
    }
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    NSLog(@"keyboardWasShwo %f",replyView.frame.size.height);
    
    NSDictionary *info = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect endFrame;
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    //    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    
    //    CGFloat currentKeyboardHeight;
    currentKeyboardHeight = endFrame.size.height;
    
    
#if defined(Batong) || defined(BearTalk)
    
    NSLog(@"showEmoticonView %@",showEmoticonView?@"YES":@"NO");
//    if(showEmoticonView == YES){
//        
//        
//    }
//    else{
    
        [UIView animateWithDuration:animationDuration
                              delay:0
                            options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             CGRect barFrame = replyView.frame;
                             NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
                             barFrame.origin.y = self.view.frame.size.height - barFrame.size.height - currentKeyboardHeight;
                             replyView.frame = barFrame;// its final location
                             NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
                             myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
                             
                             aCollectionView.hidden = NO;
#ifdef BearTalk
                             aCollectionView.frame = CGRectMake(0, CGRectGetMaxY(replyView.frame), aCollectionView.frame.size.width, aCollectionView.frame.size.height);
#else
                             aCollectionView.frame = CGRectMake(0, CGRectGetMaxY(replyView.frame)+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
#endif
                             NSLog(@"aCollectionView5 %@",aCollectionView);
                             paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
                             photoBackgroundView.frame = CGRectMake(0, replyView.frame.origin.y - 120, 320, 120);
                         } completion:nil];
        
    
    NSLog(@"replyview %@",NSStringFromCGRect(replyView.frame));

    
//    }
    return;
#endif
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
        myTable.contentSize = CGSizeMake(myTable.contentSize.width, myTable.contentSize.height+currentKeyboardHeight);
        
    }
    // 416
    //    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey]doubleValue]
    //                     animations:^{
    //                         replyView.frame = CGRectMake(0, self.view.frame.size.height-replyView.frame.size.height-currentKeyboardHeight, 320, replyView.frame.size.height);
    //                         photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 123, 320, 123);
    //                         myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
    //                     }];
    //    NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         replyView.frame = CGRectMake(0, self.view.frame.size.height-replyView.frame.size.height-currentKeyboardHeight, 320, replyView.frame.size.height);
                         photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 120, 320, 120);
                         myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y+1);
                         
                         showEmoticonView = NO;
                         
                         aCollectionView.hidden = YES;
                         aCollectionView.frame = CGRectMake(0, self.view.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
                         NSLog(@"aCollectionView6 %@",aCollectionView);
                         paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
                         
                     } completion:nil];
    NSLog(@"replyview %@",NSStringFromCGRect(replyView.frame));
    //    myTable.contentSize = CGSizeMake(320, myTable.contentSize.height+currentKeyboardHeight);
    //    NSLog(@"keyboardWasShwon %f",scrollView.contentSize.height);
    
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    //    if([replyTextView isFirstResponder])
    //        return;
    NSLog(@"keyboardWillHide %f",replyHeight);
    NSLog(@"keyboardWillHide %f",replyTextViewBackground.frame.size.height);

    
    if(replyHeight == 0.0f)
        replyHeight = originReplyHeight;
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
        replyHeight = 0.0f;
    
#ifdef GreenTalkCustomer
    
    if([contentsData.contentType isEqualToString:@"1"] && [contentsData.writeinfoType isEqualToString:@"0"]){
    }else{
        replyHeight = 0.0f;
    }
#endif
    
    NSDictionary *info = [noti userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect endFrame;
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&endFrame];
    
    //    NSValue *value = info[UIKeyboardFrameEndUserInfoKey];
    //    CGFloat currentKeyboardHeight;
    currentKeyboardHeight = endFrame.size.height;
    // 416
    

    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
        myTable.contentSize = CGSizeMake(myTable.contentSize.width, myTable.contentSize.height-currentKeyboardHeight);
        
    }
    
    [UIView animateWithDuration:animationDuration
                          delay:0
                        options:(animationCurve << 16)|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         replyView.frame = CGRectMake(0, self.view.frame.size.height-replyHeight, 320, replyHeight);
                         replyTextViewBackground.frame = CGRectMake(41, 9, 220-4, replyTextViewBackground.frame.size.height);
                         photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 120, 320, 120);
                         myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y+1);
                         NSLog(@"replyview rect %@",NSStringFromCGRect(replyView.frame));
                         NSLog(@"replyTextViewBackground rect %@",NSStringFromCGRect(replyTextViewBackground.frame));
                         
                   
#ifdef BearTalk
                         
                         emoticonButtonBackground.frame = CGRectMake(16+24+3, 13, 24, 24);
                         replyTextViewBackground.frame = CGRectMake(CGRectGetMaxX(emoticonButtonBackground.frame)+6, 8, labelSend.frame.origin.x - 3 - (CGRectGetMaxX(emoticonButtonBackground.frame)+6), replyView.frame.size.height - 8*2);
                         
                         labelSend.frame = CGRectMake(replyView.frame.size.width - 16 - 53, replyTextViewBackground.frame.origin.y, 53, replyTextViewBackground.frame.size.height);
                         aCollectionView.hidden = YES;
                         aCollectionView.frame = CGRectMake(0, self.view.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
                         NSLog(@"aCollectionView7 %@",aCollectionView);
                         NSLog(@"replyview rect %@",NSStringFromCGRect(replyView.frame));
                         NSLog(@"emoticonButtonBackground rect %@",NSStringFromCGRect(emoticonButtonBackground.frame));
                         paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
                         
#elif defined(Batong)
                         emoticonButtonBackground.frame = CGRectMake(41, emoticonButtonBackground.frame.origin.y, 33, emoticonButtonBackground.frame.size.height);
                         emoticonButtonImage.frame = CGRectMake(emoticonButtonBackground.frame.size.width/2-16/2, emoticonButtonBackground.frame.size.height/2-15/2, 16, 15);
                         
                         replyTextViewBackground.frame = CGRectMake(CGRectGetMaxX(emoticonButtonBackground.frame)+4, 9, 220-33-4, replyTextViewBackground.frame.size.height);
                         aCollectionView.hidden = YES;
                         aCollectionView.frame = CGRectMake(0, self.view.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
                         NSLog(@"aCollectionView7 %@",aCollectionView);
                         paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
#endif
                         
                         btnEmoticon.frame = CGRectMake(0,0,emoticonButtonBackground.frame.size.width,emoticonButtonBackground.frame.size.height);
                     } completion:nil];
    
    //    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey]doubleValue]
    //                     animations:^{
    //                         replyView.frame = CGRectMake(0, self.view.frame.size.height-replyHeight, 320, replyHeight);
    //                         photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 123, 320, 123);
    //                         myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
    //                     }];
    NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
    //    myTable.contentSize = CGSizeMake(320, myTable.contentSize.height-currentKeyboardHeight);
    //    NSLog(@"keyboardWillHide %f",scrollView.contentSize.height);
    
}
# pragma - TextView Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    NSLog(@"currentKeyboard %f",currentKeyboardHeight);
    NSLog(@"myTable %@",NSStringFromCGSize(myTable.contentSize));
    
    
#if defined(Batong) || defined(BearTalk)
    [placeHolderLabel setHidden:YES];
    if(showEmoticonView){
        showEmoticonView = NO;
        [textView becomeFirstResponder];
        
        
    }
    return;
#endif
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
    {
        
        [textView becomeFirstResponder];
        NSString *newString = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"newString length %@",newString);
        
        if([newString length]<1){
            
            qnaSendButton.enabled = NO;
            [qnaSendButton setBackgroundImage:[[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
            qnaSendLabel.textColor = [UIColor grayColor];
        }
        else{
            qnaSendButton.enabled = YES;
            [qnaSendButton setBackgroundImage:[[UIImage imageNamed:@"button_confirm_id.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
            qnaSendLabel.textColor = [UIColor whiteColor];
            
        }
        //    [sendButton setEnabled:YES];
        [placeHolderLabel setHidden:YES];
        NSLog(@"currentKeyboard %f",currentKeyboardHeight);
        
        [myTable setContentOffset:CGPointMake(0, qnaView.frame.origin.y)];
        [myTable setContentSize:CGSizeMake(myTable.contentSize.width, preView.frame.size.height+myTable.contentSize.height+currentKeyboardHeight)];
        return;
    }
    
    [textView becomeFirstResponder];
    NSString *newString = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"newString length %@",newString);
    NSLog(@"selectedImageData length %d",(int)[selectedImageData length]);
#ifdef BearTalk
#else
    if([newString length]<1){
        if([selectedImageData length]>0)
            [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
        else
            [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
    }
    else
        [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
#endif
    //    [sendButton setEnabled:YES];
    [placeHolderLabel setHidden:YES];
    
    
    
    
    float keyboardHiddenHeight = self.view.frame.size.height - replyView.frame.size.height;
    float keyboardShownHeight = self.view.frame.size.height - currentKeyboardHeight - replyView.frame.size.height;
    
    if(myTable.contentSize.height > keyboardHiddenHeight) {
        [myTable setContentOffset:CGPointMake(0, myTable.contentOffset.y + currentKeyboardHeight)];
    } else if(myTable.contentSize.height > keyboardShownHeight) {
        
        [myTable setContentOffset:CGPointMake(0, myTable.contentOffset.y + (myTable.contentSize.height - keyboardShownHeight))];
    }
    
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSString *newString = [textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"newString length %@",newString);
    NSLog(@"selectedImageData length %d",(int)[selectedImageData length]);
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
        if([newString length]<1){
            
            qnaSendButton.enabled = NO;
            [qnaSendButton setBackgroundImage:[[UIImage imageNamed:@"imageview_login_textfield_background_grayfull.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
            qnaSendLabel.textColor = [UIColor grayColor];
        }
        else{
            qnaSendButton.enabled = YES;
            [qnaSendButton setBackgroundImage:[[UIImage imageNamed:@"button_confirm_id.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:30] forState:UIControlStateNormal];
            qnaSendLabel.textColor = [UIColor whiteColor];
            
        }
    }
    else{
#ifdef BearTalk
#else
        if([newString length]<1){
            if([selectedImageData length]>0)
                [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
            else
                [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
        }
        else
            [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
#endif
    }
    
    
    NSInteger oldLineCount = msgLineCount;
    
    NSInteger lineCount = (NSInteger)((textView.contentSize.height - 16) / textView.font.lineHeight);
    NSLog(@"textview.contentsize.height %f",textView.contentSize.height);
    NSLog(@"msgLineCount %d lineCount %d oldLineCount %d",(int)msgLineCount,(int)lineCount,(int)oldLineCount);
    
    if (msgLineCount != lineCount) {
        if (lineCount > MAX_MESSAGEEND_LINE)
            msgLineCount = MAX_MESSAGEEND_LINE;
        else
            msgLineCount = lineCount;
    }
    NSLog(@"msgLineCount %d lineCount %d oldLineCount %d",(int)msgLineCount,(int)lineCount,(int)oldLineCount);
    
    if (msgLineCount != oldLineCount)
        [self viewResizeUpdate:msgLineCount];
    
    [SharedFunctions adjustContentOffsetForTextView:textView];
    [textView scrollRangeToVisible:textView.selectedRange];
}

- (void)viewResizeUpdate:(NSInteger)lineCount
{
#ifdef GreenTalkCustomer
    if([contentsData.contentType isEqualToString:@"1"] && [contentsData.writeinfoType isEqualToString:@"0"]){
        
    }else{
        replyHeight = 0.0f;
        return;
    }
#endif
    /****************************************************************
     작업자 : 박형준
     작업일자 : 2012/06/04
     작업내용 : 채팅 입력창 동작 제어 - 입력창에 입력된 라인 수량에 따른 입력창 및 관련뷰 크기 조절 수행
     param	- lineCount(NSInteger) : 현재 라인 수
     연관화면 : 채팅
     ****************************************************************/
    
    NSLog(@"1");
    if (lineCount > MAX_MESSAGEEND_LINE)
        return;
    NSLog(@"2");
    
    lineCount--;
    NSLog(@"line %d",(int)lineCount);
    
    
    CGRect viewFrame = replyView.frame;
    NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
    viewFrame.size.height = g_viewSizeHeight[lineCount];
    if([replyTextView isFirstResponder]) {
        NSLog(@"3");
        viewFrame.origin.y = self.view.frame.size.height - currentKeyboardHeight - g_viewSizeHeight[lineCount];
    } else {
        NSLog(@"4");
        viewFrame.origin.y = self.view.frame.size.height - g_viewSizeHeight[lineCount];
    }
    NSLog(@"5");
    CGRect textFrame = replyTextView.frame;
    textFrame.size.height = g_textSizeHeight[lineCount];
    
    NSLog(@"6");
    CGRect areaFrame = replyTextViewBackground.frame;
    areaFrame.size.height = g_areaSizeHeight[lineCount];
    
    NSLog(@"7");
    isResizing = YES;
    
    NSLog(@"8");
    
    if(!([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])){
        [replyView setFrame:viewFrame];
        [replyTextViewBackground setFrame:areaFrame];
    }
    [replyTextView setFrame:textFrame];
    photoBackgroundView.frame = CGRectMake(0,replyView.frame.origin.y - 120, 320, 120);
    myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y+1);
    //                     }
    //                     completion:^(BOOL finished){
    //                         // 리사이징 해제.
    isResizing = NO;
    //                     }];
    
    NSLog(@"9");
    replyHeight = replyView.frame.size.height;
    NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
    
    if(replyHeight == 0)
        replyHeight = originReplyHeight;
    
    
    if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"])
        replyHeight = 0.0f;
    
    
    labelSend.frame = CGRectMake(replyView.frame.size.width - 16 - 53, 8, 53, replyView.frame.size.height - 8*2);
    sendButton.frame = CGRectMake(0, 0, labelSend.frame.size.width, labelSend.frame.size.height);
    
    NSLog(@"viewResizeUpdate %f",replyView.frame.size.height);
    NSLog(@"viewResizeUpdate %f",replyTextViewBackground.frame.size.height);
}

- (void)goodMember:(id)sender
{
    if([likeArray count]<1)
        return;
    //    if(contentsData.likeCount==0)
    //        return;
    //
    //    NSLog(@"goodMember");
    if(![contentsData.type isEqualToString:@"5"]){
        if([likeArray count]>0){
            
    if([self.parentViewCon respondsToSelector:@selector(pushGood:con:)])
    [(HomeTimelineViewController *)self.parentViewCon pushGood:likeArray con:self];
    //    [parentViewCon pushGood:[sender tag]];
        }
    }
    
        
    
}
- (void)sendLike:(id)sender
{
    //    if(contentsData.likeCountUse == 1){
    //        [CustomUIKit popupAlertViewOK:nil msg:@"이미 좋아요 하셨습니다."];
    //        return;
    //    }
    NSLog(@"contentsdata.idx %@",contentsData.idx);
    //    [MBProgressHUD showHUDAddedTo:sender label:nil animated:YES];
    	UIButton *button = (UIButton*)sender;
    	UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    	activity.tag = 22;
    	[activity setCenter:button.center];
    	[activity hidesWhenStopped];
    	[button addSubview:activity];
    	[activity startAnimating];
//    [activity release];
    
    BOOL alreadyLike = NO;
    NSLog(@"likeArray %@",likeArray);
    for(NSDictionary *dic in likeArray){
        if([dic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID]) {
            alreadyLike = YES;
        }
    }
    
    if(alreadyLike){
        for(int i = 0; i < [likeArray count]; i++){
            if([likeArray[i][@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID]){
                [likeArray removeObjectAtIndex:i];
            }
        }
    }
    else{
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid", @"1", @"writeinfotype",nil];
//        [likeArray addObject:dic];
       
    }
    
    
    
//    [self getReply:NO];
    
    [myTable reloadData];
    
    if ([self.parentViewCon isKindOfClass:[HomeTimelineViewController class]])
        [(HomeTimelineViewController *)self.parentViewCon sendLike:contentsData.idx sender:sender con:self];
    
    if ([self.parentViewCon isKindOfClass:[SocialSearchViewController class]])
        [(SocialSearchViewController *)self.parentViewCon sendLike:contentsData.idx sender:sender];
    
}
//- (void)sendLikeResult:(NSDictionary *)dic{
//    NSLog(@"sendLikeResult %@",dic);
//    //    [self drawLikes:[dic @"goodmember"]];
//    [likeArray setArray:dic[@"goodmember"]];
//    [myTable reloadData];
//    
//    //    if(myTable.contentSize.height > myTable.frame.size.height)
//    //    myTable.contentOffset = CGPointMake(0, myTable.contentSize.height - myTable.frame.size.height);
//}

- (void)sendReply:(id)sender
{
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    if(selectedEmoticon){
        [self sendEmoticon];
        return;
    }
    NSString *newString = [replyTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([newString length]<1 && [selectedImageData length]<1){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"내용을 입력해주세요." con:self];
        return;
    }
    if([replyTextView.text length]>4000){
        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"4000자까지 전송할 수 있습니다." con:self];
        return;
    }
    NSLog(@"replyTextView.text %@",replyTextView.text);
    NSLog(@"tagArrahy %@",tagArray);
    NSString *noticeUID;
    noticeUID = @"";
    
    for(NSDictionary *dic in tagArray){
        NSString *searchName = [NSString stringWithFormat:@"@%@",[dic[@"writeinfo"]objectFromJSONString][@"name"]];
        //        NSLog(@"searchName %@",searchName);
        NSRange range = [replyTextView.text rangeOfString:searchName];
        if (range.length > 0){
            NSLog(@"String contains");
            noticeUID = [noticeUID stringByAppendingFormat:@"%@,",dic[@"uid"]];
        }
        else {
            NSLog(@"No found in string");
        }
    }
    NSLog(@"noticeuid %@",noticeUID);
    [tagArray removeAllObjects];
    
    
    [MBProgressHUD showHUDAddedTo:sender label:nil animated:YES];
#ifdef BearTalk
#else
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
#endif
    //    [sender setEnabled:NO];
    [self.view endEditing:YES];
    [self viewResizeUpdate:1];
    
    
#if defined(Batong) || defined(BearTalk)
    
    aCollectionView.hidden = YES;
    aCollectionView.frame = CGRectMake(0, self.view.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
    NSLog(@"aCollectionView8 %@",aCollectionView);
    paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
    
#endif
    
    NSMutableURLRequest *request;
    
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/reply.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    
    //    NSString *urlString = [NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]];
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
    
    NSString *writeinfotype = @"1";
    
    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
        if([dic[@"groupnumber"]isEqualToString:[contentsData.targetdic objectFromJSONString][@"categorycode"]]){
            NSLog(@"self.groupnum %@ group attribute %@",[contentsData.targetdic objectFromJSONString][@"categorycode"],dic[@"groupattribute"]);
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < [dic[@"groupattribute"] length]; i++) {
                
                [array addObject:[NSString stringWithFormat:@"%C", [dic[@"groupattribute"]characterAtIndex:i]]];
                
            }
            
            if([array count]>2){
                if([array[2]isEqualToString:@"1"])
                    writeinfotype = @"10";
            }
        }
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                replyTextView.text,@"msg",writeinfotype,@"writeinfotype",
                                contentsData.idx,@"contentindex",noticeUID,@"noticeuid",nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameters %@",parameters);
    
    
    if([selectedImageData length]>0)
    {
        [MBProgressHUD showHUDAddedTo:photoBackgroundView label:nil animated:YES];
        
        NSString *timeStamp = [[NSString alloc]initWithFormat:@"%.0f.jpg",[[NSDate date] timeIntervalSince1970]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        //        request = [client multipartFormRequestWithMethod:@"POST" path:@"/lemp/timeline/write/reply.lemp" parameters:parameters JSONKey:@"" JSONParameter:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        //            [formData appendPartWithFileData:selectedImageData name:@"filename" fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
        //        }];
        
        
        NSDictionary *paramdic = nil;
        request = [client.requestSerializer multipartFormRequestWithMethod:@"POST" path:[baseUrl absoluteString] parameters:parameters JSONKey:@"" JSONParameter:paramdic constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            [formData appendPartWithFileData:selectedImageData name:@"filename" fileName:[NSString stringWithFormat:@"%@.jpg",timeStamp] mimeType:@"image/jpeg"];
        }];
        
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        [operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id  responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideHUDForView:sender animated:YES];
            [MBProgressHUD hideHUDForView:photoBackgroundView animated:YES];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"resultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                
                myTable.contentOffset = CGPointMake(0, myTable.contentSize.height);
                
                [likeArray setArray:resultDic[@"goodmember"]];
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
                    [replyArray setArray:resultDic[@"replymsg"]];
                } else {
                    [replyArray setArray:[[resultDic[@"replymsg"] reverseObjectEnumerator] allObjects]];
                }
                [myTable reloadData];
                
                
                if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
                    [self getReply:NO];
                }
                
                if([self.parentViewCon isKindOfClass:[HomeTimelineViewController class]])
                    [(HomeTimelineViewController *)self.parentViewCon reloadTimeline:contentsData.idx dic:resultDic];
                
                if([self.parentViewCon isKindOfClass:[SocialSearchViewController class]])
                    [(SocialSearchViewController *)self.parentViewCon reloadTimeline:contentsData.idx dic:resultDic];
                
                replyTextView.text = @"";
                [self viewResizeUpdate:1];
#ifdef BearTalk
#else
                [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
#endif
                [self closePhoto];
                
            }
            else{
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                NSLog(@"not success but %@",isSuccess);
            }
            
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:sender animated:YES];
            [MBProgressHUD hideHUDForView:photoBackgroundView animated:YES];
            //        [sender setEnabled:YES];
            
            NSLog(@"FAIL : %@",operation.error);
            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
            [HTTPExceptionHandler handlingByError:error];
        }];
        
        
        [operation start];
        
    }
    else
    {
        
        NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/reply.lemp",[SharedAppDelegate readPlist:@"was"]];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        //        request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/reply.lemp" parameters:parameters];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [MBProgressHUD hideHUDForView:sender animated:YES];
            //        [sender setEnabled:YES];
            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"ResultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                
                myTable.contentOffset = CGPointMake(0, myTable.contentSize.height);
                
                [likeArray setArray:resultDic[@"goodmember"]];
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
                    [replyArray setArray:resultDic[@"replymsg"]];
                } else {
                    [replyArray setArray:[[resultDic[@"replymsg"] reverseObjectEnumerator] allObjects]];
                }
                NSLog(@"replyArray %@",replyArray);
                [myTable reloadData];
                
                
                if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
                    [self getReply:NO];
                }
                
                if([self.parentViewCon isKindOfClass:[HomeTimelineViewController class]])
                    [(HomeTimelineViewController *)self.parentViewCon reloadTimeline:contentsData.idx dic:resultDic];
                
                if([self.parentViewCon isKindOfClass:[SocialSearchViewController class]])
                    [(SocialSearchViewController *)self.parentViewCon reloadTimeline:contentsData.idx dic:resultDic];
                
                replyTextView.text = @"";
                [self viewResizeUpdate:1];
#ifdef BearTalk
#else
                [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
#endif
            }
            else {
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:sender animated:YES];
            //        [sender setEnabled:YES];
            
            NSLog(@"FAIL : %@",operation.error);
            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
            [HTTPExceptionHandler handlingByError:error];
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            //?        [alert show];
            
        }];
        
        [operation start];
    }
}


//    [sender setEnabled:NO];



- (void)regiGroup:(id)sender{//:(NSString *)member name:(NSString *)name sub:(NSString *)sub image:(NSString *)img public:(BOOL)publicGroup{
    
    NSLog(@"regiGroup %d myAttend %d",(int)[sender tag],(int)myAttendValue);
    
    
    myAttendValue = [sender tag];
    
    if(myAttendValue == 1)
    {
        [attendButton setBackgroundImage:[UIImage imageNamed:@"button_bluecheck.png"] forState:UIControlStateNormal];
        [notAttendButton setBackgroundImage:[UIImage imageNamed:@"vote_check_dft.png"] forState:UIControlStateNormal];
    }
    else
    {
        [attendButton setBackgroundImage:[UIImage imageNamed:@"vote_check_dft.png"] forState:UIControlStateNormal];
        [notAttendButton setBackgroundImage:[UIImage imageNamed:@"button_bluecheck.png"] forState:UIControlStateNormal];
        
    }
    
}


- (void)setRegiGroup:(id)sender{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    if(myAttendValue == myOriginalAttendValue)
        return;
    
    [sender setEnabled:NO];
    //    deny.enabled = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //    [sender setEnabled:NO];
    
    NSString *pathString = [NSString stringWithFormat:@"%@%@",contentsData.contentDic[@"apidir"],contentsData.contentDic[@"apiname"]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@%@",[SharedAppDelegate readPlist:@"was"],pathString];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    NSArray *dicArray = contentsData.contentDic[@"answerinfo"];
    NSLog(@"dicArray %@",dicArray);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];// = [NSDictionary dictionaryWithObjectsAndKeys:
    //                                [NSString stringWithFormat:@"%d",[sender tag]],@"answer",[ResourceLoader sharedInstance].myUID,@"uid",
    //                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
    //                                [[dicArrayobjectatindex:0]objectForKey:@"value"],[[dicArrayobjectatindex:0]objectForKey:@"key"],
    //                                [[dicArrayobjectatindex:1]objectForKey:@"value"],[[dicArrayobjectatindex:1]objectForKey:@"key"],
    //                                nil];
    
    [parameters setObject:[NSString stringWithFormat:@"%d",(int)myAttendValue] forKey:@"answer"];
    [parameters setObject:[ResourceLoader sharedInstance].myUID forKey:@"uid"];
    [parameters setObject:[ResourceLoader sharedInstance].mySessionkey forKey:@"sessionkey"];
    NSLog(@"parameters %@",parameters);
    
    
    NSString *number = @"";
    for(NSDictionary *dic in dicArray){
        [parameters setObject:dic[@"value"] forKey:dic[@"key"]];
        if([dic[@"key"]isEqualToString:@"groupnumber"])
            number = dic[@"value"];
    }
    NSLog(@"number %@",number);
    
    NSLog(@"apiname %@",contentsData.contentDic[@"apiname"]);
    
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:pathString parameters:parameters];
    
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [sender setEnabled:YES];
        //        deny.enabled = YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            if([contentsData.contentDic[@"apiname"]isEqualToString:@"join.lemp"]){
                if(myAttendValue == 0){
                    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"완료!" con:self];
                    [SharedAppDelegate.root getGroupInfo:number regi:@"Y" add:YES];
                    
                }else
                    [CustomUIKit popupSimpleAlertViewOK:nil msg:@"완료!" con:self];
                
                
                [(CBNavigationController *)self.navigationController popViewControllerWithBlockGestureAnimated:YES];
                
                
                [SharedAppDelegate.root setNeedsRefresh:YES];
                //				UINavigationController *nc = (UINavigationController*)[SharedAppDelegate.root.mainTabBar selectedViewController];
                //				if([nc.visibleViewController isKindOfClass:[SharedAppDelegate.root.home class]])
                //                    [SharedAppDelegate.root.home refreshTimeline];
            }
            else if([contentsData.contentDic[@"apiname"]isEqualToString:@"schedulecheck.lemp"]){
                
                
                [self getReply:NO];
                
            }
            
            
            //            [self getReply];
            //            [self hideInvite:[sender tag]];
            
            
            //            [SharedAppDelegate.root.home getTimeline:@"" target:@"" type:@"2" groupnum:number];
        }
        else {
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [sender setEnabled:YES];
        
        //        [sender setEnabled:YES];
        NSLog(@"FAIL : %@",operation.error);
        [HTTPExceptionHandler handlingByError:error];
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"그룹을 만드는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        //        [alert show];
        
    }];
    
    [operation start];
    
}

- (void)cmdSingularCheck:(id)sender{
    
    NSLog(@"cmdSingularCheck");
    
    
    //    if([contentsData.pollDic[@"is_close"]isEqualToString:@"1"]){
    //        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"종료된 설문입니다."];
    //        return;
    //    }
    
    
#ifdef BearTalk
    
    UIButton *button = (UIButton *)sender;
    //    NSString *btnImage;
    [answerArray removeAllObjects];
    NSLog(@"btnArray %@",btnArray);
    
    
    
    
        for(UIButton *btn in btnArray){
            if(btn == button){
                NSLog(@"btn same");
                if(btn.selected == YES)
                {
                    btn.backgroundColor = RGB(249, 249, 249);
                    btn.selected = NO;
                    
                    [answerArray removeObject:[NSDictionary dictionaryWithObject:button.titleLabel.text forKey:@"number"]];
                }
                else
                {
                    btn.backgroundColor = BearTalkColor;
                    btn.selected = YES;
                    [answerArray addObject:[NSDictionary dictionaryWithObject:button.titleLabel.text forKey:@"number"]];
                    
                }
                
                
            }
            else{
                btn.backgroundColor = RGB(249, 249, 249);
                NSLog(@"else");
                btn.selected = NO;
                
                
            }
            

        }
    [self cmdPoll];
        
#else
    UIButton *button = (UIButton *)sender;
    //    NSString *btnImage;
    [answerArray removeAllObjects];
    NSLog(@"btnArray %@",btnArray);
    for(UIButton *btn in btnArray){
        if(btn == button){
            NSLog(@"btn same");
            if(btn.selected == YES)
            {
                btn.selected = NO;
                [btn setBackgroundImage:[UIImage imageNamed:@"radio_dft.png"] forState:UIControlStateNormal];
                [answerArray removeObject:[NSDictionary dictionaryWithObject:button.titleLabel.text forKey:@"number"]];
            }
            else
            {
                btn.selected = YES;
                [btn setBackgroundImage:[UIImage imageNamed:@"radio_prs.png"] forState:UIControlStateNormal];
                [answerArray addObject:[NSDictionary dictionaryWithObject:button.titleLabel.text forKey:@"number"]];
                
            }
            
            
        }
        else{
            NSLog(@"else");
            btn.selected = NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"radio_dft.png"] forState:UIControlStateNormal];
            
        }
    }
    
#endif
    
    NSLog(@"answerarray %@",answerArray);
    
}

- (void)cmdMultiCheck:(id)sender{
    NSLog(@"cmdCheck %d",(int)[sender tag]);
    
    //    if([contentsData.pollDic[@"is_close"]isEqualToString:@"1"]){
    //        [CustomUIKit popupAlertViewOK:nil msg:@"종료된 설문입니다."];
    //        return;
    //    }
    
    UIButton *button = (UIButton *)sender;
    
#ifdef BearTalk
    if(button.selected == YES)
    {
        button.selected = NO;
        button.backgroundColor = RGB(249,249,249);
        [answerArray removeObject:[NSDictionary dictionaryWithObject:button.titleLabel.text forKey:@"number"]];
    }
    
    else
    {
        button.selected = YES;
        button.backgroundColor = BearTalkColor;
        [answerArray addObject:[NSDictionary dictionaryWithObject:button.titleLabel.text forKey:@"number"]];
        
    }
    [self cmdPoll];
#else
    NSString *btnImage;
    
    if(button.selected == YES)
    {
        button.selected = NO;
        btnImage = [NSString stringWithFormat:@"vote_check_dft.png"];
        [answerArray removeObject:[NSDictionary dictionaryWithObject:button.titleLabel.text forKey:@"number"]];
    }
    
    else
    {
        button.selected = YES;
        btnImage = [NSString stringWithFormat:@"vote_check_prs.png"];
        [answerArray addObject:[NSDictionary dictionaryWithObject:button.titleLabel.text forKey:@"number"]];
        
    }
    [button setBackgroundImage:[UIImage imageNamed:btnImage] forState:UIControlStateNormal];
#endif
    
    
    NSLog(@"answerarray %@",answerArray);
    
}

- (void)endPoll:(id)sender
{
    
    //UIAlertView *alert;
    //    alert = [[UIAlertView alloc] initWithTitle:@"설문을 종료하시겠습니까?" message:nil delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"확인", nil];
    //    alert.tag = kEndPoll;
    //    [alert show];
    //    [alert release];
    
    [CustomUIKit popupAlertViewOK:@"설문종료" msg:@"설문을 종료하시겠습니까?" delegate:self tag:kEndPoll sel:@selector(confirmEnd) with:nil csel:nil with:nil];
}

- (void)cmdEndPoll:(NSString *)notify{
    
    NSLog(@"cmdEndPoll");
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/modifypoll.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           @"1",@"modifytype",
                           notify,@"notify",
                           contentsData.idx,@"contentindex",
                           nil];
    
    
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/modifypoll.lemp" parametersJson:param key:@"param"];
    NSLog(@"request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
            [self getReply:NO];
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [SVProgressHUD dismiss];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    [operation start];
    
}




- (void)cmdPoll{
    
    NSLog(@"cmdPoll");
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    
    //    if([contentsData.pollDic[@"is_close"]isEqualToString:@"1"]){
    //        [CustomUIKit popupSimpleAlertViewOK:nil msg:@"종료된 설문입니다."];
    //        return;
    //    }
    
    
    NSString *cancel = @"0";
#ifdef BearTalk
#else
    if([myAnswerArray count]==0){
        // 선택한 적 없음
        if([answerArray count]==0){

            [CustomUIKit popupSimpleAlertViewOK:nil msg:@"투표할 항목을 선택하세요." con:self];
            return;
        }
        
    }
    else{
        // 선택한 항목 있음
        if([answerArray count]==0){
            // 투표를 취소하였습니다.
            cancel = @"1";
            
        }
        else{
            if([answerArray isEqualToArray:myAnswerArray]){
                [CustomUIKit popupSimpleAlertViewOK:@"설문" msg:@"선택한 항목으로 이미 투표하였습니다." con:self];
                return;
                
            }
            else{
                
            }
        }
        
    }
#endif
    //    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/poll_answer.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           answerArray,@"answer",
                           contentsData.idx,@"contentindex",
                           cancel,@"cancel",
                           nil];
    
    
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/poll_answer.lemp" parametersJson:param key:@"param"];
    NSLog(@"request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
#ifdef BearTalk
#else
            if([cancel isEqualToString:@"1"])
                [CustomUIKit popupSimpleAlertViewOK:@"설문 취소" msg:@"투표를 취소하였습니다." con:self];
            else if([myAnswerArray count] == 0 && [answerArray count]>0)
                [CustomUIKit popupSimpleAlertViewOK:@"설문" msg:@"투표를 하였습니다." con:self];
            else if([myAnswerArray count]>0 && ![answerArray isEqualToArray:myAnswerArray])
                [CustomUIKit popupSimpleAlertViewOK:@"설문" msg:@"변경한 항목으로 다시 투표를 하였습니다." con:self];
#endif
            
            [self getReply:NO];
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [SVProgressHUD dismiss];
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
    
    
}
- (void)viewDetailMember:(id)sender{
    
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    [MBProgressHUD showHUDAddedTo:self.view label:nil animated:YES];
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/read/poll_answer_detail.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[ResourceLoader sharedInstance].myUID,@"uid",
                           [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                           contentsData.idx,@"contentindex",
                           nil];
    
    
    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[param JSONString]];
    NSLog(@"jsonString %@",jsonString);
    
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/read/poll_answer_detail.lemp" parametersJson:param key:@"param"];
    NSLog(@"request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            
#ifdef BearTalk
            for(NSDictionary *dic in resultDic[@"options"]){
                if([dic[@"name"]isEqualToString:[[sender titleLabel]text]]){
            [self loadEachPollMember:dic];
                }
            }
#else
            [self loadPollMember:resultDic[@"options"]];
#endif
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [SVProgressHUD dismiss];
        [HTTPExceptionHandler handlingByError:error];
        
        
    }];
    
    [operation start];
}

- (void)loadEachPollMember:(NSDictionary *)dic{
    
    NSLog(@"loadEachPollMember %@",dic);
    NSArray *array = [NSArray arrayWithObjects:dic,nil];
    PollMemberViewController *pvc = [[PollMemberViewController alloc] initWithArray:array];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:pvc];
    [self presentViewController:nc animated:YES completion:nil];
    //    [nc release];
    
    
    
}
- (void)loadPollMember:(NSArray *)array{
    
    
    PollMemberViewController *pvc = [[PollMemberViewController alloc] initWithArray:array];
    UINavigationController *nc = [[CBNavigationController alloc]initWithRootViewController:pvc];
    [self presentViewController:nc animated:YES completion:nil];
//    [nc release];
    
    
    
}
- (CGFloat)measureHeightOfUITextView:(UITextView *)textView origin:(NSString *)originText
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = originText;
        if([originText length]<1)
            textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}

//- (void)hideInvite{//:(int)tag{
//    
//    accept.hidden = YES;
//    deny.hidden = YES;
//    CGRect contentFrame = contentView.frame;
//    contentFrame.size.height -= 65;
//    contentView.frame = contentFrame;
//
//    bottomRoundImage.frame = CGRectMake(6, contentView.frame.origin.y + contentView.frame.size.height, 308, 9);
//
////    CGRect defaultFrame = defaultView.frame;
////    defaultFrame.size.height -= 70;
////    defaultView.frame = defaultFrame;
//    
//    [self getReply];
//    
//}

- (void)showRead{
    
    [SharedAppDelegate.root.home showRead:readArray con:self];
    
}

- (void)goShare{//:(id)sender{
    
    [CustomUIKit popupAlertViewOK:@"공유" msg:@"Best Practice 컨텐츠 소셜로 선택한 글을\n공유 합니다. " delegate:SharedAppDelegate.root.home tag:kShare sel:@selector(goShare:) with:contentsData.idx csel:nil with:nil];
}
- (void)goShareAgain{
    
    [CustomUIKit popupAlertViewOK:@"공유" msg:@"Best Practice 컨텐츠 소셜로 공유 된 이력이\n있는 글 입니다. 한번 더 Best Practice\n컨텐츠 소셜로 공유 하시겠습니까?" delegate:SharedAppDelegate.root.home tag:kShare sel:@selector(goShare:) with:contentsData.idx csel:nil with:nil];
}


#pragma mark - emoticon

- (void)getEmoticon
{
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
    //    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",[SharedAppDelegate readPlist:@"was"]]]];
    showEmoticonView = NO;
    NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/info/emoticon.lemp",[SharedAppDelegate readPlist:@"was"]];
    NSURL *baseUrl = [NSURL URLWithString:urlString];
    
    
    AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
    client.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    
    NSDictionary *param = @{
                            @"sessionkey" : [ResourceLoader sharedInstance].mySessionkey,
                            @"uid" : [ResourceLoader sharedInstance].myUID,
                            };
    
    //    NSString *jsonString = [NSString stringWithFormat:@"param=%@",[parameters JSONString]];
    //    NSLog(@"jsonString %@",jsonString);
    
    
    //    NSMutableURLRequest *request = [client requestWithMethod:@"POST" path:@"/lemp/info/emoticon.lemp" parametersJson:parameters key:@"param"];
    
//    NSError *serializationError = nil;
    //    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
    
    NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parametersJson:param key:@"param"];
    
    
    
    
    
    NSLog(@"request %@",request);
    AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
        NSLog(@"resultDic %@",resultDic);
        NSString *isSuccess = resultDic[@"result"];
        if ([isSuccess isEqualToString:@"0"]) {
            paging.hidden = NO;
            if(emoticonUrlArray){
//                [emoticonUrlArray release];
                emoticonUrlArray = nil;
            }
#ifdef BearTalk
            
            emoticonButtonBackground.frame = CGRectMake(16+24+3, 13, 24, 24);
            replyTextViewBackground.frame = CGRectMake(CGRectGetMaxX(emoticonButtonBackground.frame)+6, 8, labelSend.frame.origin.x - 3 - (CGRectGetMaxX(emoticonButtonBackground.frame)+6), replyView.frame.size.height - 8*2);
            
            labelSend.frame = CGRectMake(replyView.frame.size.width - 16 - 53, replyTextViewBackground.frame.origin.y, 53, replyTextViewBackground.frame.size.height);
            NSLog(@"replyview rect %@",NSStringFromCGRect(replyView.frame));
            NSLog(@"emoticonButtonBackground rect %@",NSStringFromCGRect(emoticonButtonBackground.frame));
            
#else
            emoticonButtonBackground.frame = CGRectMake(41, emoticonButtonBackground.frame.origin.y, 33, emoticonButtonBackground.frame.size.height);
            emoticonButtonImage.frame = CGRectMake(emoticonButtonBackground.frame.size.width/2-16/2, emoticonButtonBackground.frame.size.height/2-15/2, 16, 15);
            replyTextViewBackground.frame = CGRectMake(CGRectGetMaxX(emoticonButtonBackground.frame)+4, 9, 220-33-4, replyTextViewBackground.frame.size.height);
            sendButton.frame = CGRectMake(CGRectGetMaxX(replyTextViewBackground.frame)+4, 9, 50, 43);
#endif
            btnEmoticon.frame = CGRectMake(0,0,emoticonButtonBackground.frame.size.width,emoticonButtonBackground.frame.size.height);
            emoticonUrlArray = [[NSMutableArray alloc]initWithArray:resultDic[@"emoticon"]];
            paging.numberOfPages = ([emoticonUrlArray count]+7)/8;
            //            collectionView.contentSize = CGSizeMake(320*paging.numberOfPages,collectionView.frame.size.height);
            
            [aCollectionView reloadData];
            
        }
        else {
            
            NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            
            NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
            [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
        }
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"FAIL : %@",operation.error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [HTTPExceptionHandler handlingByError:error];
        
    }];
    
    
    [operation start];
}
- (void)hideAllView{
    [UIView animateWithDuration: 0.35f
                     animations: ^{
                         
                         
                         showEmoticonView = NO;
                         
                         CGRect barFrame = replyView.frame;
                         NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
                         barFrame.origin.y = self.view.frame.size.height - barFrame.size.height - 0;
                         replyView.frame = barFrame;// its final location
                         NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
                         myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
                         
                         aCollectionView.hidden = YES;
                         aCollectionView.frame = CGRectMake(0, self.view.frame.size.height+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
                         NSLog(@"aCollectionView2 %@",aCollectionView);
                         paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
                         
                         photoBackgroundView.frame = CGRectMake(0, replyView.frame.origin.y - 120, 320, 120);
                         NSLog(@"replyview %@",NSStringFromCGRect(replyView.frame));
                     }completion: ^(BOOL finished){
                     }
     ];
}

- (void)showEmoticon{
    NSLog(@"showemoticon %@",emoticonUrlArray);
    //    if(emoticonUrlArray == nil)
    //        return;
    //    else if([emoticonUrlArray count]<1)
    //        return;
    //
    
    if(showEmoticonView) // 버튼이 보이고 있음.
    {
        
        
//        [self tableTap];
    }
    else
    {
        
        showEmoticonView = YES;
        
        
        
        
        
        
//        if(currentKeyboardHeight == 0)
//            currentKeyboardHeight = 216;
//
//        if (ceil(messageTable.contentOffset.y) + self.view.frame.size.height == ceil(messageTable.contentSize.height) + 49) {
//            
//            
//            float keyboardHiddenHeight = self.view.frame.size.height - bottomBarBackground.frame.size.height;
//            float keyboardShownHeight = self.view.frame.size.height - currentKeyboardHeight - bottomBarBackground.frame.size.height;
//            
//            if(messageTable.contentSize.height > keyboardHiddenHeight) {
//                [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + currentKeyboardHeight)];
//            } else if(messageTable.contentSize.height > keyboardShownHeight) {
//                
//                [messageTable setContentOffset:CGPointMake(0, messageTable.contentOffset.y + (messageTable.contentSize.height - keyboardShownHeight))];
//            }
//            
//            
//            
//        }
//        
//        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.view endEditing:YES];
            
            NSLog(@"bottomBarBackground.frame %@",NSStringFromCGRect(replyView.frame));
            CGRect barFrame = replyView.frame;
            barFrame.origin.y = self.view.frame.size.height - barFrame.size.height - 216;
            replyView.frame = barFrame;// its final location
            NSLog(@"replyView %@",NSStringFromCGRect(replyView.frame));
            myTable.frame = CGRectMake(0, 0, 320, replyView.frame.origin.y);
            
            aCollectionView.hidden = NO;
#ifdef BearTalk
            aCollectionView.frame = CGRectMake(0, CGRectGetMaxY(replyView.frame), aCollectionView.frame.size.width, aCollectionView.frame.size.height);
#else
            aCollectionView.frame = CGRectMake(0, CGRectGetMaxY(replyView.frame)+20, aCollectionView.frame.size.width, aCollectionView.frame.size.height);
#endif
            NSLog(@"aCollectionView9 %@",aCollectionView);
            paging.frame = CGRectMake(85, CGRectGetMaxY(aCollectionView.frame), 150, 15);
            photoBackgroundView.frame = CGRectMake(0, replyView.frame.origin.y - 120, 320, 120);
            NSLog(@"replyview %@",NSStringFromCGRect(replyView.frame));
            
            
            
            
        } completion:^(BOOL finished) {
            
            
        }];
        
        
        
        
        
        
//        float keyboardHiddenHeight = self.view.frame.size.height - replyView.frame.size.height;
//        float keyboardShownHeight = self.view.frame.size.height - currentKeyboardHeight - replyView.frame.size.height;
//        
//        if(myTable.contentSize.height > keyboardHiddenHeight) {
//            [myTable setContentOffset:CGPointMake(0, myTable.contentOffset.y + currentKeyboardHeight)];
//        } else if(myTable.contentSize.height > keyboardShownHeight) {
//            
//            [myTable setContentOffset:CGPointMake(0, myTable.contentOffset.y + (myTable.contentSize.height - keyboardShownHeight))];
//        }

        
    }
    
    
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return [emoticonUrlArray count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cellForItemAtIndexPath");
    
    //    NSLog(@"mainCellForRow");
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.contentView.userInteractionEnabled = YES;
#ifdef BearTalk
    cell.backgroundColor = RGB(249, 249, 249);
    cell.contentView.backgroundColor = RGB(249, 249, 249);
#endif
//    cell.contentView.backgroundColor = [UIColor clearColor];
    UIImageView *emoticonImage;
    
    emoticonImage = (UIImageView*)[cell.contentView viewWithTag:100];
    
    if(emoticonImage == nil){
        emoticonImage = [[UIImageView alloc]init];
        emoticonImage.frame = CGRectMake(0, 0, 70, 70);
#ifdef BearTalk
        emoticonImage.frame = CGRectMake(0,0,[SharedFunctions scaleFromWidth:86],[SharedFunctions scaleFromHeight:86]);
#endif     
        emoticonImage.userInteractionEnabled = YES;
        emoticonImage.tag = 100;
        emoticonImage.contentMode = UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:emoticonImage];
//        emoticonImage.backgroundColor = [UIColor clearColor];
        emoticonImage.image = nil;
//        [emoticonImage release];
        
    }
    
    
    NSDictionary *dic = emoticonUrlArray[indexPath.row];
    NSLog(@"dic %@",dic);
    
    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@/%@",dic[@"protocol"],dic[@"server"],dic[@"dir"],dic[@"filename"]];
    
    NSString *cachefilePath = [NSString stringWithFormat:@"%@/Library/Caches/emoticon_%@",NSHomeDirectory(),dic[@"filename"]];
    NSLog(@"cachefilePath %@",cachefilePath);
    UIImage *img = [UIImage imageWithContentsOfFile:cachefilePath];
    NSLog(@"img %@",img);
    
    if(img == nil){
        
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
        NSLog(@"timeout: %f", request.timeoutInterval);
        //                    NSURLRequest *request = [client requestWithMethod:@"GET" path:nil parameters:nil];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead)
         {
             NSLog(@"progress %f",(float)totalBytesRead / totalBytesExpectedToRead);
         }];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            UIGraphicsBeginImageContext(CGSizeMake(240,240));
            [[UIImage imageWithData:operation.responseData] drawInRect:CGRectMake(0,0,240,240)];
            UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            emoticonImage.image = newImage;
            NSData *dataObj = UIImagePNGRepresentation(newImage);
            [dataObj writeToFile:cachefilePath atomically:YES];
            NSLog(@"cachefilePath %@",cachefilePath);
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [HTTPExceptionHandler handlingByError:error];
            NSLog(@"failed %@",error);
        }];
        [operation start];
        
    }
    else{
        
        emoticonImage.image = img;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
#ifdef BearTalk
    return CGSizeMake([SharedFunctions scaleFromWidth:86],[SharedFunctions scaleFromHeight:86]);
#endif
    return CGSizeMake(80, 80);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
#ifdef BearTalk
    return UIEdgeInsetsMake(0, 2, 6, 0);// t l b r
#endif
    return UIEdgeInsetsMake(25, 10, 15, 0);// t l b r
}


#ifdef BearTalk
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 2;
}

#endif
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
#ifdef BearTalk
    return 6;
#endif
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *dic = emoticonUrlArray[indexPath.row];
    NSString *imgUrl = [NSString stringWithFormat:@"%@://%@%@/%@",dic[@"protocol"],dic[@"server"],dic[@"dir"],dic[@"filename"]];
    NSLog(@"imgUrl %@",imgUrl);
    
    
    [self confirmEmoticon:imgUrl];
//    [self closePhoto];
    
}
- (void)confirmEmoticon:(NSString *)url{
    
    NSLog(@"confirmEmoticon %@",url);
    
    if(selectedImageData){
//        [selectedImageData release];
        selectedImageData = nil;
    }
    if(selectedEmoticon){
//        [selectedEmoticon release];
        selectedEmoticon = nil;
    }
    
    selectedEmoticon = [[NSString alloc]initWithFormat:@"%@",url];
    
  NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    UIImage *image = [UIImage imageWithData:imgData];
    
    photoView.frame = CGRectMake(10,10,100,100);
    photoView.image = image;
    
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    
    photoBackgroundView.hidden = NO;
    
    
    photoBackgroundView.frame = CGRectMake(0, replyView.frame.origin.y - 120, 320, 120);
  
    
#ifdef BearTalk
#else
    [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_prs.png"] forState:UIControlStateNormal];
#endif

}


- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sendEmoticon
{
    if([[SharedAppDelegate readPlist:@"was"]length]<1)
        return;
  
    
    
    
    [self.view endEditing:YES];
    
    
    [self hideAllView];
    
    
    NSString *writeinfotype = @"1";
    
    for(NSDictionary *dic in SharedAppDelegate.root.main.myList){
        if([dic[@"groupnumber"]isEqualToString:[contentsData.targetdic objectFromJSONString][@"categorycode"]]){
            NSLog(@"self.groupnum %@ group attribute %@",[contentsData.targetdic objectFromJSONString][@"categorycode"],dic[@"groupattribute"]);
            NSMutableArray *array = [NSMutableArray array];
            for (int i = 0; i < [dic[@"groupattribute"] length]; i++) {
                
                [array addObject:[NSString stringWithFormat:@"%C", [dic[@"groupattribute"]characterAtIndex:i]]];
                
            }
            
            if([array count]>2){
                if([array[2]isEqualToString:@"1"])
                    writeinfotype = @"10";
            }
        }
    }
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                [ResourceLoader sharedInstance].myUID,@"uid",
                                [ResourceLoader sharedInstance].mySessionkey,@"sessionkey",
                                replyTextView.text,@"msg",writeinfotype,@"writeinfotype",
                                contentsData.idx,@"contentindex",selectedEmoticon,@"emoticon",nil];//@{ @"uniqueid" : @"c110256" };
    NSLog(@"parameters %@",parameters);
    

        
        NSString *urlString = [NSString stringWithFormat:@"https://%@/lemp/timeline/write/reply.lemp",[SharedAppDelegate readPlist:@"was"]];
        NSURL *baseUrl = [NSURL URLWithString:urlString];
        
        
        AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:baseUrl];
        client.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [client.requestSerializer requestWithMethod:@"POST" URLString:[baseUrl absoluteString] parameters:parameters error:&serializationError];
        //        request = [client requestWithMethod:@"POST" path:@"/lemp/timeline/write/reply.lemp" parameters:parameters];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        AFHTTPRequestOperation *operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         
            
            NSDictionary *resultDic = [operation.responseString objectFromJSONString][0];
            NSLog(@"ResultDic %@",resultDic);
            NSString *isSuccess = resultDic[@"result"];
            if ([isSuccess isEqualToString:@"0"]) {
                [self closeEmoticon];
                
                myTable.contentOffset = CGPointMake(0, myTable.contentSize.height);
                [likeArray setArray:resultDic[@"goodmember"]];
                
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"ReplySort"] == 0) {
                    [replyArray setArray:resultDic[@"replymsg"]];
                } else {
                    [replyArray setArray:[[resultDic[@"replymsg"] reverseObjectEnumerator] allObjects]];
                }
                
                NSLog(@"replyArray %@",replyArray);
                [myTable reloadData];
                
                
                if([contentsData.contentType isEqualToString:@"11"] || [contentsData.contentType isEqualToString:@"14"]){
                    [self getReply:NO];
                }
                
                if([self.parentViewCon isKindOfClass:[HomeTimelineViewController class]])
                    [(HomeTimelineViewController *)self.parentViewCon reloadTimeline:contentsData.idx dic:resultDic];
                
                if([self.parentViewCon isKindOfClass:[SocialSearchViewController class]])
                    [(SocialSearchViewController *)self.parentViewCon reloadTimeline:contentsData.idx dic:resultDic];
                
                replyTextView.text = @"";
                [self viewResizeUpdate:1];
#ifdef BearTalk
#else
                [sendButton setBackgroundImage:[UIImage imageNamed:@"send_btn_dft.png"] forState:UIControlStateNormal];
#endif
                
                
            }
            else {
                NSString *msg = [NSString stringWithFormat:@"%@",resultDic[@"resultMessage"]];
                [CustomUIKit popupSimpleAlertViewOK:nil msg:msg con:self];
                NSLog(@"isSuccess NOT 0, BUT %@",isSuccess);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            //        [sender setEnabled:YES];
            
            NSLog(@"FAIL : %@",operation.error);
            //        [MBProgressHUD hideHUDForView:self.view animated:YES];
            [HTTPExceptionHandler handlingByError:error];
            //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"댓글을 받아오는 데 실패했습니다. 잠시 후 다시 시도해 주세요!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            //?        [alert show];
            
        }];
        
        [operation start];
    
}

- (void)reloadTableView{
    [self getReply:NO];
}


#pragma mark - swtableviewcell

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    
    NSLog(@"canSwipeToState");
    NSIndexPath *cellIndexPath = [myTable indexPathForCell:cell];
    if(cellIndexPath.section == 1)
        return NO;
    
    
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

- (NSArray *)rightButtons:(int)row
{
#ifdef BearTalk
#else
    return nil;
#endif
    
    if([replyArray count]==0)
        return nil;
    
    if(row < 2)
        return nil;
    
    NSDictionary *replydic = replyArray[row-2];
    
    NSLog(@"rightButtons %@",replydic);
    
    
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    if([replydic[@"uid"]isEqualToString:[ResourceLoader sharedInstance].myUID] && [replydic[@"writeinfotype"]isEqualToString:@"1"]){
    
        
        [rightUtilityButtons sw_addUtilityButtonWithColor:RGB(186, 198, 210) title:@"수정"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:RGB(255, 67, 59) title:@"삭제"];
    }
    else{
        return nil;
    }
    
    return rightUtilityButtons;
}



#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    NSLog(@"swipeableTableViewCell");
    switch (state) {
        case 0:{
            NSLog(@"utility buttons closed");
            break;
        }
        case 1:
        {
            NSLog(@"left utility buttons open");
        }
            break;
        case 2:{
            NSLog(@"right utility buttons open");
            
            break;
        }
        default:
            break;
    }
}




- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    
    
    NSIndexPath *cellIndexPath = [myTable indexPathForCell:cell];
    
    if(cellIndexPath.row < 2)
        return;
    
    NSDictionary *replydic;
        replydic = replyArray[cellIndexPath.row-2];

    
    switch (index) {
        case 0:{
            
            // edit
            [self modifyReplyAction:replydic];
        }
            break;
        case 1:
        {
            // delete
            [self deleteReplyAction:replydic];
            break;
        }
        default:
            break;
    }
}

@end
