//
//  MapViewAnnotation.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 13/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign) NSInteger * offerIndex;

@end
