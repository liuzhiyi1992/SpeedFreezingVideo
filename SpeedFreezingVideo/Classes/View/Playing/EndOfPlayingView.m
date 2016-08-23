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
    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
    [self setFrame:[[UIScreen mainScreen] bounds]];
    
    //Labels
    UILabel *topLabel = [[UILabel alloc] init];
    [topLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [topLabel setText:@"THIS VIDEO WAS"];
    [topLabel setFont:[UIFont systemFontOfSize:15.f]];
    [topLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:topLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:topLabel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [titleLabel setText:@"Browse Finished"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:40.f]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    [subTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [subTitleLabel setText:@"Then you can do the next step as follows"];
    [subTitleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [subTitleLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:subTitleLabel];
    NSDictionary *layoutLabels = NSDictionaryOfVariableBindings(topLabel, titleLabel, subTitleLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-130-[topLabel]-5-[titleLabel]-20-[subTitleLabel]" options:NSLayoutFormatAlignAllCenterX metrics:nil views:layoutLabels]];
    
    //Buttons
    UIButton *backToEditButton = [[UIButton alloc] init];
    [backToEditButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backToEditButton setImage:[UIImage imageNamed:@"album_button"] forState:UIControlStateNormal];
    [self addSubview:backToEditButton];
    
    UIButton *replayButton = [[UIButton alloc] init];
    [replayButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [replayButton setImage:[UIImage imageNamed:@"album_button"] forState:UIControlStateNormal];
    [self addSubview:replayButton];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:replayButton attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:replayButton attribute:NSLayoutAttributeBottom multiplier:1.f constant:150.f]];
    
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [saveButton setImage:[UIImage imageNamed:@"album_button"] forState:UIControlStateNormal];
    [self addSubview:saveButton];
    NSDictionary *layoutButtons = NSDictionaryOfVariableBindings(backToEditButton, replayButton, saveButton);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backToEditButton]-40-[replayButton]-40-[saveButton]" options:NSLayoutFormatAlignAllBottom metrics:nil views:layoutButtons]];
    
    //ButtonTitles
    UILabel *backToEditLabel = [[UILabel alloc] init];
    [backToEditLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [backToEditLabel setText:@"BACK TO EDIT"];
    [backToEditLabel setFont:[UIFont systemFontOfSize:14.f]];
    [backToEditLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:backToEditLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:backToEditButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backToEditLabel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:backToEditButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:backToEditLabel attribute:NSLayoutAttributeBottom multiplier:1.f constant:-30.f]];
    
    UILabel *replayLabel = [[UILabel alloc] init];
    [replayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [replayLabel setText:@"REPLAY"];
    [replayLabel setFont:[UIFont systemFontOfSize:14.f]];
    [replayLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:replayLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:replayButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:replayLabel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:replayButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:replayLabel attribute:NSLayoutAttributeBottom multiplier:1.f constant:-30.f]];
    
    UILabel *saveLabel = [[UILabel alloc] init];
    [saveLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [saveLabel setText:@"REPLAY"];
    [saveLabel setFont:[UIFont systemFontOfSize:14.f]];
    [saveLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:saveLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:saveLabel attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0.f]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:saveLabel attribute:NSLayoutAttributeBottom multiplier:1.f constant:-30.f]];
}

@end
