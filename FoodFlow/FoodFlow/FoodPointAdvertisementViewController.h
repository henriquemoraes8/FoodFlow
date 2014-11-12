//
//  FoodPointAdvertisementViewController.h
//  SampleCS316
//
//  Created by Henrique Moraes on 16/10/14.
//  Copyright (c) 2014 its4company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodPointAdvertisementViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableAnnouncements;

@end
