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
@property (strong, nonatomic) AVCaptureSession *captureSession;
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
    
    [_captureSession commitConfiguration];
    
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
