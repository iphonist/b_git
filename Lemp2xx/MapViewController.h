//
//  MapViewController.h
//  LEMPMobile
//
//  Created by In-Gu Baek on 11. 8. 17..
//  Copyright 2011 Benchbee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
#import "Marker.h"


@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate> {
	
	
	MKMapView *mapView; // 지도
	CLLocationManager *locationManager; // 위치 관리자, gps/wifi 둥으로 현재 위치를 가지고 온다.
	
	Marker *marker;
	
	UISearchBar *search;
	BOOL searching;
	CLLocation *startPoint;
	CLGeocoder *clGeocoder;
	
	NSString *geoString;
	NSString *roomkey;
	
	__unsafe_unretained id mTarget;
	SEL mSelector;
	
	BOOL isFromTimeLine;
	UITableView *listTable;
	NSMutableArray *placeArray;
	
	NSMutableData *responseData;
    UIImageView *locationImage;
    UILabel *locationLabel;
    NSString *saveLocation;
    BOOL isFromActivity;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *startPoint;
@property (nonatomic, retain) CLGeocoder *clGeocoder;
@property (nonatomic, assign) id mTarget;
@property (nonatomic, assign) SEL mSelector;

//- (void)selection:(NSInteger)selectedRow;
- (id)initWithRoomkey:(NSString *)rk;
- (id)initWithLocation:(NSString *)loc;
- (id)initForTimeLine;
- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
- (void)reverseGeocoding:(CLLocationCoordinate2D)coordinate;
- (void)setCurrentFromActivity;

@end
