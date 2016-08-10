//
//  offerViewController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 21/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface offerViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>

/*@property (weak, nonatomic) IBOutlet UIImageView *offerImage;
@property (weak, nonatomic) NSObject* offer;
@property (weak, nonatomic) IBOutlet UILabel *offerRetailer;
@property (weak, nonatomic) IBOutlet UILabel *offerDescription;
@property (weak, nonatomic) IBOutlet UIView *shadowLeft;
@property (weak, nonatomic) IBOutlet UIView *shadowRight;
@property (weak, nonatomic) IBOutlet UILabel *offerExpiry;
@property (weak, nonatomic) IBOutlet UIView *expiryView;*/

@property (weak, nonatomic) NSObject* offer;
@property (nonatomic) NSArray* offers;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger ve;

@property (weak, nonatomic) IBOutlet UIScrollView *offerScrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *expiry;
@property (weak, nonatomic) IBOutlet UIButton *pveRating;
@property (weak, nonatomic) IBOutlet UIButton *nveRating;

@property (weak, nonatomic) FirstViewController *parentVC;

- (IBAction)ratingAction:(id)sender;


@end
