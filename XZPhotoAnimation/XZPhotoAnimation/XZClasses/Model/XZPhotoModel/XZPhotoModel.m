//
//  XZPhotoModel.m
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/10/31.
//  Copyright © 2017年 夜风. All rights reserved.
//

#import "XZPhotoModel.h"

@implementation XZPhotoModel
#pragma mark - init
/**
 实例化"照片模型对象"
 
 @param dict 数据源
 @return self
 */
+ (instancetype)classInitWithDict:(NSDictionary *)dict {
    
    XZPhotoModel *item = [[self alloc] init];
    if (item) {
        [item parseDataWithDict:dict];
    }
    
    return item;
}

#pragma mark - custom
/**
 解析数据

 @param dict 数据源
 */
- (void)parseDataWithDict:(NSDictionary *)dict {
    if (!dict.count) return;
    
    self.titleStr = dict[@"title"];
    self.typeStr = dict[@"type"];
    self.imgName = dict[@"imgName"];
}

@end
