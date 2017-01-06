//
//  CustomAlphaButton.m
//  Lemp2xx
//
//  Created by Hyemin Kim on 2016. 11. 22..
//  Copyright © 2016년 BENCHBEE Co., Ltd. All rights reserved.
//

#import "CustomAlphaButton.h"

@implementation CustomAlphaButton




- (void)setBackgroundImage:(nullable UIImage *)image forState:(UIControlState)state{
    [super setBackgroundImage:image forState:state];
    
    NSLog(@"CustomAlphaButton UIControlEventTouchUpInside");
    
    if(state == UIControlStateHighlighted) {
        [self setAlpha:0.5];
    }
    else {
        [self setAlpha:1.0];
    }
}


@end
