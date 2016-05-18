//
//  CaptureVideoButton.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/18.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "CaptureVideoButton.h"

const CGFloat encircleRatio = 1/12.0f;
const CGFloat animationDuration = 0.5f;

@interface CaptureVideoButton()
@property (strong, nonatomic) CAShapeLayer *spotShapeLayer;
@property (assign, nonatomic) CGRect spotRect;
@property (assign, nonatomic) CGRect blockRect;
@property (assign, nonatomic) CGFloat encircleWidth;
@property (assign, nonatomic) CGRect encircleRect;
@end



@implementation CaptureVideoButton

- (CAShapeLayer *)spotShapeLayer {
    if (_spotShapeLayer == nil) {
        _spotShapeLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_spotShapeLayer];
    }
    return _spotShapeLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //外围圈圈
    self.encircleWidth = self.bounds.size.height * encircleRatio;
    self.encircleRect = CGRectInset(self.bounds, _encircleWidth/2, _encircleWidth/2);
    //圆点
    self.spotRect = CGRectInset(self.bounds, _encircleWidth * 1.3, _encircleWidth * 1.3);
    //方块
    self.blockRect = CGRectInset(_spotRect, _spotRect.size.height * 0.3, _spotRect.size.height * 0.3);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //外围
    UIBezierPath *encirclePath = [UIBezierPath bezierPathWithOvalInRect:_encircleRect];
    encirclePath.lineWidth = _encircleWidth;
    [[UIColor whiteColor] setStroke];
    [encirclePath stroke];
    
    //内部
    UIBezierPath *spotPath = [UIBezierPath bezierPathWithOvalInRect:_spotRect];
    self.spotShapeLayer.path = spotPath.CGPath;
    [self.spotShapeLayer setFillColor:[UIColor redColor].CGColor];
}

- (void)beginCaptureAnimation {
    CABasicAnimation *beginAnim = [CABasicAnimation animationWithKeyPath:@"path"];
    
    CGFloat cornerRadius = _spotRect.size.height * 0.1;
    UIBezierPath *blockPath = [UIBezierPath bezierPathWithRoundedRect:_blockRect cornerRadius:cornerRadius];
    
    beginAnim.fromValue = (__bridge id _Nullable)(_spotShapeLayer.path);
    beginAnim.toValue = (__bridge id _Nullable)(blockPath.CGPath);
    beginAnim.duration = animationDuration;
    
    [_spotShapeLayer addAnimation:beginAnim forKey:@"beginAnim"];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _spotShapeLayer.path = blockPath.CGPath;
    [CATransaction commit];
}



@end
