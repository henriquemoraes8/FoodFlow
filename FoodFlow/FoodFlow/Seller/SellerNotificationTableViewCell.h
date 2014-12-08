//
//  SellerNotificationTableViewCell.h
//  FoodFlow
//
//  Created by Elder Yoshida on 12/7/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerNotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *foodAvailable;
@property (weak, nonatomic) IBOutlet UILabel *discount;


@property (weak, nonatomic) IBOutlet UIView *status;
@end
