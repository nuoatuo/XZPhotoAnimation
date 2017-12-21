//
//  XZPhotoFlowView.h
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/10/31.
//  Copyright © 2017年 夜风. All rights reserved.
//

#pragma mark ***照片流视图: 用于显示滑动图片***

#import <UIKit/UIKit.h>
#import "XZPhotoModel.h"

//屏幕宽
#define SCREEN_WIDTH [UIScreen  mainScreen].bounds.size.width
//屏幕高
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//"照片流视图"block事件
typedef void(^XZPhotoFlowViewAction)(NSInteger atIndex);


@interface XZPhotoFlowView : UIView

/** 照片数据源 */
@property (nonatomic, strong) NSMutableArray <XZPhotoModel *>*photoArray;
/** 滑动停止block */
@property (nonatomic, copy) XZPhotoFlowViewAction didEndSliding;


/**
 实例化"照片流视图"

 @param top 竖直方向起点(y)
 @return self
 */
+ (instancetype)classInitWithTop:(CGFloat)top;


@end
