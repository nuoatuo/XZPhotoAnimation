//
//  XZPhotoView.h
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/11/28.
//  Copyright © 2017年 夜风. All rights reserved.
//

#pragma mark ***照片视图***

#import <UIKit/UIKit.h>

//获得照片高度
#define kPhotoHeight(width) ((width)*360.0/250.0 + 30.0)

@interface XZPhotoView : UIView

/** 照片水平方向起点 */
@property (nonatomic, assign) CGFloat photoLeft;
/** 照片透明度 */
@property (nonatomic, assign) CGFloat photoAlpha;


/**
 实例化"照片视图"

 @param size 大小
 @return self
 */
+ (instancetype)classInitWithSize:(CGSize)size;


/**
 刷新数据

 @param photoLeft 照片水平方向起点
 @param pic 图片
 @param tag 标记位
 */
- (void)reloadDataWithLeft:(CGFloat)photoLeft pic:(NSString *)pic tag:(NSInteger)tag;


@end
