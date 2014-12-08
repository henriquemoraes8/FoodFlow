//
//  SellerNotificationViewController.m
//  FoodFlow
//
//  Created by Rui Xu on 11/16/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "SellerNotificationViewController.h"
#import "SellerNotificationTableViewCell.h"
#import "AppDelegate.h"

@implementation SellerNotificationViewController
{
    NSMutableArray *transactions;
}

- (void)viewWillAppear:(BOOL)animated {
    transactions = [NSMutableArray new];
    
    PFUser *current = [PFUser currentUser];
    PFQuery *buy = [PFQuery queryWithClassName:@"Transaction"];
    [buy whereKey:@"seller" equalTo:current.objectId];
    
    PFQuery *sell = [PFQuery queryWithClassName:@"Transaction"];
    [buy whereKey:@"buyer" equalTo:current.objectId];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[buy,sell]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        transactions = [[NSMutableArray alloc] initWithArray:objects];
        [_tableNotifications reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return transactions.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SellerNotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFObject *transaction = transactions[indexPath.row];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"EE, dd MMM yyyy"];
    cell.labelDate.text = [formatter stringFromDate:transaction.createdAt];
    cell.labelLocation.text = transaction[@"location"];
    cell.labelPayment.text = [NSString stringWithFormat:@"Requested: %.2f",[transaction[@"amount"] floatValue]];

    PFQuery *querySeller = [PFUser query];
    [querySeller getObjectInBackgroundWithId:transaction[@"seller"] block:^(PFObject *object, NSError *error) {
        cell.imageSeller.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:object[@"image"]]]];
        cell.nameSeller.text = object[@"name"];
    }];
    
     PFQuery *queryBuyer = [PFUser query];
     [queryBuyer getObjectInBackgroundWithId:transaction[@"buyer"] block:^(PFObject *object, NSError *error) {
        cell.imageBuyer.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:object[@"image"]]]];
        cell.nameBuyer.text = object[@"name"];
     }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
