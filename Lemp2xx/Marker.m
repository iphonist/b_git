//
//  Marker.m
//  bSampler
//
//  Created by In-Gu Baek on 11. 8. 17..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import "Marker.h"


@implementation Marker
@synthesize coordinate, posTitle, posSubtitle;



- (NSString *)title
{
	return posTitle;
}


- (NSString *)subtitle
{
	return posSubtitle;
}


- (id)initWithCoordinate:(CLLocationCoordinate2D)c
{
    /****************************************************************
     작업자 : 김혜민
     작업일자 : 2012/06/04
     작업내용 : 위치를 받아 핀을 초기화
     param - c(CLLocationCoordinate2D) : 위치
     연관화면 : 채팅
     ****************************************************************/
    
	coordinate = c;
	return self;
}



@end
