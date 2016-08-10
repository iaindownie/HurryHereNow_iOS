//
//  filterController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 21/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol filterControllerDelegate <NSObject>
- (void)returnPromotionData:(id)controller didFinishEnteringItem:(NSData *)item;
- (void)reloadOffers:(id)controller didFinishEnteringItem:(NSInteger)idx;
@end

@interface filterController : UITableViewController
@property (nonatomic, assign) id <filterControllerDelegate> delgate;
- (IBAction)dismissFilterModal:(id)sender;
@end
