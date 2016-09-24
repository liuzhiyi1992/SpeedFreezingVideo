//
//  AboutController.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/9/24.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()
@property (weak, nonatomic) IBOutlet UIView *signView;
@property (weak, nonatomic) IBOutlet UIView *copyrightView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signViewCenterYConstraint;
@end

@implementation AboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self modifyNavigationBar];
    [self signAnim];
}

- (void)modifyNavigationBar {
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)signAnim {
    CGRect signViewOriginFrame = _signView.frame;
    signViewOriginFrame.origin.y -= 50;
    
    _copyrightView.alpha = 0;
    [UIView animateWithDuration:3.f animations:^{
        _signView.alpha = 0;
        _signViewCenterYConstraint.constant = -50;
        [_signView setFrame:signViewOriginFrame];
    } completion:^(BOOL finished) {
        _copyrightView.alpha = 1;
    }];
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
