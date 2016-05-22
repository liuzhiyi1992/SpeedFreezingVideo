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
@property (strong, nonatomic) UIColor *originalColor;
@property (weak, nonatomic) IBOutlet UIButton *originalSpeedRateButton;


@end

@implementation SpeedMultipleView

+ (SpeedMultipleView *)createView {
    SpeedMultipleView *multipleView = [[NSBundle mainBundle] loadNibNamed:@"SpeedMultipleView" owner:nil options:nil][0];
    UIButton *tmpButton = multipleView.speedButtons[0];
    multipleView.originalColor = tmpButton.backgroundColor;
    [multipleView clickSpeedButton:multipleView.originalSpeedRateButton];
    return multipleView;
}

- (IBAction)clickSpeedButton:(UIButton *)sender {
    for (UIButton *btn in _speedButtons) {
        if (btn != sender) {
            [btn setBackgroundColor:_originalColor];
        }
    }
    [sender setBackgroundColor:[UIColor blackColor]];
    
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
