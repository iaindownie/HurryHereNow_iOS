//
//  SecondViewController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 08/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SecondViewController : UIViewController <CLLocationManagerDelegate, UITextFieldDelegate, MKMapViewDelegate>

- (IBAction)unwindFromDetails:(UIStoryboardSegue *)segue;

@property (weak, nonatomic) IBOutlet MKMapView *submitMapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextField *descField;
@property (weak, nonatomic) IBOutlet UITextField *storeField;

@end
