//
//  CustomerViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2015. 1. 7..
//  Copyright (c) 2015년 BENCHBEE Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MQMViewController : UIViewController
{
    UIButton *noteButton;
    
    UIView *transView;
    UIImageView *bottomView;
    UILabel *infoLabel;
    UILabel *titleLabel;
    UILabel *testLabel;
    UIImageView *testButtonImage;
    UIButton *testButton;
  
    
}

- (void)startTest;
- (void)setNewNoteBadge:(int)count;
- (void)settingButtonImage;

@end
