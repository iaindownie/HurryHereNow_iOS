//
//  TalkViewController.m
//  HurryHereNow2
//
//  Created by Matt Froggett on 14/12/2014.
//  Copyright (c) 2014 mf. All rights reserved.
//

#import "TalkViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface TalkViewController ()

@end

@implementation TalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.tableView.rowHeight = 98;
    
    _talkList.separatorStyle = UITableViewCellSeparatorStyleNone;
    _talkList.backgroundView = nil;
    _talkList.backgroundColor = [UIColor colorWithRed:(242.0/255.0) green:(242.0/255.0) blue:(242.0/255.0) alpha:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadFeed];
}

- (void)loadFeed
{
    [SVProgressHUD show];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.hurryherenow.com/api/talk"]];
   
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _talkItems = responseObject;
        [_talkList reloadData];
        [SVProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Unable to connect to Hurry Here Now. Please try again later."
                                                       delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert show];
        [SVProgressHUD dismiss];
        
    }];
    
    [operation start];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"talkCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSObject *item = [_talkItems objectAtIndex:indexPath.row];
    
    UIView *background = [cell viewWithTag:1];
    background.layer.shadowColor = [UIColor blackColor].CGColor;
    background.layer.shadowOpacity = 0.2;
    background.layer.shadowOffset = CGSizeMake(0, 1);
    background.layer.shadowRadius = 0.8;
    background.clipsToBounds = NO;
    
    UIImageView *thumb = (UIImageView *)[cell viewWithTag:2];
    if([[NSString stringWithFormat:@"%@", [item valueForKey:@"type"]] isEqualToString:@"1"]) {
        [thumb setImage:[UIImage imageNamed:@"thumbs-up"]];
    } else {
        [thumb setImage:[UIImage imageNamed:@"thumbs-down"]];
    }
    
    UILabel *comment = (UILabel *)[cell viewWithTag:3];
    comment.text = [item valueForKey:@"comment"];
    
    UILabel *desc = (UILabel *)[cell viewWithTag:4];
    desc.text = [item valueForKey:@"description"];
    
    UILabel *shop = (UILabel *)[cell viewWithTag:5];
    shop.text = [item valueForKey:@"name"];
    
    UILabel *time = (UILabel *)[cell viewWithTag:6];
    time.text = [item valueForKey:@"date"];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_talkItems count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 141;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
