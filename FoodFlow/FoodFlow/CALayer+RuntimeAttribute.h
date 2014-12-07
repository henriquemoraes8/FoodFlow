//
//  CALayer+RuntimeAttribute.h
//  its4schools
//
//  Created by Henrique Moraes on 25/11/14.
//  Copyright (c) 2014 its4company. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (RuntimeAttribute)

@property(nonatomic, assign) UIColor* borderIBColor;
@property(nonatomic, assign) UIColor* shadowIBColor;

@end
