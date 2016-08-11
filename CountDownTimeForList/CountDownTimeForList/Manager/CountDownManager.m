//
//  CountDownManager.m
//  CountDowmTime
//
//  Created by Qiu on 16/8/11.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import "CountDownManager.h"
#import "CountDownShowModel.h"
#import "CountDownSendValueModel.h"

@implementation CountDownManager {
    
    int _overTimeCount; // 去掉的次数
    NSUInteger _countOfIndex; // 总的次数
    NSMutableArray<CountDownSendValueModel *> *_array;
}

- (void)setModelArray:(NSMutableArray<CountDownSendValueModel *> *)modelArray {
    _array = modelArray;
    _overTimeCount = 0;
}

- (void)setCountDownBegin {
    
    _countOfIndex = _array.count;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTheTime];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTheTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    });
}

- (void)refreshTheTime {
    
    NSInteger timeout;
    for (CountDownSendValueModel *model in _array.reverseObjectEnumerator) {
        // 获取我们指定的倒计时时间
        timeout = model.lastTime;
//        NSLog(@"lastTime === %lu",timeout);
        // 真正开始算时间
        NSInteger days = (int)(timeout/(3600*24));
        NSInteger hours = (int)((timeout-days*24*3600)/3600);
        NSInteger minute = (int)(timeout-days*24*3600-hours*3600)/60;
        NSInteger second = timeout-days*24*3600-hours*3600-minute*60;
        CountDownShowModel *countDownModel = [[CountDownShowModel alloc] init];
        if (hours < 10) {
            countDownModel.hour = [NSString stringWithFormat:@"0%ld",hours];
        }else{
            countDownModel.hour = [NSString stringWithFormat:@"%ld",hours];
        }
        if (minute < 10) {
            countDownModel.minute = [NSString stringWithFormat:@"0%ld",minute];
        }else{
            countDownModel.minute = [NSString stringWithFormat:@"%ld",minute];
        }
        if (second < 10) {
            countDownModel.second = [NSString stringWithFormat:@"0%ld",second];
        }else{
            countDownModel.second = [NSString stringWithFormat:@"%ld",second];
        }
        
        if (self.getTheTimeBlock) {
            self.getTheTimeBlock(countDownModel, model.indexPath);
        }
      
        if (timeout == 0) {
            countDownModel.hour = @"00";
            countDownModel.minute = @"00";
            countDownModel.second = @"00";
            if (self.getTheTimeBlock) {
                self.getTheTimeBlock(nil,model.indexPath);
            }
            _overTimeCount++;
            // 删除这个已经计时结束的Model，并加1
            [_array removeObject:model];
        }
        // 当所有结束的时候，将_time 清空
        if (_overTimeCount == _countOfIndex) {
            [_timer invalidate];
            _timer = nil;
        }
        timeout--;
        model.lastTime = timeout;
        
    }
}

- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    NSLog(@"CountDownManager Dealloc");
}

@end
