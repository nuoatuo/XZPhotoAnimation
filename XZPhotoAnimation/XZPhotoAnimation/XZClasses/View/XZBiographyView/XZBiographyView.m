//
//  XZBiographyView.m
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/12/19.
//  Copyright © 2017年 夜风. All rights reserved.
//

#import "XZBiographyView.h"
#import "XZBiographyCell.h"
#import "XZPhotoModel.h"

@interface XZBiographyView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

//底部集合视图
@property (weak, nonatomic) IBOutlet UICollectionView *bgCollectionView;

@end

@implementation XZBiographyView
#pragma mark - init
/**
 实例化"简介视图"
 
 @return self
 */
+ (instancetype)classInit {
    XZBiographyView *view = [[NSBundle mainBundle] loadNibNamed:@"XZBiographyView" owner:nil options:nil].firstObject;
    CGSize size = [XZBiographyCell sizeOfCell];
    view.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    
    return view;
}

#pragma mark - 重写赋值
- (void)setPhotoArray:(NSMutableArray<XZPhotoModel *> *)photoArray {
    _photoArray = photoArray;
    
    //刷新数据
    self.bgCollectionView.contentOffset = CGPointZero;
    [self.bgCollectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    if (_currentIndex == currentIndex) return;
    
    //滑动到显示位置
    [self.bgCollectionView setContentOffset:CGPointMake(0.0, currentIndex*self.frame.size.height) animated:YES];
    
    _currentIndex = currentIndex;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.photoArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [XZBiographyCell cellWithCollectionView:collectionView atIndexPath:indexPath item:self.photoArray[indexPath.section]];
}

#pragma mark - system
- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (@available(iOS 11.0, *)) {
        self.bgCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.bgCollectionView.collectionViewLayout;
    layout.itemSize = [XZBiographyCell sizeOfCell];

    [XZBiographyCell registerCell:self.bgCollectionView];
    
    self.bgCollectionView.dataSource = self;
    self.bgCollectionView.delegate = self;
}

@end
