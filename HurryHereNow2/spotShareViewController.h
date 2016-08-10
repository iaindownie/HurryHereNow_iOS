//
//  spotShareViewController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 02/02/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface spotShareViewController : UIViewController

@property (weak, nonatomic) NSObject* offer;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *shop;

@end
