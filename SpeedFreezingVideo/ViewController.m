//
//  ViewController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/14.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "ViewController.h"
#import "CaptureVideoViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *libraryButtonLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraButtonTralingConstraint;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self modifyStatusBar];
    [self setupNavigationBarItem];
    [self configureLayout];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
}

- (IBAction)clickCameraButton:(id)sender {
    CaptureVideoViewController *controller = [[CaptureVideoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
