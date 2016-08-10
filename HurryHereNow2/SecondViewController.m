//
//  SecondViewController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 08/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import "SecondViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "offerSubmittedController.h"
#import <Google/Analytics.h>

@interface SecondViewController ()

@end

@implementation SecondViewController

id<GAITracker> tracker;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.submitMapView.delegate = self;
    self.submitMapView.showsPointsOfInterest = false;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [self.locationManager startUpdatingLocation];
    }
    
    _descField.delegate = self;
    _storeField.delegate = self;
    
    _locationLabel.layer.cornerRadius = 8;
    _locationLabel.layer.masksToBounds = YES;
    
    tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Spot & Share - map"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *newLocation = [locations lastObject];
    MKCoordinateRegion updatedRegion;
    updatedRegion.center = newLocation.coordinate;
    updatedRegion.span.latitudeDelta = 0.005;
    updatedRegion.span.longitudeDelta = 0.005;
    
    [_submitMapView setRegion:updatedRegion];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    offerSubmittedController *destinationVC = [segue destinationViewController];
    destinationVC.coords = [_submitMapView centerCoordinate];
        
    /*retailerViewController *retailerVC = [segue destinationViewController];
    
    NSIndexPath *indexPath = [_listView indexPathForSelectedRow];
    retailerVC.retailer = [_retailers_offersDict objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
    
    /*
    CLLocationCoordinate2D location = [_submitMapView centerCoordinate];
    NSString *lat = [[NSString alloc] initWithFormat:@"%g", location.latitude];
    NSString *lng = [[NSString alloc] initWithFormat:@"%g", location.longitude];
   /*
    NSURL *submission = [NSURL URLWithString:[NSString stringWithFormat:@"http://hurryherenow.com/email.php?store=%@&description=%@&latitude=%@&longitude=%@", _storeField.text, _descField.text, lat, lng]];
    NSLog(@"%@", submission);
    NSData *sub = [NSData dataWithContentsOfURL:submission];
    
    [self.view endEditing:YES];*/
}

- (void)unwindFromDetails:(UIStoryboardSegue *)segue {
}











- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField:textField up:NO];
}

- (void)animateTextField:(UITextField *)textField up:(BOOL) up {
    CGRect bound = [[UIScreen mainScreen] bounds];
    NSInteger movementDistance;
    
    if(bound.size.height > 500) {
        movementDistance = 80;
    } else {
        movementDistance = 200;
    }
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);

    [UIView beginAnimations:@"anim" context:nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



//NSURL URLWithString:[NSString stringWithFormat:@"http://hurryherenow.com/images/retailers/%@.small.png", [_offer valueForKey:@"retailerId"]]]

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
