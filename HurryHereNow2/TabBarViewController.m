//
//  TabBarViewController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 09/12/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setSelectedImageTintColor:[UIColor colorWithRed:210.0/255.0 green:40.0/255.0 blue:32.0/255.0 alpha:1]];
    
    // Share button
    UIButton* shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0.0, 0.0, 80, 80);
    
    UIImage *shareImage = [UIImage imageNamed:@"spot-share"];
    UIImage *shareImageActive = [UIImage imageNamed:@"spot-share-active"];
    [shareButton setImage:shareImage forState:UIControlStateNormal];
    [shareButton setImage:shareImageActive forState:UIControlStateHighlighted | UIControlStateSelected];
    [shareButton setAdjustsImageWhenDisabled:false];
    
    shareButton.center = self.tabBar.center;
    [shareButton addTarget:self action:@selector(triggerShare) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:shareButton];
}

- (void)triggerShare {
    [self setSelectedIndex:1];
}

- (UIViewController *)viewControllerForUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
{
    return [self.selectedViewController viewControllerForUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
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
 
 CGPoint center = self.tabBar.center;
 center.y = center.y - heightDifference/2.0;
 button.center = center;
 
 UIImage *btnImage = [UIImage imageNamed:@"image.png"];
 [btnTwo setImage:btnImage forState:UIControlStateNormal];
}
*/

@end
