//
//  CountDownView.m
//  CountDowmTime
//
//  Created by Qiu on 16/8/11.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import "CountDownView.h"
#import "Masonry.h"
#import "CountDownShowModel.h"

@interface CountDownView ()

@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;

@end

@implementation CountDownView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _hourLabel = [self makeCustomLabel];
        [self addSubview:_hourLabel];
        [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@5);
            make.bottom.mas_equalTo(@(-5));
            make.width.mas_equalTo(@30);
        }];
        
        _minuteLabel = [self makeCustomLabel];
        [self addSubview:_minuteLabel];
        [_minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(_hourLabel);
            make.centerX.equalTo(self.mas_centerX);
            make.leading.equalTo(_hourLabel.mas_trailing).offset(5);
        }];
        
        _secondLabel = [self makeCustomLabel];
        [self addSubview:_secondLabel];
        [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.width.equalTo(_minuteLabel);
            make.leading.equalTo(_minuteLabel.mas_trailing).offset(5);
        }];
    }
    return self;
}

- (UILabel *)makeCustomLabel {
    
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    return label;
}

- (void)setCountDownModel:(CountDownShowModel *)countDownModel {
    
    self.hourLabel.text = countDownModel.hour;
    self.minuteLabel.text = countDownModel.minute;
    self.secondLabel.text = countDownModel.second;

}


@end
