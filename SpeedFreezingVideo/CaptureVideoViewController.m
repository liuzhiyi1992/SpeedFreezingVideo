//
//  CaptureVideoViewController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "CaptureVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "CapturePreviewView.h"

//todo 发生某些错误需要停止视频拍摄功能，对策：返回上一页

@interface CaptureVideoViewController () <CapturePreviewViewDelegate>
@property (weak, nonatomic) IBOutlet CapturePreviewView *videoPreviewView;

@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (strong, nonatomic) AVCaptureDevice *audioDevice;
@property (strong, nonatomic) AVCaptureDevice *videoDevice;

@property (strong, nonatomic) AVCaptureDeviceInput *audioInput;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;

@property (strong, nonatomic) AVCaptureMovieFileOutput *videoOutput;

@end

@implementation CaptureVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self accessAuthorization];
}

- (void)accessAuthorization {
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:
            [self configureCapture];
            break;
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self configureCapture];
                } else {
                    NSLog(@"被拒绝，如需正常使用请与设置->隐私打开摄像头权限");
                    //todo 提示打开权限方法
                }
            }];
            break;
        }
        case AVAuthorizationStatusDenied:
            NSLog(@"权限被拒绝，如需正常使用请与设置->隐私打开摄像头权限");
            break;
        case AVAuthorizationStatusRestricted:
            NSLog(@"您无法改变被锁定的权限");
            break;
        default:
            break;
    }
}

- (void)configureCapture {
    //开始配置安装
    
    //session
    self.captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    } else {
        NSLog(@"Can not set AVCaptureSession sessionPreset, using default %@", _captureSession.sessionPreset);
    }
    
    
    [_captureSession beginConfiguration];
    
    //使用后置摄像头
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //配置video input
    self.videoInput = [self createMediaInputWithDevice:_videoDevice mediaType:AVMediaTypeVideo];
    [self captureSessionAddInput:_videoInput];
    
    //配置音频
    self.audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    //配置audio input
    self.audioInput = [self createMediaInputWithDevice:_audioDevice mediaType:AVMediaTypeAudio];
    [self captureSessionAddInput:_audioInput];
    
    
    //视频输出
    
    
    
    //配置预览view
    [self configureVideoPreview];
    
    [_captureSession commitConfiguration];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //启动会话
        [_captureSession startRunning];
    });
    
}

- (void)configureVideoOutput {
    self.videoOutput = [[AVCaptureMovieFileOutput alloc] init];
}

//是否有摄像头工作
- (BOOL)hasMultipleCameraDevices {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//    if (devices != nil && [devices count] > 1) {
//        return YES;
//    }
    if (devices != nil) {
        return YES;
    }
    return NO;
}

- (NSUInteger)cameraCount {
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (BOOL)canSwitchCamera {
    return [self cameraCount] > 1;
}

//切换摄像头
- (void)changeCameraDevice {
    if (! [self canSwitchCamera]) {
        NSLog(@"部分摄像头设备无法工作");
        return;
    }
    switch (_videoDevice.position) {
        case AVCaptureDevicePositionBack:
            self.videoDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
            break;
        case AVCaptureDevicePositionFront:
            self.videoDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
            break;
        default:
            break;
    }
    
    //todo 切换时锁定设备，方式同时修改?
    AVCaptureDeviceInput *videoInput = [self createMediaInputWithDevice:_videoDevice mediaType:AVMediaTypeVideo];
    [self captureSessionChangeVideoInput:videoInput];
}

//配置媒体输入容错
- (AVCaptureDeviceInput *)createMediaInputWithDevice:(AVCaptureDevice *)device mediaType:(NSString *)mediaType {
    if (nil != device) {
        NSError *videoInputError;
        AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&videoInputError];
        if (nil == videoInputError) {
            return videoInput;
        } else {
            if ([mediaType isEqualToString:AVMediaTypeAudio]) {
                NSLog(@"ERROR: 配置音频输入设备错误");
            } else if ([mediaType isEqualToString:AVMediaTypeVideo]) {
                NSLog(@"ERROR: 配置视频输入设备错误");
            }
        }
    }
    return nil;
}

