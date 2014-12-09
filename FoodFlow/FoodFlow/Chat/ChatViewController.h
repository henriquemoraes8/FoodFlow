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


@interface ChatViewController : UIViewController<UIBubbleTableViewDataSource>

-(void) setDestinationUser:(PFUser *) user;
//@property (weak, nonatomic) PFUser* destinationUser;

-(void) sendDefaultMessage;


@end
