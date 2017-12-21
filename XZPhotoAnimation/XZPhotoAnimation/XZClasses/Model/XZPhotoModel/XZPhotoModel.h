//
//  XZPhotoModel.h
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/10/31.
//  Copyright © 2017年 夜风. All rights reserved.
//

#pragma mark ***照片模型类***

#import <Foundation/Foundation.h>

@interface XZPhotoModel : NSObject


/**
 实例化"照片模型对象"

 @param dict 数据源
 @return self
 */
+ (instancetype)classInitWithDict:(NSDictionary *)dict;

/** 标题 */
@property (nonatomic, copy) NSString *titleStr;
/** 类型 */
@property (nonatomic, copy) NSString *typeStr;
/** 图片名 */
@property (nonatomic, copy) NSString *imgName;

/** 位置 */
@property (nonatomic, assign) NSInteger index;

@end
