//
//  XZBiographyCell.m
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/12/19.
//  Copyright © 2017年 夜风. All rights reserved.
//

#import "XZBiographyCell.h"
#import "XZPhotoModel.h"


@interface XZBiographyCell ()

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
//位置
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@end

@implementation XZBiographyCell
#pragma mark - register
/**
 注册"简介Cell"
 
 @param collectionView 集合视图
 */
+ (void)registerCell:(UICollectionView *)collectionView {
    if ((!collectionView) ||
        (![collectionView isKindOfClass:[UICollectionView class]])) {
        return;
    }
    
    NSString *cellName = NSStringFromClass(self);
    
    [collectionView registerNib:[UINib nibWithNibName:cellName bundle:nil] forCellWithReuseIdentifier:cellName];
}

#pragma mark - init
/**
 实例化"简介Cell"
 
 @param collectionView 集合视图
 @param atIndexPath 位置
 @param item 照片模型对象
 @return self
 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath item:(XZPhotoModel *)item {
    XZBiographyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self) forIndexPath:atIndexPath];

    if (cell) {
        cell.titleLabel.text = item.titleStr;
        cell.typeLabel.text = item.typeStr;
        cell.indexLabel.text = [NSString stringWithFormat:@"第%ld张",item.index+1];
    }
    
    return cell;
}

#pragma mark - size
/**
 获得"简介Cell"大小
 */
+ (CGSize)sizeOfCell {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 64.0);
}

@end
