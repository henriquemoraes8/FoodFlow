//
//  PurchaseInformationViewController.m
//  FoodFlow
//
//  Created by Henrique Moraes on 07/12/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "PurchaseInformationViewController.h"
#import "AppDelegate.h"

@implementation PurchaseInformationViewController


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PFUser *user = [PFUser currentUser];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *amount = [formatter numberFromString:_fieldEstimateAmount.text];
    user[@"buyAmount"] = amount;
    user[@"meetLocation"] = _fieldMeetingLocation.text;
    [user saveInBackground];
}
        
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *amount = [formatter numberFromString:_fieldEstimateAmount.text];
    
    if (!amount) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Input not numerical" message:@"The purchase amount is should be a numerical input" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    return amount ? YES : NO;
}

-(IBAction)fieldEstimateDismiss:(id)sender{
    [self.fieldEstimateAmount resignFirstResponder];
}

- (IBAction)fieldMeetingLocationDismiss:(id)sender {
    [self.fieldMeetingLocation resignFirstResponder];
}
@end
