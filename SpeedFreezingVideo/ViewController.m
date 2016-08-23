//
//  ViewController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "ViewController.h"
#import "CaptureVideoViewController.h"
//#import <CoreMotion/CoreMotion.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "VideoEditingController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraButtonTralingConstraint;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self setupNavigationBarItem];
    [self configureLayout];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self modifyStatusBar];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)configureLayout {
    [self updateButtonPosition];
}

- (void)updateButtonPosition {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat buttonMargin = (screenWidth - 2*CGRectGetWidth(_libraryButton.frame)) / 4;
    _libraryButtonLeadingConstraint.constant = buttonMargin;
    _cameraButtonTralingConstraint.constant = buttonMargin;
}

- (void)modifyStatusBar {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setupNavigationBarItem {
    UIButton *rightTopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 44)];
    [rightTopButton setTitle:@"Help" forState:UIControlStateNormal];
    [rightTopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightTopButton.titleLabel setFont:[UIFont systemFontOfSize:18.f]];
    [rightTopButton addTarget:self action:@selector(clickRightTopButton:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightTopButton];
}

- (void)clickRightTopButton:(id)sender {
    NSLog(@"123");
}

- (IBAction)clickLibraryButton:(id)sender {
    UIImagePickerController *myImagePickerController = [[UIImagePickerController alloc] init];
    myImagePickerController.sourceType =  UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    myImagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeMovie, nil];
    myImagePickerController.delegate = self;
    myImagePickerController.editing = NO;
    [self presentViewController:myImagePickerController animated:YES completion:nil];
}

- (IBAction)clickCameraButton:(id)sender {
    CaptureVideoViewController *controller = [[CaptureVideoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *infoKey = UIImagePickerControllerMediaURL;
    NSURL *assetUrl = [info objectForKey:infoKey];
    [picker dismissViewControllerAnimated:YES completion:^{
        VideoEditingController *editingController = [[VideoEditingController alloc] initWithAssetUrl:assetUrl];
        [self.navigationController pushViewController:editingController animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