- (BOOL)captureSessionAddInput:(AVCaptureDeviceInput *)input {
    if (nil != input) {
        if ([_captureSession canAddInput:input]) {
            [_captureSession addInput:input];
            _videoInput = input;
            return YES;
        }
    } else {
        NSLog(@"获取媒体输入设备出错");
    }
    return NO;
}

- (void)captureSessionChangeVideoInput:(AVCaptureDeviceInput *)input {
    if (nil != input) {
        [_captureSession removeInput:_videoInput];
        if ( ![self captureSessionAddInput:input]) {
            if (nil != _videoInput) {
                [_captureSession addInput:_videoInput];
                NSLog(@"Error: 不能成功切换摄像头");
            }
        }
    } else {
        NSLog(@"ERROR: 获取视频输入设备错误");
    }
    
}

//获取指定摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    AVCaptureDevice *willingDevice;
    NSArray *cameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameraDevices) {
        if (device.position == position) {
            willingDevice = device;
            break;
        }
    }
    if (nil == willingDevice) {
        NSLog(@"ERROR: 获取指定摄像头失败");
    }
    return willingDevice;
}

- (void)configureVideoPreview {
    
//    [self.view layoutIfNeeded];
    
    [self.videoPreviewView setSession:_captureSession];
    self.videoPreviewView.delegate = self;
//    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
//    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    
//    _videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
//    _videoPreviewLayer.position = CGPointMake(self.view.frame.size.width*0.5, self.view.frame.size.height *0.5);
//    
//    
//    _videoPreviewView.layer.masksToBounds = YES;
//    [self.view layoutIfNeeded];
//    
//    [_videoPreviewView.layer addSublayer:_videoPreviewLayer];
}

//对焦
- (void)focusAtCapturePoint:(CGPoint)point {
    if ([_videoDevice isFocusPointOfInterestSupported] &&
        [_videoDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        //获得锁再操作设备
        NSError *error;
        if ([_videoDevice lockForConfiguration:&error]) {
            _videoDevice.focusPointOfInterest = point;
            _videoDevice.focusMode = AVCaptureExposureModeContinuousAutoExposure;
            [_videoDevice unlockForConfiguration];
        } else {
            NSLog(@"Configuration Failed ERROR: %@", error);
        }
    }
}

//测光
- (void)exposeAtCapturePoint:(CGPoint)point {
    if ([_videoDevice isExposurePointOfInterestSupported] &&
            [_videoDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        
        //获得锁再操作设备
        NSError *error;
        if ([_videoDevice lockForConfiguration:&error]) {
            _videoDevice.exposurePointOfInterest = point;
            _videoDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            NSLog(@"%3.f", _videoDevice.exposureTargetOffset);
            //测光完毕后 锁定曝光
            /*
            if ([_videoDevice isExposureModeSupported:AVCaptureExposureModeLocked]) {
                [_videoDevice addObserver:self forKeyPath:@"adjustingExposure" options:NSKeyValueObservingOptionNew context:nil];
            }
            */
            [_videoDevice unlockForConfiguration];
        } else {
            NSLog(@"Configuration Failed ERROR: %@", error);
        }
        
    }
}

#pragma mark - delegate
- (void)previewViewFocusAtCapturePoint:(CGPoint)point {
    //刷新对焦
    [self focusAtCapturePoint:point];
    //刷新测光
    [self exposeAtCapturePoint:point];
}

#pragma mark - KVO
//部分版本不支持AutoExposure来持续保持曝光，需用KVO修改成Locked
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"adjustingExposure"]) {
        if (![_videoDevice isAdjustingExposure] &&
            [_videoDevice isExposureModeSupported:AVCaptureExposureModeLocked]) {
            //移除监听
            [object removeObserver:self forKeyPath:@"adjustingExposure"];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                if ([_videoDevice lockForConfiguration:&error]) {
                    //锁定曝光
                    _videoDevice.exposureMode = AVCaptureExposureModeLocked;
                    [_videoDevice unlockForConfiguration];
                }
            });
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
