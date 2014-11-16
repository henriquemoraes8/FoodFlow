//
//  ProfileViewController.m
//  FoodFlow
//
//  Created by Henrique Moraes on 13/11/14.
//  Copyright (c) 2014 FoodFlow Inc. All rights reserved.
//

#import "ProfileViewController.h"

#define blueColor [UIColor colorWithRed:5.0/255.0 green:102.0/255.0 blue:142.0/255.0 alpha:1]

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _buttonApply.layer.borderWidth = 2;
    _buttonApply.layer.borderColor = blueColor.CGColor;
    _buttonApply.layer.cornerRadius = 8;
    
    _fieldAddress.layer.cornerRadius = 8;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
