//
//  ChatListViewController.h
//  FoodFlow
//
//  Created by Elder Yoshida on 12/8/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ChatViewController.h"

@interface ChatListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
- (UIViewController *) getChatViewController:(PFUser *)user;
@property (weak, nonatomic) IBOutlet UITableView *tableChats;

@end
