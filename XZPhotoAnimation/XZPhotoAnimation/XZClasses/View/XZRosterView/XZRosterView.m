//
//  XZRosterView.m
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/12/19.
//  Copyright © 2017年 夜风. All rights reserved.
//

#import "XZRosterView.h"

@interface XZRosterView ()

/** 简介视图 */
@property (nonatomic, strong) XZBiographyView *bioView;
/** 照片流视图 */
@property (nonatomic, strong) XZPhotoFlowView *pfView;

@end

@implementation XZRosterView
#pragma mark - init
/**
 实例化"花名册视图"
 
 @param top 竖直方向起点(y)
 @return self
 */
+ (instancetype)classInitWithTop:(CGFloat)top {
    XZRosterView *view = [[self alloc] init];
    
    CGFloat bioViewH = CGRectGetMaxY(view.bioView.frame);
    CGFloat pfViewH = CGRectGetMaxY(view.pfView.frame);
    
    if (view) {
        view.frame = CGRectMake(0.0, top, SCREEN_WIDTH,bioViewH + pfViewH);
    }
    return view;
}

#pragma mark - setter
- (void)setPhotoArray:(NSMutableArray<XZPhotoModel *> *)photoArray {
    _photoArray = photoArray;
    
    self.bioView.photoArray = photoArray;
    self.pfView.photoArray = photoArray;
}

#pragma mark - getter
- (XZBiographyView *)bioView {
    if (_bioView) return _bioView;
    
    _bioView = [XZBiographyView classInit];
    
    [self addSubview:_bioView];
    return _bioView;
}

- (XZPhotoFlowView *)pfView {
    if (_pfView) return _pfView;
    
    __weak typeof(self) weakSelf = self;
    
    _pfView = [XZPhotoFlowView classInitWithTop:CGRectGetMaxY(self.bioView.frame)];
    _pfView.didEndSliding = ^(NSInteger atIndex) {
        weakSelf.bioView.currentIndex = atIndex;
    };
    
    [self addSubview:_pfView];
    return _pfView;
}

@end
