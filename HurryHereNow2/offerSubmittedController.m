//
//  offerSubmittedController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 22/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import "offerSubmittedController.h"
#import "SpotShareForm.h"
#import "AFNetworking.h"
#import <Google/Analytics.h>

@interface offerSubmittedController ()

@end

@implementation offerSubmittedController

id<GAITracker> tracker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formController.form = [[SpotShareForm alloc] init];
    self.navigationItem.hidesBackButton = YES;
    
    tracker = [[GAI sharedInstance] defaultTracker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)offerSubmitted:(id)sender {
    [self.view endEditing:YES];
    
    SpotShareForm *detailsForm = self.formController.form;
    if([detailsForm.offerDescription length] == 0 || [detailsForm.storeName length] == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please fill in all fields."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    } else {
     
        [self submitOffer:detailsForm.storeName offerDescription:detailsForm.offerDescription];
        
    }
}

- (void)submitOffer:(NSString *)storeName offerDescription:(NSString *)offerDescription {
    [tracker set:kGAIScreenName value:@"Spot & Share - submitted"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"storeName": storeName,
                             @"description": offerDescription,
                             @"latitude": @(_coords.latitude),
                             @"longitude": @(_coords.longitude)};
    
    [manager POST:@"http://api.hurryherenow.com/api/user-offer" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                        message:@"Thank you for sharing a local offer!"
                                                       delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
        
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please try again."
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self performSegueWithIdentifier:@"unwindFromDetails" sender:self];
}

/*
 
 $storeName = Input::get('storeName', '');
 $description = Input::get('description', '');
 $latitude = Input::get('latitude', 0);
 $longitude = Input::get('longitude', 0);
 
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 NSDictionary *params = @{@"user[height]": height,
 @"user[weight]": weight};
 [manager POST:@"https://mysite.com/myobject" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"JSON: %@", responseObject);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 }];*/

@end
