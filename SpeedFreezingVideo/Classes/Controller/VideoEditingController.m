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
#import "SAVideoRangeSlider.h"
#import "SpeedFreezesOperatingView.h"

@interface VideoEditingController () <SAVideoRangeSliderDelegate, SpeedFreezesOperatingViewDelegate>
@property (weak, nonatomic) IBOutlet VideoPlayingView *videoPlayerView;
@property (weak, nonatomic) IBOutlet UIView *videoTrimmerHolderView;

@property (strong, nonatomic) NSURL *assetUrl;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic) AVPlayer *player;

@property (strong, nonatomic) SAVideoRangeSlider *saVideoRangeSlider;
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
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.translucent = NO;
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
    SpeedFreezesOperatingView *operatingView = [[SpeedFreezesOperatingView alloc] initWithFrame:CGRectMake(0, 0, operatingViewWidth, operatingViewHeight) videoUrl:_assetUrl];
    operatingView.delegate = self;
    [self.videoTrimmerHolderView addSubview:operatingView];
    
    
    
//    self.saVideoRangeSlider = [[SAVideoRangeSlider alloc] initWithFrame:CGRectMake(0, 0, sliderWidth, sliderHeight) videoUrl:_assetUrl];
//    [_saVideoRangeSlider setPopoverBubbleSize:0 height:0];
//    
//    // Purple
//    _saVideoRangeSlider.topBorder.backgroundColor = [UIColor colorWithRed: 0.768 green: 0.665 blue: 0.853 alpha:1.f];
//    _saVideoRangeSlider.bottomBorder.backgroundColor = [UIColor colorWithRed: 0.535 green: 0.329 blue: 0.707 alpha:1.f];
//    
//    _saVideoRangeSlider.delegate = self;
//    
//    [self.videoTrimmerHolderView addSubview:_saVideoRangeSlider];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
