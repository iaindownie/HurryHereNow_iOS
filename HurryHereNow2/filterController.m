//
//  filterController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 21/09/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import "filterController.h"

@interface filterController ()

@end

@implementation filterController

static bool filterSet = NO;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    filterSet = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 9;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(!filterSet) {
        [self.delgate reloadOffers:self didFinishEnteringItem:indexPath.row];
        filterSet = NO;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)dismissFilterModal:(id)sender {
    filterSet = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
