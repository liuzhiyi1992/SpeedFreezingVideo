//
//  FullScreemDisplayController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/29.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "FullScreemDisplayController.h"
#import "VideoPlayingView.h"

@interface FullScreemDisplayController ()
@property (weak, nonatomic) IBOutlet VideoPlayingView *videoPlayingView;
@property (assign, nonatomic) AVCaptureVideoOrientation videoOrientation;
@property (strong, nonatomic) AVPlayer *player;

@end

@implementation FullScreemDisplayController

- (instancetype)initWithPlayer:(AVPlayer *)player videoOrientation:(AVCaptureVideoOrientation)videoOrientation {
    self = [super init];
    if (self) {
        _player = player;
        _videoOrientation = videoOrientation;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self registerNotification];
    [_videoPlayingView setPlayer:_player];
    [_videoPlayingView setVideoGravity:AVLayerVideoGravityResizeAspect];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //transform
    if (_videoOrientation == AVCaptureVideoOrientationLandscapeLeft || _videoOrientation == AVCaptureVideoOrientationLandscapeRight) {
        self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    }
    //play
    [_player play];
}

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playerItemDidEnd:(NSNotification *)notify {
    [_player seekToTime:kCMTimeZero];
    NSLog(@"播放完毕");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_player pause];
    //todo 弹出操作按钮
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
