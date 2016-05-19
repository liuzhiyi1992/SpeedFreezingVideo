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
const CGFloat speedSliderHeight = 20;

@interface SpeedFreezesOperatingView () <SAVideoRangeSliderDelegate>
@property (strong, nonatomic) NSURL *videoUrl;

@property (strong, nonatomic) SAVideoRangeSlider *saVideoRangeSlider;

@property (strong, nonatomic) UIImageView *leftSpeedSlider;
@property (strong, nonatomic) UIImageView *rightSpeedSlider;

@property (assign, nonatomic) CGFloat leftPosition;
@property (assign, nonatomic) CGFloat rightPosition;
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
    self.leftSpeedSlider.center = CGPointMake(_leftPosition, speedSliderHeight/2);
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
    self.leftPosition = _saVideoRangeSlider.thumbWidth;
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
    
    //todo frame
    self.rightSpeedSlider = [[UIImageView alloc] init];
    [_rightSpeedSlider setBackgroundColor:[UIColor redColor]];
    [_rightSpeedSlider setUserInteractionEnabled:YES];
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    [_rightSpeedSlider addGestureRecognizer:rightPan];
    [self addSubview:_rightSpeedSlider];
}

- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"work");
        CGPoint translation = [gesture translationInView:self];
        
        if (_leftPosition + translation.x >= _saVideoRangeSlider.leftPositionCoordinates + _saVideoRangeSlider.thumbWidth) {
            //在视频有效范围内
            self.leftPosition += translation.x;
        }
        if (_leftPosition < 0) {
            self.leftPosition = 0;
        }
        
        [gesture setTranslation:CGPointZero inView:self];
        
        [self setNeedsLayout];
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture {
    
}

#pragma mark - delegate
- (void)videoRange:(SAVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    if ([_delegate respondsToSelector:@selector(operatingViewDidGestureStateEndedLeftPosition:rightPosition:)]) {
        [_delegate operatingViewDidGestureStateEndedLeftPosition:leftPosition rightPosition:rightPosition];
    }
}

- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    if ([_delegate respondsToSelector:@selector(operatingViewDidChangeLeftPosition:rightPosition:)]) {
        [_delegate operatingViewDidChangeLeftPosition:leftPosition rightPosition:rightPosition];
    }
}

@end
