//
//  offerSubmittedController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 22/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FXForms.h"

@interface offerSubmittedController : FXFormViewController <UIAlertViewDelegate>
- (IBAction)offerSubmitted:(id)sender;

@property CLLocationCoordinate2D coords;

@end
