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

@end

@implementation ViewController

- (IBAction)enterVideoCapture:(id)sender {
    CaptureVideoViewController *controller = [[CaptureVideoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
