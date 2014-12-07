//
//  FoodPointAdvertisementViewController.m
//  SampleCS316
//
//  Created by Henrique Moraes on 16/10/14.
//  Copyright (c) 2014 its4company. All rights reserved.
//

#import "FoodPointAdvertisementViewController.h"
#import "FoodAdvertisementTableViewCell.h"
#import "AppDelegate.h"

@interface FoodPointAdvertisementViewController ()
{
    NSArray *users;
}
@end

@implementation FoodPointAdvertisementViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            
            PFUser *user = [PFUser currentUser];
            PFQuery *query = [PFQuery queryWithClassName:@"_User"];
            [query whereKey:@"sellAmount" greaterThanOrEqualTo:user[@"buyAmount"]];
            [query whereKey:@"isSeller" equalTo:@YES];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
                    
                    for (PFObject *object in objects) {
                        NSLog(@"%@", object.objectId);
                    }
                    
                    users = objects;
                    [_tableAnnouncements reloadData];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];

        });
    });
   }

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return users.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodAdvertisementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFUser *user = users[indexPath.row];
    cell.name.text = user[@"name"];
    cell.foodAvailable.text = [NSString stringWithFormat:@"Food Available: $%@",user[@"sellAmount"]];
    cell.discount.text = [NSString stringWithFormat:@"Discount: %@%%",user[@"discountRate"]];
    
    cell.image.layer.borderColor = [UIColor colorWithRed:1.0/255.0 green:86.0/255.0 blue:128.0/255.0 alpha:1].CGColor;
    cell.image.layer.borderWidth = 2.0;
    cell.image.layer.masksToBounds = YES;
    cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user[@"image"]]]];
    cell.image.layer.cornerRadius = cell.image.frame.size.height/2;
    
    cell.status.layer.cornerRadius = cell.status.frame.size.height/2;
    cell.status.layer.masksToBounds = YES;
    cell.status.backgroundColor = [UIColor greenColor];//model.isOnCampus ? [UIColor greenColor] : [UIColor grayColor];
    
    return cell;
}

@end
