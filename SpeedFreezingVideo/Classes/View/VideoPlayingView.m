//
//  VideoPlayingView.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/18.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "VideoPlayingView.h"
#import <AVFoundation/AVPlayerLayer.h>

@implementation VideoPlayingView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (void)awakeFromNib {
    [self configureView];
}

- (void)configureView {
    //填充
    ((AVPlayerLayer *)self.layer).videoGravity = AVLayerVideoGravityResizeAspect;
}
//todo 可能没用了
- (void)setVideoGravity:(NSString *)videoGravity {
    ((AVPlayerLayer *)self.layer).videoGravity = videoGravity;
    
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)self.layer setPlayer:player];
}

@end
