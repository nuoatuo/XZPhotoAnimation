//
//  XZBiographyView.h
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/12/19.
//  Copyright © 2017年 夜风. All rights reserved.
//

#pragma mark ***简介视图***

#import <UIKit/UIKit.h>
@class XZPhotoModel;

@interface XZBiographyView : UIView

/** 照片数据源 */
@property (nonatomic, strong) NSMutableArray <XZPhotoModel *>*photoArray;
/** 当前位置 */
@property (nonatomic, assign) NSInteger currentIndex;


/**
 实例化"简介视图"

 @return self
 */
+ (instancetype)classInit;




@end
