//
//  GoogleMapViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 4. 7..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface GoogleMapViewController : UIViewController <CLLocationManagerDelegate>{//, MKMapViewDelegate, UISearchBarDelegate, MKReverseGeocoderDelegate, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate> {
	
	
//	CLLocationManager *locationManager; // 위치 관리자, gps/wifi 둥으로 현재 위치를 가지고 온다.
//	
//	Marker *marker;
//	
//	UISearchBar *search;
//	BOOL searching;
//	CLLocation *startPoint;
//	MKReverseGeocoder *reverseGeocoder;
//	
//	NSString *geoString;
//	NSString *roomkey;
//	
//	id mTarget;
//	SEL mSelector;
//	
//	BOOL isFromTimeLine;
//	UITableView *listTable;
//	NSMutableArray *placeArray;
//	
//	NSMutableData *responseData;
//    UIImageView *locationImage;
//    UILabel *locationLabel;
//    NSString *saveLocation;
//    BOOL isFromActivity;
}

//@property (nonatomic, retain) MKMapView *mapView;
//@property (nonatomic, retain) CLLocationManager *locationManager;
//@property (nonatomic, retain) CLLocation *startPoint;
//@property (nonatomic, retain) MKReverseGeocoder *reverseGeocoder;
//@property (nonatomic, assign) id mTarget;
//@property (nonatomic, assign) SEL mSelector;
//
////- (void)selection:(NSInteger)selectedRow;
//- (id)initWithRoomkey:(NSString *)rk;
//- (id)initWithLocation:(NSString *)loc;
//- (id)initForTimeLine;
- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;
//- (void)reverseGeocoding:(CLLocationCoordinate2D)coordinate;
- (id)initForUpload;
- (id)initForDownload;
- (void)readyForDownloadWithLatitude:(float)lati longitude:(float)longi;
@end
