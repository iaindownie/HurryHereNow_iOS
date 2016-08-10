//
//  retailerViewController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 20/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface retailerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *retailerImage;
@property (weak, nonatomic) IBOutlet UILabel *retailerCaption;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) NSObject *retailer;
@property (weak, nonatomic) IBOutlet UITableView *listView;
@property NSMutableArray *offersArray;
- (IBAction)moreButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreButtonOutlet;

- (void)returnToMap;


@end
