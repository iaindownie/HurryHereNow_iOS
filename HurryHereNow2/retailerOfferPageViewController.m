//
//  retailerOfferPageViewController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 25/01/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import "retailerOfferPageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface retailerOfferPageViewController ()

@end

@implementation retailerOfferPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setViewData {
    [_offerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hurryherenow.com/images/retailers/%@.small.png", [_retailer valueForKey:@"retailerId"]]] placeholderImage:[UIImage imageNamed:@"example"]];
    _offerImage.layer.shadowColor = [UIColor blackColor].CGColor;
    _offerImage.layer.shadowOpacity = 0.3;
    _offerImage.layer.shadowOffset = CGSizeMake(0, 0);
    _offerImage.layer.shadowRadius = 1.0;
    _offerImage.clipsToBounds = NO;
    
    _offerDescription.text = [_offer valueForKey:@"description"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
