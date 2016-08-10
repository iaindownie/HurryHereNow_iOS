//
//  offerPageViewController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 24/01/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface offerPageViewController : UIViewController

- (void)setViewData;

@property (weak, nonatomic) NSObject* offer;
@property (weak, nonatomic) NSObject* retailer;

@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
@property (weak, nonatomic) IBOutlet UILabel *offerDescription;
@property (weak, nonatomic) IBOutlet UILabel *offerRetailer;

@end
