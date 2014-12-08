//
//  SellerNotificationTableViewCell.h
//  FoodFlow
//
//  Created by Elder Yoshida on 12/7/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerNotificationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageSeller;
@property (weak, nonatomic) IBOutlet UIImageView *imageBuyer;
@property (weak, nonatomic) IBOutlet UILabel *nameSeller;
@property (weak, nonatomic) IBOutlet UILabel *labelPayment;

@property (weak, nonatomic) IBOutlet UILabel *nameBuyer;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;
@property (weak, nonatomic) IBOutlet UILabel *labelLocation;

@end
