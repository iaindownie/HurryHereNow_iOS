//
//  FilterViewController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 26/01/2015.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterControllerDelegate <NSObject>
- (void)reloadOffers:(id)controller didFinishEnteringItem:(NSInteger)idx;
@end


@interface FilterViewController : UIViewController
@property (nonatomic, assign) id <FilterControllerDelegate> delgate;
- (IBAction)filterButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonR1;
@property (weak, nonatomic) IBOutlet UIButton *buttonR2;
@property (weak, nonatomic) IBOutlet UIButton *buttonR3;
@property (weak, nonatomic) IBOutlet UIButton *buttonR4;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *buttonL1;
@property (weak, nonatomic) IBOutlet UIButton *buttonL2;
@property (weak, nonatomic) IBOutlet UIButton *buttonL3;
@property (weak, nonatomic) IBOutlet UIButton *buttonL4;
@end
