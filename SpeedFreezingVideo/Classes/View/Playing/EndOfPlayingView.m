//
//  EndOfPlayingView.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/8/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "EndOfPlayingView.h"

@implementation EndOfPlayingView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self setAlpha:0.5];
    [self setFrame:[[UIScreen mainScreen] bounds]];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [titleLabel setText:@"asd按钮去哪了"];
    [self addSubview:titleLabel];
//    NSDictionary *layoutViews = NSDictionaryOfVariableBindings(titleLabel);
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:titleLabel attribute:NSLayoutAttributeBottom multiplier:1.f constant:20.f]];
}

@end
