//
//  ChatListViewCell.h
//  FoodFlow
//
//  Created by Elder Yoshida on 12/8/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatListViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagePerson;
@property (weak, nonatomic) IBOutlet UILabel *namePerson;
@property (weak, nonatomic) IBOutlet UILabel *labelMessage;
@property (weak, nonatomic) IBOutlet UILabel *labelDate;


@end
