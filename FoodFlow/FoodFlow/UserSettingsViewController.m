//
//  UserSettingsViewController.m
//  FoodFlow
//
//  Created by Henrique Moraes on 07/12/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "UserSettingsViewController.h"
#import "AppDelegate.h"

@implementation UserSettingsViewController

- (IBAction)buttonSaveSettings:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *amount = [formatter numberFromString:_fieldAvailablePoints.text];
    if (!amount) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input not numerical" message:@"The food point amount is should be a numerical input" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSNumber *discount = [formatter numberFromString:_fieldDiscountRate.text];
    if (!discount || discount.floatValue > 100.0 || discount.floatValue < 0.0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input incorrect" message:@"The discount rate should be a value between 0 and 100" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    PFUser *user = [PFUser currentUser];
    user[@"sellAmount"] = amount;
    user[@"isSeller"] = _switchSeller.isOn ? @YES : @NO;
    user[@"discountRate"] = _fieldDiscountRate.text;
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }];
}


@end
