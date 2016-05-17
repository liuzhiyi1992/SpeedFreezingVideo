//
//  CapturePreviewView.h
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/17.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;
@interface CapturePreviewView : UIView
@property (strong, nonatomic) AVCaptureSession *session;
@end
