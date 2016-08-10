//
//  FirstViewController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 08/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import "FirstViewController.h"
#import "MapViewAnnotation.h"
#import "SpotShareAnnotation.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "retailerViewController.h"
#import "filterController.h"
#import "offerViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "AFBlurSegue.h"
#import "FilterViewController.h"
#import "spotShareViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <Google/Analytics.h>

@interface FirstViewController () <WYPopoverControllerDelegate>
{
    WYPopoverController *popover;
}

@end

@implementation FirstViewController

static bool coordinatesSet = NO;
id<GAITracker> tracker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[UIScreen mainScreen] bounds].size.height <= 480){
        self.edgesForExtendedLayout = UIRectEdgeAll;
        _listView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame) * 2, 0.0f);
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [_displayControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [_displayControl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    [_displayControl setTintColor:[UIColor colorWithRed:(1) green:(1) blue:(1) alpha:0.4f]];
    
    self.mainMapView.delegate = self;
    self.mainMapView.showsPointsOfInterest = false;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    if([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        [self.locationManager startUpdatingLocation];
    }
    
    tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Offers - map"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    
    CLLocation *newLocation = [locations lastObject];
    MKCoordinateRegion updatedRegion;
    updatedRegion.center = newLocation.coordinate;
    updatedRegion.span.latitudeDelta = 0.2;
    updatedRegion.span.longitudeDelta = 0.2;
    
    [_mainMapView setRegion:updatedRegion];
    
    if(!coordinatesSet) {
        coordinatesSet = YES;
        
        _coords = newLocation.coordinate;
        [self loadOffers:0];
    }
}

- (void)loadOffers:(NSInteger)cat
{
    [SVProgressHUD show];
    NSURL *url;
    if(cat == 0) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.hurryherenow.com/api/promotions?latitude=%f&longitude=%f&distance=25", _coords.latitude, _coords.longitude]];
    } else {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.hurryherenow.com/api/promotions?latitude=%f&longitude=%f&distance=25&categories=%ld", _coords.latitude, _coords.longitude, cat]];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processOfferData:responseObject];
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Unable to connect to Hurry Here Now. Please try again later."
                                                       delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        [SVProgressHUD dismiss];
        
    }];

    [operation start];
}

- (void)processOfferData:(NSDictionary *)offers {
    [self reset];
    
    if([offers count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry, there are currently no offers in your area"
                                                        message:@"Why not share one using Spot & Share?"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self reset];
        [_listView reloadData];
        [alert show];
        [SVProgressHUD dismiss];
    } else {
        _retailers_offersDict = [offers mutableCopy];
        if([_retailers_offersDict valueForKey:@"userSubmitted"] != nil) {
            _user_offersDict = [offers objectForKey:@"userSubmitted"];
            [_retailers_offersDict removeObjectForKey:@"userSubmitted"];
        }
        
        NSMutableArray *mapArray = [[NSMutableArray alloc] init];
        for(NSString *key in [_retailers_offersDict allKeys]) {
            [mapArray addObject:key];
        }
        _retailers_dictMap = mapArray;
        
        [self displayOffers];
    }
}

- (void)displayOffers
{
    CLLocationCoordinate2D offerLocation;
    for(id key in _retailers_offersDict) {
        id value = [_retailers_offersDict objectForKey:key];
        
        offerLocation.latitude = [value[@"latitude"] doubleValue];
        offerLocation.longitude = [value[@"longitude"] doubleValue];
        
        MapViewAnnotation * offerAnnotation = [MapViewAnnotation alloc];
        offerAnnotation.coordinate = offerLocation;
        offerAnnotation.title = [NSString stringWithFormat:@"%@", key];
        
        [_mainMapView addAnnotation:offerAnnotation];
    }
    
    for(id key in _user_offersDict) {
        id value = [_user_offersDict objectForKey:key];
        
        offerLocation.latitude = [[value valueForKey:@"latitude"] doubleValue];
        offerLocation.longitude = [[value valueForKey:@"longitude"] doubleValue];
        
        SpotShareAnnotation * annotation = [SpotShareAnnotation alloc];
        annotation.coordinate = offerLocation;
        annotation.title = [NSString stringWithFormat:@"%@", key];
     
        [_mainMapView addAnnotation:annotation];
    }
    
    [_listView reloadData];
    [SVProgressHUD dismiss];
}

- (void)reloadOffers:(id)controller didFinishEnteringItem:(NSInteger)idx {
    [self loadOffers:idx];
}

