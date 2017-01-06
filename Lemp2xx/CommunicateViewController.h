//
//  CommunicateViewController.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2013. 11. 14..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHTabBarController.h"

@interface CommunicateViewController : MHTabBarController <MHTabBarControllerDelegate, UIAlertViewDelegate>

- (void)setCountForRightBar:(NSNumber*)count;
- (void)toggleStatus;

- (void)newCommunicate;
@end
