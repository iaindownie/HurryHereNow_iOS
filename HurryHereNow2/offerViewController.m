//
//  offerViewController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 21/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import "offerViewController.h"
#import "FirstViewController.h"
#import "offerPageViewController.h"
#import "AFNetworking.h"

@interface offerViewController ()

@end

@implementation offerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _offerScrollView.delegate = self;
    _offers = [[_offer valueForKey:@"offers"] subarrayWithRange:NSMakeRange(0, MIN([[_offer valueForKey:@"offers"] count], 3))];
    _pageControl.numberOfPages = [_offers count];
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    for (int i = 0; i < _offers.count; i++) {
        CGRect frame;
        frame.origin.x = _offerScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = _offerScrollView.frame.size;
        
        offerPageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"offerPageViewController"];
        controller.view.frame = frame;
        controller.offer = [_offers objectAtIndex:i];
        controller.retailer = _offer;
        [controller setViewData];
        
        [_offerScrollView addSubview:controller.view];
    }
    
    _offerScrollView.contentSize = CGSizeMake(_offerScrollView.frame.size.width * _offers.count, _offerScrollView.frame.size.height);

    CALayer *offerBg = [CALayer layer];
    offerBg.frame = CGRectMake(-1, -1, 252, 125);
    offerBg.backgroundColor = [UIColor whiteColor].CGColor;
    offerBg.borderColor = [UIColor colorWithRed:(226/255.0) green:(226/255.0) blue:(226/255.0) alpha:1].CGColor;
    offerBg.borderWidth = 1;
    [self.view.layer insertSublayer:offerBg atIndex:0];

    [self setControls:0];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    tap.numberOfTapsRequired = 1;
    tap.enabled = YES;
    tap.cancelsTouchesInView = NO;
    [_offerScrollView addGestureRecognizer:tap];
}

- (IBAction)changePage:(id)sender {
    NSLog(@"%ld", (long)_pageControl.currentPage);
    CGFloat x = _pageControl.currentPage * _offerScrollView.frame.size.width;
    [_offerScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)setControls:(NSUInteger)idx {
    NSObject *offer = [_offers objectAtIndex:idx];
    
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
    
    [_expiry setTitle:message forState:UIControlStateNormal];
    
    [_pveRating setTitle:[NSString stringWithFormat:@"%@", [offer valueForKey:@"pve"]] forState:UIControlStateNormal];
    [_nveRating setTitle:[NSString stringWithFormat:@"%@", [offer valueForKey:@"nve"]] forState:UIControlStateNormal];

    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    _page = lround(fractionalPage);
    if (previousPage != _page) {
        _pageControl.currentPage = _page;
        [self setControls:_page];
        previousPage = _page;
    }
}

// tag 1 - positive
// tag 2 - negative
- (IBAction)ratingAction:(id)sender {
    _ve = [sender tag];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What did you think of this offer?" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alert.delegate = self;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Submit"];
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1) {
        UITextField *content = [alertView textFieldAtIndex:0];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"offerId": [[_offers objectAtIndex:_page] valueForKey:@"offerId"],
                                 @"type": [NSString stringWithFormat:@"%d", _ve],
                                 @"comment": content.text};
        
        [manager POST:@"http://api.hurryherenow.com/api/rate" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Thank you for rating this offer!"
                                                           delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil];
            
            [alert show];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please try again."
                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
        }];
    }
    _ve = 0;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.parentVC dismissPopover:[NSString stringWithFormat:@"%@", [_offer valueForKey:@"storeId"]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* 2014-10-30 18:39:00
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
