//
//  LocationManager.h
//  NewXMPPTest
//
//  Created by Tolecen on 13-7-16.
//  Copyright (c) 2013年 Tolecen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>
#import "TempData.h"

//定位

@interface LocationManager : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *startPoint;
    //  CLLocationManager *_locationManager;
    MKMapView * _mapView;
    NSTimer * checkTimer;
    float lat;
    float lon;
    BOOL goUpdate;
}
@property(nonatomic,strong)CLLocation *userPoint;
+ (id)sharedInstance;
-(void)initLocation;
-(void)startCheckLocationWithSuccess:(void(^)(double lat,double lon))success Failure:(void(^)(void))failure;
-(double)getLatitude;
-(double)getLongitude;
@end
