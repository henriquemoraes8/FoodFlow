//
//  PurchaseInformationViewController.h
//  FoodFlow
//
//  Created by Henrique Moraes on 07/12/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseInformationViewController : UIViewController

- (IBAction)fieldEstimateDismiss:(id)sender;
- (IBAction)fieldMeetingLocationDismiss:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *fieldEstimateAmount;
@property (weak, nonatomic) IBOutlet UITextField *fieldMeetingLocation;

@end
