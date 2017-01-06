//
//  CustomProgressView.h
//  Lemp2xx
//
//  Created by HyeongJun Park on 2013. 12. 17..
//  Copyright (c) 2013년 Hyemin Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, retain) UIView *progressView;

@property (nonatomic, assign) UIColor *progressColor;
@property (nonatomic, assign) UIColor *trackColor;
@end
