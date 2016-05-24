//
//  SpeedMultipleView.m
//  SpeedFreezingVideo
//
//  Created by lzy on 16/5/22.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "SpeedMultipleView.h"


@interface SpeedMultipleView()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *speedButtons;
//@property (strong, nonatomic) UIColor *originalColor;
@property (weak, nonatomic) IBOutlet UIButton *originalSpeedRateButton;


@end

@implementation SpeedMultipleView

+ (SpeedMultipleView *)createView {
    SpeedMultipleView *multipleView = [[NSBundle mainBundle] loadNibNamed:@"SpeedMultipleView" owner:nil options:nil][0];
    
    
//    UIButton *tmpButton = multipleView.speedButtons[0];
//    multipleView.originalColor = tmpButton.backgroundColor;
    
    
    [multipleView configureView];
    
    return multipleView;
}

- (void)configureView{
    for (UIButton *btn in _speedButtons) {
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    [self clickSpeedButton:_originalSpeedRateButton];
}

- (IBAction)clickSpeedButton:(UIButton *)sender {
    for (UIButton *btn in _speedButtons) {
        if (btn != sender) {
            [btn setBackgroundColor:[UIColor blackColor]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
        }
    }
    [sender setBackgroundColor:[UIColor yellowColor]];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sender.layer.borderColor = [UIColor yellowColor].CGColor;
    
    double speedRate = 1.f;
    switch (sender.tag) {
        case 11:
            speedRate = 3.0;
            break;
        case 12:
            speedRate = 2.0;
            break;
        case 13:
            speedRate = 1.0;
            break;
        case 14:
            speedRate = 1/2.0;
            break;
        case 15:
            speedRate = 1/3.0;
            break;
        default:
            break;
    }
    
    [_delegate SpeedMultipleViewDidSelectedSpeedRate:speedRate];
}


@end
