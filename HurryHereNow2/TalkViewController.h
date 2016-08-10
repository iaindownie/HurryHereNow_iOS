//
//  TalkViewController.h
//  HurryHereNow2
//
//  Created by Matt Froggett on 14/12/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TalkViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UITableView *talkList;
@property NSArray *talkItems;

@end
