//
//  SpotShareAnnotation.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 02/02/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SpotShareAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, assign) NSInteger * offerIndex;

@end
