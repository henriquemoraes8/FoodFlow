//
//  FoodAdvertisementModel.h
//  SampleCS316
//
//  Created by Henrique Moraes on 16/10/14.
//  Copyright (c) 2014 its4company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodAdvertisementModel : NSObject

@property (strong,nonatomic) NSString *imageUser;
@property (strong,nonatomic) NSString *foodAvailable;
@property BOOL  isOnCampus;
@property (strong,nonatomic) NSString *userName;
@property (strong,nonatomic) NSString *discountRate;

@end
