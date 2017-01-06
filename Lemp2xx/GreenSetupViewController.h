//
//  GreenSetupViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 1. 6..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GreenSetupViewController : UIViewController<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    
    UIPageControl *paging;
    NSMutableArray *imageArray;
    UIImageView *profileImageView;
    UIButton *setupButton;
}

- (void)refreshSetupButton;

@end
