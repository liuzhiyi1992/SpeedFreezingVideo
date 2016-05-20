//
//  SpeedFreezesOperatingView.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/19.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "SpeedFreezesOperatingView.h"
#import "SAVideoRangeSlider.h"

const CGFloat speedSliderWidth = 20;
const CGFloat speedSliderHeight = 30;

@interface SpeedFreezesOperatingView () <SAVideoRangeSliderDelegate>
@property (strong, nonatomic) NSURL *videoUrl;

@property (strong, nonatomic) SAVideoRangeSlider *saVideoRangeSlider;

@property (strong, nonatomic) UIImageView *leftSpeedSlider;
@property (strong, nonatomic) UIImageView *rightSpeedSlider;

@property (assign, nonatomic) CGFloat leftPositionCoordinates;//leftSpeedSliderCenterCoordinates
@property (assign, nonatomic) CGFloat rightPositionCoordinates;//rightSpeedSliderCenterCoordinates
@end

@implementation SpeedFreezesOperatingView


- (instancetype)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl {
    self = [super initWithFrame:frame];
    if (self) {
        _videoUrl = videoUrl;
        [self configureView];
    }
    return self;
}

- (void)layoutSubviews {
    //更新配置水滴的位置
    self.leftSpeedSlider.center = CGPointMake(_leftPositionCoordinates, speedSliderHeight/2);
    self.rightSpeedSlider.center = CGPointMake(_rightPositionCoordinates, speedSliderHeight/2);
}

- (void)configureView {
    CGFloat sliderWidth = self.bounds.size.width;
    CGFloat sliderHeight = self.bounds.size.height - speedSliderHeight;
    self.saVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, speedSliderHeight, sliderWidth, sliderHeight) videoUrl:_videoUrl];
    [_saVideoRangeSlider setPopoverBubbleSize:0 height:0];
    // Purple
    _saVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.768 green: 0.665 blue: 0.853 alpha:1.f];
    _saVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.535 green: 0.329 blue: 0.707 alpha:1.f];
    _saVideoRangeSlider.delegate = self;
    [self addSubview:_saVideoRangeSlider];
    
    
    //初值
    self.leftPositionCoordinates = _saVideoRangeSlider.thumbWidth;
    self.rightPositionCoordinates = self.bounds.size.width - _saVideoRangeSlider.thumbWidth;
    //    self.rightPosition =
    
    
    [self configureSpeedSlider];
}

- (void)configureSpeedSlider {
    self.leftSpeedSlider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, speedSliderWidth, speedSliderHeight)];
    [_leftSpeedSlider setBackgroundColor:[UIColor redColor]];
    [_leftSpeedSlider setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
    [_leftSpeedSlider addGestureRecognizer:leftPan];
    [self addSubview:_leftSpeedSlider];
    
    
    self.rightSpeedSlider = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, speedSliderWidth, speedSliderHeight)];
    [_rightSpeedSlider setBackgroundColor:[UIColor redColor]];
    [_rightSpeedSlider setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    [_rightSpeedSlider addGestureRecognizer:rightPan];
    [self addSubview:_rightSpeedSlider];
}

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        if (_leftPositionCoordinates + translation.x >= _saVideoRangeSlider.leftPositionCoordinates + _saVideoRangeSlider.thumbWidth) {
            //在视频有效范围内
            self.leftPositionCoordinates += translation.x;
        }
        if (_leftPositionCoordinates < 0) {
            self.leftPositionCoordinates = 0;
        }
        [gesture setTranslation:CGPointZero inView:self];
        [self setNeedsLayout];
        [self speedSliderChangeNotification];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self speedSliderGestureStateEndedNotification];
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        if (_rightPositionCoordinates + translation.x <= _saVideoRangeSlider.rightPositionCoordinates - _saVideoRangeSlider.thumbWidth) {
            //在视频有效范围内
            self.rightPositionCoordinates += translation.x;
        }
        if (_rightPositionCoordinates > (self.bounds.size.width - _saVideoRangeSlider.thumbWidth)) {
            _rightPositionCoordinates = self.bounds.size.width - _saVideoRangeSlider.thumbWidth;
        }
        [gesture setTranslation:CGPointZero inView:self];
        [self setNeedsLayout];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self speedSliderGestureStateEndedNotification];
    }
}

- (void)linkageSpeedSliderWithRangeSliderLeft:(CGFloat)leftPositionCoordinates right:(CGFloat)rightPositionCoordinates {
    
    BOOL linkaged = NO;
    //联动 speedSlider只改UI 不做实时范围改变通知 做手势结束范围改变通知
    if (leftPositionCoordinates + _saVideoRangeSlider.thumbWidth > _leftPositionCoordinates) {
        self.leftPositionCoordinates = leftPositionCoordinates + _saVideoRangeSlider.thumbWidth;
        linkaged = YES;
    }
    
    if (rightPositionCoordinates - _saVideoRangeSlider.thumbWidth < _rightPositionCoordinates) {
        self.rightPositionCoordinates = rightPositionCoordinates - _saVideoRangeSlider.thumbWidth;
        linkaged = YES;
    }
    [self setNeedsLayout];
    if (linkaged) {
        [self speedSliderGestureStateEndedNotification];
    }
}

- (void)speedSliderChangeNotification {
    if ([_delegate respondsToSelector:@selector(operatingViewSpeedDidChangeLeftPosition:rightPosition:)]) {
        [_delegate operatingViewSpeedDidChangeLeftPosition:[self speedLeftPositionToVideoPosition] rightPosition:[self speedRightPositionToVideoPosition]];
    }
}

- (void)speedSliderGestureStateEndedNotification {
    if ([_delegate respondsToSelector:@selector(operatingViewSpeedDidGestureStateEndedLeftPosition:rightPosition:)]) {
        [_delegate operatingViewSpeedDidGestureStateEndedLeftPosition:[self speedLeftPositionToVideoPosition] rightPosition:[self speedRightPositionToVideoPosition]];
    }
}

- (CGFloat)speedSliderEffectiveWidth {
    return self.bounds.size.width - 2*_saVideoRangeSlider.thumbWidth;
}

- (CGFloat)speedLeftPositionToVideoPosition {
    return [_saVideoRangeSlider videoDurationSeconds] * (_leftPositionCoordinates - _saVideoRangeSlider.thumbWidth)/ [self speedSliderEffectiveWidth];
}

- (CGFloat)speedRightPositionToVideoPosition {
    return [_saVideoRangeSlider videoDurationSeconds] * (_rightPositionCoordinates - _saVideoRangeSlider.thumbWidth) / [self speedSliderEffectiveWidth];
}


#pragma mark - delegate
- (void)videoRange:(SAVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    if ([_delegate respondsToSelector:@selector(operatingViewRangeDidGestureStateEndedLeftPosition:rightPosition:)]) {
        [_delegate operatingViewRangeDidGestureStateEndedLeftPosition:leftPosition rightPosition:rightPosition];
    }
}

- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    if ([_delegate respondsToSelector:@selector(operatingViewRangeDidChangeLeftPosition:rightPosition:)]) {
        [_delegate operatingViewRangeDidChangeLeftPosition:leftPosition rightPosition:rightPosition];
    }
    //联动speedSlider
    [self linkageSpeedSliderWithRangeSliderLeft:videoRange.leftPositionCoordinates right:videoRange.rightPositionCoordinates];
}


@end
