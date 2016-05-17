//
//  CapturePreviewView.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/17.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "CapturePreviewView.h"
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>

@interface CapturePreviewView()


@end

@implementation CapturePreviewView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    [(AVCaptureVideoPreviewLayer *)self.layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}

+ (Class)layerClass {
    return [AVCaptureVideoPreviewLayer class];
}

- (void)setSession:(AVCaptureSession *)session {
    [(AVCaptureVideoPreviewLayer *)self.layer setSession:session];
}

- (void)singleTap:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    [_delegate previewViewFocusAtCapturePoint:point];
    //动画
    //对焦 测光
}

- (CGPoint)captureDevicePointForCameraPoint:(CGPoint)point {
    AVCaptureVideoPreviewLayer *layer = (AVCaptureVideoPreviewLayer *)self.layer;
    return [layer captureDevicePointOfInterestForPoint:point];
}

@end
