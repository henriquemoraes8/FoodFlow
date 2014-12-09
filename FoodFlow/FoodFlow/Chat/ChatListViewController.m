//
//  ChatListViewController.m
//  FoodFlow
//
//  Created by Elder Yoshida on 12/8/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListViewCell.h"
#import "ChatViewController.h"

@implementation ChatListViewController
{
    NSMutableArray *conversations;
}

- (void)viewWillAppear:(BOOL)animated {
    conversations = [NSMutableArray new];
    PFUser *user = [PFUser currentUser];
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"Conversation"];
    [query1 whereKey:@"person1" equalTo:user.objectId];
    PFQuery *query2 = [PFQuery queryWithClassName:@"Conversation"];
    [query2 whereKey:@"person2" equalTo:user.objectId];
    PFQuery *orQuery = [PFQuery orQueryWithSubqueries:@[query1,query2]];
    [orQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        conversations = [[NSMutableArray alloc] initWithArray:objects];
        [_tableChats reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return conversations.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *user = [PFUser currentUser];
    ChatListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    PFObject *message = conversations[indexPath.row];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"EE, dd MMM HH:mm"];
    cell.labelDate.text = [formatter stringFromDate:message.updatedAt];
    cell.labelMessage.text = message[@"lastMessage"];

    NSString *personID = [message[@"person1"] isEqualToString:user.objectId] ? message[@"person2"] : message[@"person1"];
    PFQuery *queryPerson = [PFUser query];
    [queryPerson getObjectInBackgroundWithId:personID block:^(PFObject *object, NSError *error) {
        cell.imagePerson.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:object[@"image"]]]];
        cell.namePerson.text = object[@"name"];
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFUser *user = [PFUser currentUser];
    PFObject *message = conversations[indexPath.row];
    NSString *personID = [message[@"person1"] isEqualToString:user.objectId] ? message[@"person2"] : message[@"person1"];
    
    PFQuery *queryPerson = [PFUser query];
    [queryPerson getObjectInBackgroundWithId:personID block:^(PFObject *object, NSError *error) {
        ChatViewController *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"ChatViewController"];
        [chat setDestinationUser:(PFUser*)object];
        [self.navigationController pushViewController: chat animated:YES];
    }];
}

@end
