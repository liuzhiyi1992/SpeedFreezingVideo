//
//  SpeedFreezesOperatingView.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/19.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SpeedFreezesOperatingViewDelegate <NSObject>

- (void)operatingViewDidGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;
- (void)operatingViewDidChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;

@end

@interface SpeedFreezesOperatingView : UIView
@property (weak ,nonatomic) id<SpeedFreezesOperatingViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl;

@end
