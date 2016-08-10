//
//  retailerViewController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 20/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import "retailerViewController.h"
#import "FirstViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "retailerMoreViewController.h"
#import <Google/Analytics.h>

@interface retailerViewController () <WYPopoverControllerDelegate>
{
    WYPopoverController *popover;
}

@end

@implementation retailerViewController

id<GAITracker> tracker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Retailer"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    if([[UIScreen mainScreen] bounds].size.height <= 480){
        self.edgesForExtendedLayout = UIRectEdgeAll;
        _listView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame) * 2, 0.0f);
    }
    
    _listView.delegate = self;
    _listView.dataSource = self;
    _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listView.backgroundView = nil;
    _listView.backgroundColor = [UIColor clearColor];
    
    _offersArray = [[_retailer valueForKey:@"offers"] subarrayWithRange:NSMakeRange(0, MIN([[_retailer valueForKey:@"offers"] count], 3))];
    
    
    
    _navBar.title = [_retailer valueForKey:@"name"];
    _retailerCaption.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"retailer-label-bg"]];
    NSMutableString *caption = [[NSMutableString alloc] init];
    [caption appendString:@"   "];
    [caption appendString:[_retailer valueForKey:@"address1"]];
    [caption appendString:@", "];
    [caption appendString:[_retailer valueForKey:@"city"]];
    _retailerCaption.text = caption;
    [_retailerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hurryherenow.com/images/retailers/%@.large.png", [_retailer valueForKey:@"retailerId"]]] placeholderImage:[UIImage imageNamed:@"example"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_offersArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"retailerOfferCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSObject *offer = [_offersArray objectAtIndex:indexPath.row];
    
    UIView *background = [cell viewWithTag:1];
    background.layer.shadowColor = [UIColor blackColor].CGColor;
    background.layer.shadowOpacity = 0.2;
    background.layer.shadowOffset = CGSizeMake(0, 1);
    background.layer.shadowRadius = 0.8;
    background.clipsToBounds = NO;
    //background.layer.shouldRasterize = YES;
    
    UIImageView *offerImage = (UIImageView *)[cell viewWithTag:2];
    [offerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://hurryherenow.com/images/offers/%@.png", [offer valueForKey:@"offerId"]]] placeholderImage:[UIImage imageNamed:@"example"]];
    
    UILabel *offerDescription = (UILabel *)[cell viewWithTag:3];
    offerDescription.text = [offer valueForKey:@"description"];
    
    NSDateFormatter *endDateFormat = [[NSDateFormatter alloc] init];
    [endDateFormat setDateFormat:@"yyyy-MM-dd H:mm:ss"];
    NSDate *endDate = [endDateFormat dateFromString:[offer valueForKey:@"endDate"]];
    NSDate *now = [NSDate date];
    
    NSTimeInterval secsRemaining = [endDate timeIntervalSinceDate:now];
    NSInteger minutesRemaining = secsRemaining/60;
    NSInteger hoursRemaining = secsRemaining/3600;
    NSInteger daysRemaining = secsRemaining/86400;
    
    NSString *message;
    if(secsRemaining < 60) {
        message = [NSString stringWithFormat:@"%ds", (int)secsRemaining];
    } else if(secsRemaining < 3600) {
        message = [NSString stringWithFormat:@"%dm", (int)minutesRemaining];
    } else if(hoursRemaining < 24) {
        message = [NSString stringWithFormat:@"%dh", (int)hoursRemaining];
    } else {
        message = [NSString stringWithFormat:@"%dd", (int)daysRemaining];
    }
    
    UILabel *offerExpiry = (UILabel *)[cell viewWithTag:4];
    offerExpiry.text = message;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 114;
}

- (void)returnToMap {
    [popover dismissPopoverAnimated:YES];
    popover = nil;
    
    [self performSegueWithIdentifier:@"returnToMap" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FirstViewController *vc = segue.destinationViewController;
    vc.retailerToSelect = [_retailer valueForKey:@"storeId"];
}

- (IBAction)moreButton:(id)sender {
    if(popover == nil) {
        
        int height;
        if([_retailer valueForKey:@"phone"] == (id)[NSNull null] && [_retailer valueForKey:@"site"] == (id)[NSNull null]) {
            height = 44;
        } else if([_retailer valueForKey:@"phone"] == (id)[NSNull null] || [_retailer valueForKey:@"site"] == (id)[NSNull null]) {
            height = 88;
        } else {
            height = 132;
        }
        
        retailerMoreViewController *retailerMoreViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"retailerMoreViewController"];
        
        retailerMoreViewController.preferredContentSize = CGSizeMake(320, height);
        retailerMoreViewController.retailer = _retailer;
        retailerMoreViewController.parentVC = self;
        
        popover = [[WYPopoverController alloc] initWithContentViewController:retailerMoreViewController];
        popover.delegate = self;
        [popover presentPopoverFromBarButtonItem:_moreButtonOutlet permittedArrowDirections:WYPopoverArrowDirectionUp animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(WYPopoverController *)popoverController {
    popover = nil;
}
@end
