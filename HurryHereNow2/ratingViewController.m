//
//  ratingViewController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 25/01/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import "ratingViewController.h"

@interface ratingViewController ()

@end

@implementation ratingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submitAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
