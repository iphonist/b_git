//
//  CustomProgressView.m
//  Lemp2xx
//
//  Created by HyeongJun Park on 2013. 12. 17..
//  Copyright (c) 2013년 BENCHBEE. All rights reserved.
//

#import "CustomProgressView.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>

@implementation CustomProgressView
@synthesize progressColor, trackColor, progressView, progress, cornerRadius;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // clipsToBounds is important to stop the progressView from covering the original view and its round corners
        self.clipsToBounds = YES;
		
        self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
        [self addSubview:self.progressView];
		
		self.progressColor = [UIColor blueColor];
		self.trackColor = [UIColor grayColor];
		
		self.progress = 0.0;
		self.cornerRadius = 0.0;
    }
	
    return self;
}

-(void)setProgressColor:(UIColor *)theProgressColor {
    self.progressView.backgroundColor = theProgressColor;
    progressColor = theProgressColor;
}

-(void)setTrackColor:(UIColor *)theTrackColor {
    self.backgroundColor = theTrackColor;
    trackColor = theTrackColor;
}

-(void)setProgress:(CGFloat)theProgress {
    NSLog(@"setProgress %f",theProgress);
    NSLog(@"isnan(theProgress) %@",isnan(theProgress)?@"YES":@"NO");
    if(isnan(theProgress))
        return;
    
    progress = theProgress;
    CGRect theFrame = self.progressView.frame;
    theFrame.size.width = self.frame.size.width * theProgress;
	NSLog(@"CUSTOMPROGRESS %f |||||| %@",theProgress, NSStringFromCGRect(theFrame));
	[UIView animateWithDuration:0.1 animations:^{
		self.progressView.frame = theFrame;    
	}];
	
}

-(void)setCornerRadius:(CGFloat)theCornerRadius {
	self.layer.cornerRadius = theCornerRadius;
	cornerRadius = theCornerRadius;
}

//-(void)dealloc
//{
////	[self.progressView release];
//	self.progressView = nil;
//	[super dealloc];
//}
@end
