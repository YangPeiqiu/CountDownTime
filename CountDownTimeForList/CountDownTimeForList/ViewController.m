//
//  ViewController.m
//  CountDownTimeForList
//
//  Created by Qiu on 16/8/11.
//  Copyright © 2016年 Yang. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "CountDownCollectionViewCell.h"
#import "CountDownShowModel.h"
#import "CountDownManager.h"
#import "CountDownSendValueModel.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
NSString *const kCollectionViewIden = @"kCollectionViewIden";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *indexArray;
@property (nonatomic, strong) CountDownManager *countDownManager;
@property (nonatomic, strong) CountDownShowModel *countDownShowModel;

@end

@implementation ViewController

#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // collectionView
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(@0);
    }];
    // 增加刷新
    [self.collectionView addSubview:self.refreshControl];
    // 开始计时
    [self makeShowCountDownTime];
}


//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self makeShowCountDownTime];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//
//    [super viewWillDisappear:animated];
//    [_countDownManager.timer invalidate];
//    _countDownManager.timer = nil;
//    _countDownManager = nil;
//
//}

- (void)dealloc {
    [_countDownManager.timer invalidate];
    _countDownManager.timer = nil;
    _countDownManager = nil;
}

#pragma mark Method
- (void)makeShowCountDownTime {
    
    self.countDownManager.modelArray = [self makeCustomModelArray];
    [self.countDownManager setCountDownBegin];
}

- (NSMutableArray *)makeCustomModelArray {
   // 假设需要 要更新的数组
    NSMutableArray  * modelArray = [NSMutableArray array];
    [self.indexArray removeAllObjects];
    self.indexArray = [NSMutableArray arrayWithArray:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]]];
    NSArray *timeArray = @[@"5",@"86200"];
    for (int i = 0; i < 2; i++){
        CountDownSendValueModel *model = [[CountDownSendValueModel alloc] init];
        model.indexPath = self.indexArray[i];
        model.lastTime = [timeArray[i] integerValue];
        [modelArray addObject:model];
    }
    return modelArray;
}

- (void)beginRefresh {
    // 假设刷新
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         self.countDownManager.modelArray = [self makeCustomModelArray];
        [self.collectionView reloadData];
        [self.refreshControl endRefreshing];
        
    });
}

#pragma mark

#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CountDownCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewIden forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0];
    cell.isHaveCountDownTime = NO;
    for (NSIndexPath *tempIndexPath in self.indexArray) {
        if (tempIndexPath == indexPath){
            cell.isHaveCountDownTime = YES;
        }
    }
    cell.countDownModel = self.countDownShowModel;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH/2 - 20, 200);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 0, 10);
}

#pragma mark Lazy
- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CountDownCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewIden];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    
    if(!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UIRefreshControl *)refreshControl {
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(beginRefresh) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

- (CountDownManager *)countDownManager {
    if (!_countDownManager) {
         _countDownManager = [[CountDownManager alloc] init];
        __weak typeof(self) weakSelf = self;
        _countDownManager.getTheTimeBlock = ^(CountDownShowModel *model, NSIndexPath *indexPath) {
            __strong typeof (self) strongSelf = weakSelf;
            if (!model) [strongSelf.indexArray removeObject:indexPath];
            strongSelf.countDownShowModel = model;
            [strongSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
    }
    return _countDownManager;
}

@end