- (void)reset
{
    NSMutableArray *annotationsToRemove = [[_mainMapView annotations] mutableCopy];
    [annotationsToRemove removeObject:_mainMapView.userLocation];
    [_mainMapView removeAnnotations:annotationsToRemove];
    _retailers_offersDict = nil;
    _user_offersDict = nil;
    _retailers_dictMap = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)displayControlChanged:(id)sender {
    switch(_displayControl.selectedSegmentIndex) {
        case 0:
            _mainMapView.hidden = false;
            _listView.hidden = true;
            [tracker set:kGAIScreenName value:@"Offers - map"];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            break;
        case 1:
            _mainMapView.hidden = true;
            _listView.hidden = false;
            [tracker set:kGAIScreenName value:@"Offers - list"];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            break;
    };
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"offerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSObject *retailer = [_retailers_offersDict objectForKey:[NSString stringWithFormat:@"%@", [_retailers_dictMap objectAtIndex:indexPath.row]]];
    
    NSObject *offer = [[retailer valueForKey:@"offers"] objectAtIndex:0];
    
    UILabel *offerText = (UILabel *)[cell viewWithTag:1];
    offerText.text = [offer valueForKey:@"description"];
    UILabel *offerRetailer = (UILabel *)[cell viewWithTag:2];
    offerRetailer.text = [retailer valueForKey:@"name"];
    
    UIImageView *offerImage = (UIImageView *)[cell viewWithTag:3];
    [offerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hurryherenow.com/images/offers/%@.png", [offer valueForKey:@"offerId"]]] placeholderImage:[UIImage imageNamed:@"example"]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_retailers_offersDict count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"retailerViewSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"retailerViewSegue"]) {
        retailerViewController *retailerVC = [segue destinationViewController];
        
        if(_retailer > 0) {
            retailerVC.retailer = [_retailers_offersDict objectForKey:_retailer];
            _retailer = 0;
        } else {
            NSIndexPath *indexPath = [_listView indexPathForSelectedRow];
            retailerVC.retailer = [_retailers_offersDict objectForKey:[NSString stringWithFormat:@"%@", [_retailers_dictMap objectAtIndex:indexPath.row]]];
        }
        
    } else if([[segue identifier] isEqualToString:@"filterButtonSegue"]) {
        filterController *filterVC = [[segue destinationViewController] visibleViewController];
        [filterVC setDelgate:self];
    } else if([[segue identifier] isEqualToString:@"newFilterView"]) {
        FilterViewController *destination = segue.destinationViewController;
        [destination setDelgate:self];
        destination.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
}

- (void)returnToMap:(UIStoryboardSegue *)segue {
    _mainMapView.hidden = false;
    _listView.hidden = true;
    _displayControl.selectedSegmentIndex = 0;
    
    CLLocationCoordinate2D location;
    location.latitude = [[[_retailers_offersDict valueForKey:[NSString stringWithFormat:@"%@", _retailerToSelect]] valueForKey:@"latitude"] doubleValue];
    location.longitude = [[[_retailers_offersDict valueForKey:[NSString stringWithFormat:@"%@", _retailerToSelect]] valueForKey:@"longitude"] doubleValue];
    
    MKCoordinateRegion updatedRegion;
    updatedRegion.center = location;
    updatedRegion.span.latitudeDelta = 0.005;
    updatedRegion.span.longitudeDelta = 0.005;
    
    [_mainMapView setRegion:updatedRegion];
}

- (void)openRatingView {
    [self performSegueWithIdentifier:@"ratingSegue" sender:self];
}

- (void)dismissPopover:(NSString*)retailer {
    [popover dismissPopoverAnimated:YES];
    popover = nil;
    
    _retailer = retailer;
    [self performSegueWithIdentifier:@"retailerViewSegue" sender:self];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKPinAnnotationView *)view {
    if([view.annotation isKindOfClass:[MapViewAnnotation class]]) {
        if(popover == nil) {
            [_mainMapView deselectAnnotation:view.annotation animated:YES];
            offerViewController *offerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"offerViewController"];
            
            offerViewController.preferredContentSize = CGSizeMake(248, 163);
            offerViewController.offer = [_retailers_offersDict objectForKey:[NSString stringWithFormat:@"%ld", (long)[view.annotation.title integerValue]]];
            
            offerViewController.parentVC = self;
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                                  action:@"annotation_selected"  // Event action (required)
                                                                   label:[NSString stringWithFormat:@"%ld", (long)[view.annotation.title integerValue]]          // Event label
                                                                   value:nil] build]];
            
            popover = [[WYPopoverController alloc] initWithContentViewController:offerViewController];
            popover.delegate = self;
            [popover presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        } else {
            [popover dismissPopoverAnimated:YES];
        }
        
    }
    
    if([view.annotation isKindOfClass:[SpotShareAnnotation class]]) {
        if(popover == nil) {
            [_mainMapView deselectAnnotation:view.annotation animated:YES];
            spotShareViewController *spotShareViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"spotShareViewController"];
            
            spotShareViewController.preferredContentSize = CGSizeMake(200, 100);
            spotShareViewController.offer = [_user_offersDict objectForKey:[NSString stringWithFormat:@"%ld", (long)[view.annotation.title integerValue]]];
            
            popover = [[WYPopoverController alloc] initWithContentViewController:spotShareViewController];
            popover.delegate = self;
            [popover presentPopoverFromRect:view.bounds inView:view permittedArrowDirections:WYPopoverArrowDirectionAny animated:YES];
        } else {
            [popover dismissPopoverAnimated:YES];
        }
        
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)sender viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *reusePin = @"StandardPin";
    static NSString *spotShareReusePin = @"SpotSharePin";
    
    if([annotation isKindOfClass:[MapViewAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[sender dequeueReusableAnnotationViewWithIdentifier:reusePin];
        
        if(annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusePin];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"offer-pin"];
        }
        
        annotationView.annotation = annotation;
        
        
        return annotationView;
    }
    
    if([annotation isKindOfClass:[SpotShareAnnotation class]]) {
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[sender dequeueReusableAnnotationViewWithIdentifier:spotShareReusePin];
        
        if(annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:spotShareReusePin];
            annotationView.canShowCallout = NO;
            annotationView.image = [UIImage imageNamed:@"spot-share-pin"];
        }
        
        annotationView.annotation = annotation;
        
        
        return annotationView;
    }
    
    return nil;
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController {
    popover = nil;
}

@end