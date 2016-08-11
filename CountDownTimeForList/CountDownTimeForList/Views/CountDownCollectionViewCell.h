//
//  CountDownCollectionViewCell.h
//  CountDowmTime
//
//  Created by Qiu on 16/8/11.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountDownShowModel;

@interface CountDownCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isHaveCountDownTime; // 是否拥有那个倒计时
@property (nonatomic, strong) CountDownShowModel *countDownModel; // 时、分、秒的model

@end
