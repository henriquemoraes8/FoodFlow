//
//  FoodAdvertisementTableViewCell.h
//  SampleCS316
//
//  Created by Henrique Moraes on 16/10/14.
//  Copyright (c) 2014 its4company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodAdvertisementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *foodAvailable;
@property (weak, nonatomic) IBOutlet UILabel *discount;


@property (weak, nonatomic) IBOutlet UIView *status;

@end
