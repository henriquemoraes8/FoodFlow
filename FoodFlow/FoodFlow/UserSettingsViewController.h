//
//  UserSettingsViewController.h
//  FoodFlow
//
//  Created by Henrique Moraes on 07/12/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *fieldAvailablePoints;

@property (weak, nonatomic) IBOutlet UITextField *fieldDiscountRate;
@property (weak, nonatomic) IBOutlet UISwitch *switchSeller;

- (IBAction)buttonSaveSettings:(id)sender;
- (IBAction)logout:(id)sender;

@end
