//
//  SpeedFreezesOperatingView.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/19.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CMTime.h>

@protocol SpeedFreezesOperatingViewDelegate <NSObject>

- (void)operatingViewRangeDidChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;
- (void)operatingViewRangeDidGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;

- (void)operatingViewSpeedDidChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;
- (void)operatingViewSpeedDidGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition;

@end

@interface SpeedFreezesOperatingView : UIView
@property (weak ,nonatomic) id<SpeedFreezesOperatingViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl;
- (BOOL)switchSpeedSlider;
- (CMTime)speedOperateVideoBeginTime;
- (CMTime)speedOperateVideoEndTime;

@end
