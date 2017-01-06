//
//  CustomPageControl.m
//  WJCustomer
//
//  Created by Hyemin Kim on 11. 12. 27..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "CustomPageControl.h"

#define kOffImage [CustomUIKit customImageNamed:@"Indicator_dft.png"]
#define kOnImage [CustomUIKit customImageNamed:@"Indicator_prs.png"]

@implementation CustomPageControl

- (void)layoutSubviews{
    
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 페이지컨트롤을 초기화. 처음에는 무조건 첫번째 것이 보이기 때문에 첫번째 이미지를 onImage로 한다.
     연관화면 : 대고객 이벤트 및 공지
     ****************************************************************/
    
	[super layoutSubviews];
	
    NSLog(@"layoutSubviews");
    
    UIImage* image = kOffImage;
    for(UIImageView* view in self.subviews){
        NSLog(@"view %@",view);
        if([view isKindOfClass:[UIView class]]){
            
            UIImageView *iv = [[UIImageView alloc] initWithImage:kOffImage];
            iv.frame = CGRectMake(0, 0, 21, 21);
//            iv.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
            [view addSubview:iv];
//            [iv release];
        }
        else{
        CGRect frame = view.frame;
        frame.size = image.size;
        view.frame = frame;
        view.image = image;
        }
    }
    [self setCurrentPage:0];
}

- (void)setCurrentPage:(NSInteger)index{
    [super setCurrentPage:index];
    
    for(int i = 0 ; i < [self.subviews count] ; i++){
        UIImageView* view = [self.subviews objectAtIndex:i];
        if([view isKindOfClass:[UIView class]]){
            
            UIImageView *iv = [[UIImageView alloc] initWithImage:((i == index) ? kOnImage : kOffImage)];
            iv.frame = CGRectMake(0, 0, 21, 21);
            iv.tag = 9901;
            [view addSubview:iv];
//            [iv release];
        }
        else{
            
            view.image = (i == index) ? kOnImage : kOffImage;
        }
    }
}

@end