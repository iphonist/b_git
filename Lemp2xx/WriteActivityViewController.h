//
//  WriteActivityViewController.h
//  Lemp2xx
//
//  Created by Hyemin Kim on 2014. 4. 2..
//  Copyright (c) 2014년 Hyemin Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>
#import <CoreLocation/CoreLocation.h>
#import "Marker.h"

@interface WriteActivityViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate, GMSMapViewDelegate>{
    NSDictionary *activityDic;
    UIImageView *optionView;
    UITextView *contentsTextView;
    UILabel *placeHolderLabel;
    UIImageView *textViewBackground;
    
    BOOL isResizing;
    NSInteger msgLineCount;
    UILabel *countLabel;
    
    NSMutableArray *dataArray;
    
    UIButton *addPhoto;
    UILabel *photoCountLabel;
    UIImageView *preView;

    UIScrollView *scrollView;
    UILabel *locationLabel;
    UILabel *infoLabel;
    GMSMapView * gMapView;
    MKMapView *aMapView;
    
	CLLocationManager *locationManager;	
	Marker *marker;
    float currentKeyboardHeight;
    GMSMarker         *locationMarker_;
}
//@property (nonatomic, retain) CLLocationManager *locationManager;

@end
