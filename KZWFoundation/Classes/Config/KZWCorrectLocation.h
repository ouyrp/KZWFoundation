//
//  KZWCorrectLocation.h
//  KZWfinancial
//
//  Created by ouy on 2017/3/3.
//  Copyright © 2017年 ouy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface KZWCorrectLocation : NSObject

+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
//转GCJ-02
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
