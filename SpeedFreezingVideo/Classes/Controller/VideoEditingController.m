//
//  VideoEditingController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/18.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "VideoEditingController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayingView.h"
#import "SpeedFreezesOperatingView.h"

@interface VideoEditingController () <SpeedFreezesOperatingViewDelegate>
@property (weak, nonatomic) IBOutlet VideoPlayingView *videoPlayerView;
@property (weak, nonatomic) IBOutlet UIView *videoTrimmerHolderView;

@property (strong, nonatomic) NSURL *assetUrl;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) SpeedFreezesOperatingView *operatingView;
@end

@implementation VideoEditingController

- (instancetype)initWithAssetUrl:(NSURL *)assetUrl {
    self = [super init];
    if (self) {
        _assetUrl = assetUrl;
        _playerItem = [[AVPlayerItem alloc] initWithURL:assetUrl];
    }
    return self;
}

- (instancetype)initWithPlayItem:(AVPlayerItem *)playItem {
    self = [super init];
    if (self) {
        _playerItem = playItem;
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player pause];
    _player = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self readyToTrim];
    [self readyToPlay];
}

- (void)readyToPlay {
    if (_playerItem == nil) {
        NSLog(@"ERROR: 读取播放资源错误");
    }
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    [self.videoPlayerView setPlayer:_player];
    [_player play];
}

- (void)readyToTrim {
    CGFloat operatingViewWidth = _videoTrimmerHolderView.frame.size.width;
    CGFloat operatingViewHeight = _videoTrimmerHolderView.frame.size.height;
    
    //todo SpeedFreezesOperatingView
    self.operatingView = [[SpeedFreezesOperatingView alloc] initWithFrame:CGRectMake(0, 0, operatingViewWidth, operatingViewHeight) videoUrl:_assetUrl];
    _operatingView.delegate = self;
    [self.videoTrimmerHolderView addSubview:_operatingView];
}

- (void)playerItemDidEnd:(NSNotification *)notify {
    [_player seekToTime:CMTimeMake(0, 1)];
}

#pragma mark - delegate
- (void)operatingViewRangeDidChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    [_player pause];
    //取消任何seek请求
    [_playerItem cancelPendingSeeks];
    [_player seekToTime:CMTimeMakeWithSeconds(leftPosition, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)operatingViewRangeDidGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    //设置视频可播放范围
    [_playerItem setReversePlaybackEndTime:CMTimeMakeWithSeconds(leftPosition, NSEC_PER_SEC)];
    [_playerItem setForwardPlaybackEndTime:CMTimeMakeWithSeconds(rightPosition, NSEC_PER_SEC)];
}

- (void)operatingViewSpeedDidChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
//    NSLog(@"beigin %.2f -- end %.2f", leftPosition, rightPosition);
    [_player pause];
    //取消任何seek请求
    [_playerItem cancelPendingSeeks];
    [_player seekToTime:CMTimeMakeWithSeconds(leftPosition, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)operatingViewSpeedDidGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
    
}

//- (void)videoRange:(SAVideoRangeSlider *)videoRange didChangeLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
//    NSLog(@"beigin %.2f -- end %.2f", leftPosition, rightPosition);
//    
//    [_player pause];
//    //取消任何seek请求
//    [_playerItem cancelPendingSeeks];
//    [_player seekToTime:CMTimeMakeWithSeconds(leftPosition, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
//}
//
//- (void)videoRange:(SAVideoRangeSlider *)videoRange didGestureStateEndedLeftPosition:(CGFloat)leftPosition rightPosition:(CGFloat)rightPosition {
//    
//    //设置视频可播放范围
//    [_playerItem setReversePlaybackEndTime:CMTimeMakeWithSeconds(leftPosition, NSEC_PER_SEC)];
//    [_playerItem setForwardPlaybackEndTime:CMTimeMakeWithSeconds(rightPosition, NSEC_PER_SEC)];
//}


- (IBAction)clickPlayButton:(id)sender {
    [_player play];
}

- (IBAction)clickOperatingSpeedButton:(id)sender {
    [_operatingView switchSpeedSlider];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
