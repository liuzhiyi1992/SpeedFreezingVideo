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
#import <AssetsLibrary/AssetsLibrary.h>

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

- (void)speedFreezingWithAssetUrl:(NSURL *)URl beginTime:(CMTime)beginTime endTime:(CMTime)endTime {
    AVURLAsset* videoAsset = [AVURLAsset URLAssetWithURL:URl options:nil]; //self.inputAsset;
    
    AVAsset *currentAsset = [AVAsset assetWithURL:URl];
    AVAssetTrack *vdoTrack = [[currentAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //create mutable composition
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    
    
    NSError *videoInsertError = nil;
    BOOL videoInsertResult = [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                                            ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                                             atTime:kCMTimeZero
                                                              error:&videoInsertError];
    if (!videoInsertResult || nil != videoInsertError) {
        //handle error
        return;
    }
    
    NSError *audioInsertError =nil;
    BOOL audioInsertResult =[compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                                           ofTrack:[[currentAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                                            atTime:kCMTimeZero
                                                             error:&audioInsertError];
    if (!audioInsertResult || nil != audioInsertError) {
        //handle error
        return;
    }
    
    CMTime duration = kCMTimeZero;
    duration = CMTimeAdd(duration, currentAsset.duration);
    //slow down whole video by 2.0
    double videoScaleFactor = 3.0;
    CMTime videoDuration = videoAsset.duration;
    
    //todo 自己加
//    CMTime beginTime = CMTimeMake(1.5, 1);
//    CMTime remainDuration = CMTimeMake(2, 1);
    CMTime remainDuration = CMTimeSubtract(endTime, beginTime);
    CMTime operatedTime = CMTimeMake(remainDuration.value * videoScaleFactor, remainDuration.timescale);
    CMTime extraTime = CMTimeSubtract(operatedTime, remainDuration);
    
    
    [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(beginTime, remainDuration)
                               toDuration:CMTimeMake(remainDuration.value * videoScaleFactor, remainDuration.timescale)];
    [compositionAudioTrack scaleTimeRange:CMTimeRangeMake(beginTime, remainDuration)
                               toDuration:CMTimeMake(remainDuration.value * videoScaleFactor, remainDuration.timescale)];
    
    
    //    [compositionVideoTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                               toDuration:CMTimeMake(videoDuration.value * videoScaleFactor, videoDuration.timescale)];
    //    [compositionAudioTrack scaleTimeRange:CMTimeRangeMake(kCMTimeZero, videoDuration)
    //                               toDuration:CMTimeMake(videoDuration.value * videoScaleFactor, videoDuration.timescale)];
    [compositionVideoTrack setPreferredTransform:vdoTrack.preferredTransform];
    
    
    //---配置outputPath
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"slowMotion.mov"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    NSURL *_filePath = [NSURL fileURLWithPath:outputFilePath];
    
    //todo 自己加
    //    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithAsset:mixComposition];
    //    [self pushToPlayWithAsset:mixComposition];
    
    
    //todo 稳定后修改下视频质量
    //export
    AVAssetExportSession* assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                         presetName:AVAssetExportPreset1920x1080];
    NSLog(@"----%@", assetExport.supportedFileTypes);
    
    assetExport.outputURL = _filePath;
    //todo 改了
    //    assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    assetExport.outputFileType = assetExport.supportedFileTypes.firstObject;
    assetExport.shouldOptimizeForNetworkUse = YES;
    
    //trimming
    CMTime trimmingEndTime = CMTimeAdd(_playerItem.forwardPlaybackEndTime, extraTime);
    CMTimeRange timeRange = CMTimeRangeMake(_playerItem.reversePlaybackEndTime, trimmingEndTime);
    assetExport.timeRange = timeRange;
    
    
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([assetExport status]) {
            case AVAssetExportSessionStatusFailed:
            {
                NSLog(@"Export session faiied with error: %@", [assetExport error]);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // completion(nil);
                });
            }
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog(@"Successful");
                NSURL *outputURL = assetExport.outputURL;
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
                    
                    [self writeExportedVideoToAssetsLibrary:outputURL];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // completion(_filePath);
                });
                
            }
                break;
            default:
                
                break;
        }
    }];
}

- (void)writeExportedVideoToAssetsLibrary :(NSURL *)url {
    NSURL *exportURL = url;
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:exportURL completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                                        message:[error localizedRecoverySuggestion]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                }
                if(!error)
                {
                    // [activityView setHidden:YES];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sucess"
                                                                        message:@"video added to gallery successfully"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    //todo 改了
                    //                    [alertView show];
//                    [self pushToPlay:assetURL];
                    NSLog(@"保存成功");
                    
                }
#if !TARGET_IPHONE_SIMULATOR
                [[NSFileManager defaultManager] removeItemAtURL:exportURL error:nil];
#endif
            });
        }];
    } else {
        NSLog(@"Video could not be exported to assets library.");
    }
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

#pragma mark - Action
- (IBAction)clickPlayButton:(id)sender {
    [_player play];
}

- (IBAction)clickOperatingSpeedButton:(id)sender {
    [_operatingView switchSpeedSlider];
}

- (IBAction)clickFinishButton:(id)sender {
    //先修改速度
    [self speedFreezingWithAssetUrl:_assetUrl beginTime:[_operatingView speedOperateVideoBeginTime] endTime:[_operatingView speedOperateVideoEndTime]];
    //再剪辑视频
    
}





- (void)trimmingVideoWithAsset:(AVAsset *)asset {
    
    //配置path
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    //todo 以上两步为何
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"trimmingAsset.mov"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputFilePath]) {
        NSError *error;
        if (![[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:&error]) {
            NSLog(@"ERROR: 清除旧文件发生错误");
        }
    }
    NSURL *outputUrl = [NSURL fileURLWithPath:outputFilePath];
    
    //export
    AVAsset *trimmingAsset = [AVAsset assetWithURL:_assetUrl];
    AVAssetExportSession *trimmingExportSession = [[AVAssetExportSession alloc] initWithAsset:trimmingAsset presetName:AVCaptureSessionPresetHigh];
    trimmingExportSession.outputURL = outputUrl;
    trimmingExportSession.outputFileType = AVFileTypeMPEG4;
    trimmingExportSession.shouldOptimizeForNetworkUse = YES;
    
    //异步输出
    [trimmingExportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([trimmingExportSession status]) {
            case AVAssetExportSessionStatusFailed:
            {
                NSLog(@"Export session faiied with error: %@", [trimmingExportSession error]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // completion(nil);
                });
            }
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog(@"Successful");
                NSURL *outputURL = trimmingExportSession.outputURL;
                
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
                    
                    [self writeExportedVideoToAssetsLibrary:outputURL];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    // completion(_filePath);
                });
            }
                break;
            default:
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
