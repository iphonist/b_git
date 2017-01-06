//
//  Marker.h
//  bSampler
//
//  Created by In-Gu Baek on 11. 8. 17..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface Marker : NSObject <MKAnnotation>{
	
	CLLocationCoordinate2D coordinate;
	NSString *posTitle;
	NSString *posSubtitle;
	

}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *posTitle;
@property (nonatomic, copy) NSString *posSubtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)c;

@end
