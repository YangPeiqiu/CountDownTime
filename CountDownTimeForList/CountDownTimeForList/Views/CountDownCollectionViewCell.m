//
//  CountDownCollectionViewCell.m
//  CountDowmTime
//
//  Created by Qiu on 16/8/11.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import "CountDownCollectionViewCell.h"
#import "Masonry.h"
#import "CountDownView.h"

@interface CountDownCollectionViewCell ()

@property (nonatomic, strong) CountDownView *countDownView;

@end

@implementation CountDownCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _countDownView = [[CountDownView alloc] initWithFrame:CGRectZero];
        _countDownView.hidden = YES;
        _countDownView.backgroundColor = [UIColor orangeColor];
        [self addSubview:_countDownView];
        [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.bottom.trailing.equalTo(@0);
            make.height.mas_equalTo(@40);
        }];
        
    }
    return self;
}

- (void)setIsHaveCountDownTime:(BOOL)isHaveCountDownTime {
    self.countDownView.hidden = !isHaveCountDownTime;

}

- (void)setCountDownModel:(CountDownShowModel *)countDownModel {
    self.countDownView.countDownModel = countDownModel;
}


@end
