//
//  ChatViewController.h
//  FoodFlow
//
//  Created by Elder Yoshida on 12/8/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UIBubbleTableView.h"
#import "NSBubbleData.h"


@interface ChatViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *chatlist;
-(void) setDestinationUser:(PFUser *) user;
@end
