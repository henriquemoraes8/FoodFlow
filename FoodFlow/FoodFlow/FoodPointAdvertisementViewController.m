//
//  FoodPointAdvertisementViewController.m
//  SampleCS316
//
//  Created by Henrique Moraes on 16/10/14.
//  Copyright (c) 2014 its4company. All rights reserved.
//

#import "FoodPointAdvertisementViewController.h"
#import "FoodAdvertisementModel.h"
#import "FoodAdvertisementTableViewCell.h"

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FoodAdvertisementModel *f1 = [FoodAdvertisementModel new];
    f1.userName = @"Regina Rusca";
    f1.foodAvailable = @"101.8";
    f1.discountRate = @"85";
    f1.isOnCampus = YES;
    f1.imageUser = @"http://www.its4.com/uploads/people/18-8-58-423-1299.png";
    
    FoodAdvertisementModel *f2 = [FoodAdvertisementModel new];
    f2.userName = @"Gabriela Medeiros";
    f2.foodAvailable = @"881.5";
    f2.discountRate = @"79";
    f2.isOnCampus = NO;
    f2.imageUser = @"http://www.its4.com/uploads/people/8-24-47-18-1749.png";
    
    FoodAdvertisementModel *f3 = [FoodAdvertisementModel new];
    f3.userName = @"Luiz Paulo";
    f3.foodAvailable = @"709.8";
    f3.discountRate = @"89";
    f3.isOnCampus = NO;
    f3.imageUser = @"http://www.its4.com/uploads/people/11-34-17-831-1894.png";
    
    FoodAdvertisementModel *f4 = [FoodAdvertisementModel new];
    f4.userName = @"Ivan Pedroso";
    f4.foodAvailable = @"1201.8";
    f4.discountRate = @"98";
    f4.isOnCampus = YES;
    f4.imageUser = @"http://www.its4.com/uploads/people/16-31-16-382-0.png";
    
    FoodAdvertisementModel *f5 = [FoodAdvertisementModel new];
    f5.userName = @"Ivan Pedroso";
    f5.foodAvailable = @"401.79";
    f5.discountRate = @"74";
    f5.isOnCampus = NO;
    f5.imageUser = @"http://www.its4.com/uploads/people/13-44-9-133-1784.png";
    
    FoodAdvertisementModel *f6 = [FoodAdvertisementModel new];
    f6.userName = @"Luis Paulo";
    f6.foodAvailable = @"1044.8";
    f6.discountRate = @"87";
    f6.isOnCampus = YES;
    f6.imageUser = @"http://www.its4.com/uploads/people/15-12-38-185-0.png";
    
    FoodAdvertisementModel *f7 = [FoodAdvertisementModel new];
    f7.userName = @"Regina Rusca";
    f7.foodAvailable = @"101.8";
    f7.discountRate = @"85";
    f7.isOnCampus = YES;
    f7.imageUser = @"http://www.its4.com/uploads/people/18-8-58-423-1299.png";
    
    FoodAdvertisementModel *f8 = [FoodAdvertisementModel new];
    f8.userName = @"Gabriela Medeiros";
    f8.foodAvailable = @"881.5";
    f8.discountRate = @"79";
    f8.isOnCampus = NO;
    f8.imageUser = @"http://www.its4.com/uploads/people/8-24-47-18-1749.png";
    
    FoodAdvertisementModel *f9 = [FoodAdvertisementModel new];
    f9.userName = @"Luiz Paulo";
    f9.foodAvailable = @"709.8";
    f9.discountRate = @"89";
    f9.isOnCampus = NO;
    f9.imageUser = @"http://www.its4.com/uploads/people/11-34-17-831-1894.png";
    
    FoodAdvertisementModel *f10 = [FoodAdvertisementModel new];
    f10.userName = @"Ivan Pedroso";
    f10.foodAvailable = @"1201.8";
    f10.discountRate = @"98";
    f10.isOnCampus = YES;
    f10.imageUser = @"http://www.its4.com/uploads/people/16-31-16-382-0.png";
    
    users = @[f1,f2,f3,f4,f5,f6,f7,f8,f9,f10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return users.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FoodAdvertisementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    FoodAdvertisementModel *model = users[indexPath.row];
    cell.name.text = model.userName;
    cell.foodAvailable.text = [NSString stringWithFormat:@"Food Available: $%@",model.foodAvailable];
    cell.discount.text = [NSString stringWithFormat:@"Discount: %@%%",model.discountRate];
    
    cell.image.layer.borderColor = [UIColor colorWithRed:1.0/255.0 green:86.0/255.0 blue:128.0/255.0 alpha:1].CGColor;
    cell.image.layer.borderWidth = 2.0;
    cell.image.layer.masksToBounds = YES;
    cell.image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageUser]]];
    cell.image.layer.cornerRadius = cell.image.frame.size.height/2;
    
    cell.status.layer.cornerRadius = cell.status.frame.size.height/2;
    cell.status.layer.masksToBounds = YES;
    cell.status.backgroundColor = model.isOnCampus ? [UIColor greenColor] : [UIColor grayColor];
    
    return cell;
}

@end
