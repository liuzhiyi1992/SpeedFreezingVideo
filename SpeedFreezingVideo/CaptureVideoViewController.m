//
//  CaptureVideoViewController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "CaptureVideoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CaptureVideoViewController ()
@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (strong, nonatomic) AVCaptureSession *captureSession;

@property (strong, nonatomic) AVCaptureDevice *audioDevice;
@property (strong, nonatomic) AVCaptureDevice *videoDevice;

@property (strong, nonatomic) AVCaptureDeviceInput *audioInput;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;


@end

@implementation CaptureVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
        default:                                    //用户拒绝授权/未授权
            break;
    }
}

- (void)configureCapture {
    //开始配置安装
    
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVAssetExportPresetMediumQuality]) {
        [_captureSession setSessionPreset:AVAssetExportPresetMediumQuality];
    }
    
    [_captureSession beginConfiguration];
    
    
    //使用后置摄像头
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
//    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
//    for (AVCaptureDevice *device in videoDevices) {
//        if (device.position == AVCaptureDevicePositionBack) {
//            _videoDevice = device;
//        }
//    }
    
    [_captureSession commitConfiguration];
}

//摄像头是否工作
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

//切换摄像头
- (void)changeCameraDevice {
    switch (_videoDevice.position) {
        case AVCaptureDevicePositionBack:
            _videoDevice = [self cameraWithPosition:AVCaptureDevicePositionFront];
            break;
        case AVCaptureDevicePositionFront:
            _videoDevice = [self cameraWithPosition:AVCaptureDevicePositionBack];
            break;
        default:
            break;
    }
    
    //todo 切换时锁定设备，方式同时修改?
    if (nil != _videoDevice) {
        NSError *videoInputError;
        AVCaptureDeviceInput *videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&videoInputError];
        if (nil == videoInputError) {
            [self captureSessionChangeInput:videoInput];
        } else {
            NSLog(@"Error: 切换摄像头失败(%@)", videoInputError);
        }
    }
}

- (void)captureSessionAddInput:(AVCaptureDeviceInput *)input {
    if ([_captureSession canAddInput:input]) {
        [_captureSession addInput:input];
        _videoInput = input;
    } else {
        if (nil != _videoInput) {
            [_captureSession addInput:_videoInput];
            NSLog(@"Error: 不能成功切换摄像头");
        } else {
            NSLog(@"Error: 视频输入设备出错");
        }
    }
}

- (void)captureSessionChangeInput:(AVCaptureDeviceInput *)input {
    [_captureSession removeInput:_videoInput];
    [self captureSessionAddInput:input];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    AVCaptureDevice *willingDevice;
    NSArray *cameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameraDevices) {
        if (device.position == position) {
            willingDevice = device;
            break;
        }
    }
    return willingDevice;
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
