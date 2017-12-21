//
//  XZRosterView.h
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/12/19.
//  Copyright © 2017年 夜风. All rights reserved.
//

#pragma mark ***花名册视图: 简介+照片流***

#import <UIKit/UIKit.h>
#import "XZBiographyView.h"
#import "XZPhotoFlowView.h"

@interface XZRosterView : UIView

/** 照片数据源 */
@property (nonatomic, strong) NSMutableArray <XZPhotoModel *>*photoArray;

/**
 实例化"花名册视图"
 
 @param top 竖直方向起点(y)
 @return self
 */
+ (instancetype)classInitWithTop:(CGFloat)top;

@end
