//
//  FirstViewController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 08/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "filterController.h"
#import "WYPopoverController.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate, filterControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *displayControl;
@property (strong, nonatomic) IBOutlet UIView *offersContainer;
@property (weak, nonatomic) IBOutlet MKMapView *mainMapView;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property NSMutableArray *offersArray;
@property CLLocationCoordinate2D coords;

@property NSString* retailerToSelect;

@property NSMutableArray *retailers_dictMap;
@property NSMutableDictionary *retailers_offersDict;
@property NSMutableDictionary *user_offersDict;
@property NSString *retailer;

- (IBAction)filterButton:(id)sender;

- (IBAction)displayControlChanged:(id)sender;

- (IBAction)returnToMap:(UIStoryboardSegue *)segue;

- (void)openRatingView;

- (void)dismissPopover:(NSString*)retailer;

@end

