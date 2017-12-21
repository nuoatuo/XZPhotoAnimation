//
//  XZPhotoView.m
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/11/28.
//  Copyright © 2017年 夜风. All rights reserved.
//

#import "XZPhotoView.h"


@interface XZPhotoView ()

//照片图片视图
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
//毛玻璃效果视图
@property (weak, nonatomic) IBOutlet UIView *frostedView;

@end

@implementation XZPhotoView
#pragma mark - init
/**
 实例化"照片视图"
 
 @param size 大小
 @return self
 */
+ (instancetype)classInitWithSize:(CGSize)size {
    XZPhotoView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
    if (view) {
        view.frame = CGRectMake(0.0, 0.0, size.width, size.height);
    }
    return view;
}

#pragma mark - setter
- (void)setPhotoLeft:(CGFloat)photoLeft {
    CGRect frame = self.frame;
    frame.origin.x = photoLeft;
    self.frame = frame;
    
    _photoLeft = photoLeft;
}

- (void)setPhotoAlpha:(CGFloat)photoAlpha {
    self.frostedView.alpha = 1.0 - photoAlpha;
    
    _photoAlpha = photoAlpha;
}

#pragma mark - custom
/**
 刷新数据
 
 @param photoLeft 照片水平方向起点
 @param pic 图片
 @param tag 标记位
 */
- (void)reloadDataWithLeft:(CGFloat)photoLeft pic:(NSString *)pic tag:(NSInteger)tag {
    self.photoLeft = photoLeft;
 
    self.photoImgView.image = [UIImage imageNamed:pic];
    
    self.tag = tag;
}


@end
