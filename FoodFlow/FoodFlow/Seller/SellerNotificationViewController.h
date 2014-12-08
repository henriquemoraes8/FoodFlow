//
//  SellerNotificationViewController.h
//  FoodFlow
//
//  Created by Rui Xu on 11/16/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerNotificationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableNotifications;

@end
