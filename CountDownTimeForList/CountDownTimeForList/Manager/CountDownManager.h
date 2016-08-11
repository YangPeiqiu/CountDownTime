//
//  CountDownManager.h
//  CountDowmTime
//
//  Created by Qiu on 16/8/11.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CountDownSendValueModel;
@class CountDownShowModel;

typedef void (^GetTheTimeBlock)(CountDownShowModel *model, NSIndexPath *indexPath);

@interface CountDownManager : NSObject

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray<CountDownSendValueModel *> *modelArray; // 需要传入的数组
@property (nonatomic, copy) GetTheTimeBlock getTheTimeBlock;

- (void)setCountDownBegin;

@end
