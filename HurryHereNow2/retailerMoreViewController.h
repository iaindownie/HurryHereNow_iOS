//
//  retailerMoreViewController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 18/05/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "retailerViewController.h"

@interface retailerMoreViewController : UITableViewController

@property (weak, nonatomic) NSObject *retailer;

@property (weak, nonatomic) retailerViewController *parentVC;

@end
