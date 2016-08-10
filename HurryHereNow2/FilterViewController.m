//
//  FilterViewController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 26/01/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import "FilterViewController.h"
#import <Google/Analytics.h>

@interface FilterViewController ()

@end

@implementation FilterViewController

id<GAITracker> tracker;

- (void)viewDidLoad {
    [super viewDidLoad];

    tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Offers - filter"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    if([[UIScreen mainScreen] bounds].size.height <= 480){
        _buttonR1.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _buttonR2.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _buttonR3.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _buttonR4.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _buttonL1.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _buttonL2.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _buttonL3.transform = CGAffineTransformMakeScale(0.8, 0.8);
        _buttonL4.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        CGRect b2f = _buttonR2.frame;
        b2f.origin.y = b2f.origin.y - 15;
        _buttonR2.frame = b2f;
        CGRect b3f = _buttonR3.frame;
        b3f.origin.y = b3f.origin.y - 30;
        _buttonR3.frame = b3f;
        CGRect b4f = _buttonR4.frame;
        b4f.origin.y = b4f.origin.y - 45;
        _buttonR4.frame = b4f;
        
        CGRect b2lf = _buttonL2.frame;
        b2lf.origin.y = b2lf.origin.y - 15;
        _buttonL2.frame = b2lf;
        CGRect b3lf = _buttonL3.frame;
        b3lf.origin.y = b3lf.origin.y - 30;
        _buttonL3.frame = b3lf;
        CGRect b4lf = _buttonL4.frame;
        b4lf.origin.y = b4lf.origin.y - 45;
        _buttonL4.frame = b4lf;
        
        CGRect buttonFrame = _resetButton.frame;
        buttonFrame.origin.y = 435;
        _resetButton.frame = buttonFrame;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)filterButton:(id)sender {
    [self.delgate reloadOffers:self didFinishEnteringItem:[sender tag]];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
