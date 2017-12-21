//
//  XZBiographyCell.h
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/12/19.
//  Copyright © 2017年 夜风. All rights reserved.
//

#pragma mark ***简介Cell***

#import <UIKit/UIKit.h>
@class XZPhotoModel;

@interface XZBiographyCell : UICollectionViewCell


/**
 注册"简介Cell"

 @param collectionView 集合视图
 */
+ (void)registerCell:(UICollectionView *)collectionView;

/**
 实例化"简介Cell"
 
 @param collectionView 集合视图
 @param atIndexPath 位置
 @param item 照片模型对象
 @return self
 */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)atIndexPath item:(XZPhotoModel *)item;

/**
 获得"简介Cell"大小
 */
+ (CGSize)sizeOfCell;

@end
