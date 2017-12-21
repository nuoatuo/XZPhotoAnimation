//
//  XZPhotoFlowView.m
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/10/31.
//  Copyright © 2017年 夜风. All rights reserved.
//

#import "XZPhotoFlowView.h"
#import "XZPhotoView.h"


//显示照片数量
#define kShowPhotoCount 3
//照片视图标记位
#define kPhotoViewTag 100

//照片视图透明度: 最大值
#define kPVAlphaMax 1.0
//照片视图透明度: 中间值
#define kPVAlphaMid 0.6
//照片视图透明度: 最小值
#define kPVAlphaMin 0.2


@interface XZPhotoFlowView ()<UIScrollViewDelegate>

/** 背景滚动视图 */
@property (nonatomic, strong) UIScrollView *bgScrollView;

/** 照片交错间距 */
@property (nonatomic, assign) CGFloat stagger;
/** 照片视图宽度 */
@property (nonatomic, assign) CGFloat pvWidth;
/** 照片视图高度 */
@property (nonatomic, assign) CGFloat pvHeight;
/** 照片视图大小 */
@property (nonatomic, assign) CGSize pvSize;
/** 每页的宽度 = stagger + pvWidth*/
@property (nonatomic, assign) CGFloat pageWidth;

/** 照片视图纵向缩放比例: 最大值 */
@property (nonatomic, assign) CGFloat vScaleMax;
/** 照片视图纵向缩放比例: 中间值 */
@property (nonatomic, assign) CGFloat vScaleMid;
/** 照片视图纵向缩放比例: 最小值 */
@property (nonatomic, assign) CGFloat vScaleMin;

/** 当前首图位置 */
@property (nonatomic, assign) NSInteger crtPVIndex;

/** 使用的"照片视图"数据源 */
@property (nonatomic, strong) NSMutableArray <XZPhotoView *>*usablePVArray;
/** 复用的"照片视图"数据源 */
@property (nonatomic, strong) NSMutableArray <XZPhotoView *>*reusablePVArray;

@end

@implementation XZPhotoFlowView
#pragma mark - 实例化
/**
 实例化"照片流视图"
 
 @param top 竖直方向起点(y)
 @return self
 */
+ (instancetype)classInitWithTop:(CGFloat)top {
    XZPhotoFlowView *view = [[self alloc] initWithFrame:CGRectMake(0.0, top, SCREEN_WIDTH, 0.0)];
    if (view) {
        view.stagger = 30.0;
        view.backgroundColor = [UIColor whiteColor];
    }
    return view;
}

#pragma mark - 重写赋值
- (void)setStagger:(CGFloat)stagger {
    _stagger = stagger;
    
    [self setupBaseData];
}

- (void)setPhotoArray:(NSMutableArray<XZPhotoModel *> *)photoArray {
    _photoArray = photoArray;
    
    //刷新数据
    [self reloadData];
}

#pragma mark - 懒加载
- (UIScrollView *)bgScrollView {
    if (_bgScrollView) return _bgScrollView;
   
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width - self.stagger, self.frame.size.height)];
    scrollView.pagingEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.hidden = YES;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    scrollView.delegate = self;
   
    _bgScrollView = scrollView;
    [self addSubview:_bgScrollView];
    return _bgScrollView;
}

- (NSMutableArray<XZPhotoView *> *)usablePVArray {
    if (_usablePVArray == nil) {
        _usablePVArray = [NSMutableArray array];
    }
    return _usablePVArray;
}

- (NSMutableArray<XZPhotoView *> *)reusablePVArray {
    if (_reusablePVArray == nil) {
        _reusablePVArray = [NSMutableArray array];
    }
    return _reusablePVArray;
}

#pragma mark - UIScrollViewDelegate
#pragma mark scrollView在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //0.scrollView水平方向偏移量
    CGFloat offsetX = scrollView.contentOffset.x;
    //NSLog(@"offsetX == %f",offsetX);
    
    //1.已经是第1张时，不可再右滑
    if (offsetX < 0) offsetX = 0;

    //2.相关变量
    //2.1.当前首图下标
    self.crtPVIndex = (NSInteger)(offsetX / self.pageWidth);
    //NSLog(@"crtPVIndex = %ld",self.crtPVIndex);
    //2.2.目标缩放比例
    CGFloat targetScale = 0.0;
    //2.3.水平方向相对偏移量
    CGFloat relativeX = offsetX - self.crtPVIndex * self.pageWidth;
    
    //3.更新照片视图显示状态
    //3.1.第1张照片
    XZPhotoView *firstPV = [self getPhotoViewWithIndex:self.crtPVIndex];
    firstPV.photoLeft = self.stagger + self.crtPVIndex*self.pageWidth;
    targetScale = self.vScaleMax - relativeX * (self.vScaleMax - self.vScaleMid)/self.pageWidth;
    firstPV.transform =  CGAffineTransformMakeScale(1.0, targetScale);
    firstPV.photoAlpha  = kPVAlphaMax - relativeX * (kPVAlphaMax - kPVAlphaMid)/self.pageWidth;
    
    //3.2.第2张照片
    XZPhotoView *secondPV = [self getPhotoViewWithIndex:self.crtPVIndex+1];
    if (!secondPV) return;
    secondPV.photoLeft = (self.crtPVIndex+2)*self.stagger + offsetX -offsetX*self.stagger/self.pageWidth;
    targetScale = self.vScaleMid + relativeX * (self.vScaleMax - self.vScaleMid)/self.pageWidth;
    secondPV.transform =  CGAffineTransformMakeScale(1.0, targetScale);
    secondPV.photoAlpha = kPVAlphaMid + relativeX * (kPVAlphaMax - kPVAlphaMid)/self.pageWidth;
    [secondPV setNeedsDisplay];

    //3.3.其他照片
    XZPhotoView *otherPV = [self getPhotoViewWithIndex:self.crtPVIndex+2];
    if (!otherPV) return;
    [scrollView insertSubview:otherPV belowSubview:secondPV];
    otherPV.photoLeft = (self.crtPVIndex+3)*self.stagger + offsetX -offsetX*self.stagger/self.pageWidth;
    targetScale = self.vScaleMin + relativeX * (self.vScaleMid - self.vScaleMin)/self.pageWidth;
    otherPV.transform =  CGAffineTransformMakeScale(1.0, targetScale);
    otherPV.photoAlpha = kPVAlphaMin + relativeX * (kPVAlphaMid - kPVAlphaMin)/self.pageWidth;
    
    //4."照片视图"滑出屏幕
    [self photoViewSlideOutScreen];
}

#pragma mark scrollView将要停到的位置
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    /* *** 实现"图片视图"按张停留 *** */

    //水平方向原本要停留的位置
    CGFloat originalX = targetContentOffset->x;
    
    //当前首图位置
    NSInteger crtPVIndex = (NSInteger)(originalX / self.pageWidth);
  
    //水平方向将要停留的位置: 滑动位置 < 图片视图宽度一半
    CGFloat targetOffsetX = crtPVIndex * self.pageWidth;
    
    //水平方向"图片视图"相对偏移量
    CGFloat relativeX = originalX - targetOffsetX - self.stagger;
    if (relativeX > self.pvWidth *0.5) {
        //水平方向将要停留的位置: 滑动位置 > 图片视图宽度一半
       targetOffsetX = (crtPVIndex + 1) * self.pageWidth;
    }
    
    //重置停留位置
    *targetContentOffset = CGPointMake(targetOffsetX, targetContentOffset->y);
}

#pragma mark scrollView停止减速
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //滑动停止block
    if (self.didEndSliding) {
        self.didEndSliding(self.crtPVIndex);
    }
}

#pragma mark - ******** 刷新"照片视图"方法 ********
#pragma mark 设置基本数据
/**
 设置基本数据
 */
- (void)setupBaseData {
    /** 照片视图宽度 */
    self.pvWidth = self.frame.size.width - self.stagger * (kShowPhotoCount + 1);
    /** 照片视图高度 */
    self.pvHeight = kPhotoHeight(self.pvWidth);
    /** 照片视图大小 */
    self.pvSize = CGSizeMake(self.pvWidth, self.pvHeight);
    
    /** 每页的宽度 = stagger + pvWidth*/
    self.pageWidth = self.stagger + self.pvWidth;
    
    /** 照片视图纵向缩放比例: 最大值 */
    self.vScaleMax = 1.0;
    /** 照片视图纵向缩放比例: 中间值 */
    self.vScaleMid = self.vScaleMax - self.stagger * 2 /self.pvHeight;
    /** 照片视图纵向缩放比例: 最小值 */
    self.vScaleMin = self.vScaleMax - self.stagger * 4 /self.pvHeight;
    
    /** 当前首图位置 */
    self.crtPVIndex = 0;
    
    /** 修改照片流视图高度 */
    CGRect frame = self.frame;
    frame.size.height = self.pvHeight;
    self.frame = frame;
}

#pragma mark 刷新数据
/**
 刷新数据
 */
- (void)reloadData {
    //1.校验数据
    if (!self.photoArray.count) {
        self.bgScrollView.hidden = YES; return;
    }
    
    //2.清理旧的"照片视图"
    [self clearOldPhotoViews];
    
    //3.初始化默认的照片视图
    [self _initDefaultPhotoView];
}

#pragma mark - ******** 移除"照片视图"方法 ********
#pragma mark 清理旧的"照片视图"
/**
 清理旧的"照片视图"
 */
- (void)clearOldPhotoViews {
    NSArray *subViews = self.bgScrollView.subviews;
    if (!subViews.count) return;
    
    //清理旧的"照片视图"
    for (XZPhotoView *photoView in subViews) {
        [self removeOffscreenPhotoView:photoView];
    }
}

#pragma mark 移出滑出屏幕的"照片视图"
/**
 移出滑出屏幕的"照片视图"
 
 @param offscreenPV 滑出屏幕的"照片视图"
 */
- (void)removeOffscreenPhotoView:(XZPhotoView *)offscreenPV {
    //1.校验
    if (!offscreenPV) return;
    if (![offscreenPV isKindOfClass:[XZPhotoView class]]) return;
    
    //2.添加到复用数据源
    [self.reusablePVArray addObject:offscreenPV];
    
    //3.移出使用的数据源
    [self.usablePVArray removeObject:offscreenPV];
    
    //4.移出父视图
    [offscreenPV removeFromSuperview];
}

#pragma mark "照片视图"滑出屏幕
/**
 "照片视图"滑出屏幕
 */
- (void)photoViewSlideOutScreen {
    if (self.crtPVIndex <= 0) return;
    
    //1.移出左边的"照片视图"
    XZPhotoView *leftPV = [self.bgScrollView viewWithTag:kPhotoViewTag + self.crtPVIndex -1];
    [self removeOffscreenPhotoView:leftPV];
    
    //2.移出右边的"照片视图"
    NSInteger rightIndex = self.crtPVIndex + kShowPhotoCount;
    if (rightIndex >= self.photoArray.count) return;
    XZPhotoView *rightPV = [self.bgScrollView viewWithTag:kPhotoViewTag + rightIndex];
    [self removeOffscreenPhotoView:rightPV];
}

#pragma mark - ******** 添加"照片视图"方法 ********
#pragma mark 初始化默认的照片视图
/**
 初始化默认的照片视图
 */
- (void)_initDefaultPhotoView {
    //1.共用变量
    //1.1.数量
    NSInteger count = MIN(kShowPhotoCount, self.photoArray.count);
    //1.2.缩放比例
    CGFloat photoScale = self.vScaleMin,photoAlpha = kPVAlphaMin;
    
    //2.初始化默认的照片视图
    for (NSInteger i = count - 1; i >= 0; i--) {
        //2.1.取出"照片视图"
        XZPhotoView *photoView = [self getPhotoViewWithIndex:i];
        if (!photoView) continue;
        
        //2.更新缩放比例&透明度
        if (i == 0) {//第1张
            photoScale = self.vScaleMax;
            photoAlpha = kPVAlphaMax;
        } else if (i == 1) {//第2张
            photoScale = self.vScaleMid;
            photoAlpha = kPVAlphaMid;
        } else {//其他
            photoScale = self.vScaleMin;
            photoAlpha = kPVAlphaMin;
        }
        photoView.transform = CGAffineTransformMakeScale(1.0, photoScale);
        photoView.photoAlpha = photoAlpha;
    }
    
    //3.更新画布大小
    self.bgScrollView.contentSize = CGSizeMake(self.bgScrollView.bounds.size.width + self.pageWidth * (self.photoArray.count - 1), self.bgScrollView.bounds.size.height);
    self.bgScrollView.hidden = NO;
}

#pragma mark 取出"照片视图"
/**
 取出"照片视图"
 
 @param index 下标
 @return "照片视图"对象
 */
- (XZPhotoView *)getPhotoViewWithIndex:(NSInteger)index {
    //1.校验越界
    if (index >= self.photoArray.count) return nil;
    
    //2.已经在scrollView上显示,直接返回
    XZPhotoView *photoView = [self.bgScrollView viewWithTag:kPhotoViewTag + index];
    if (photoView) return photoView;
    
    //3.不在scrollView上
    XZPhotoModel *photoM = self.photoArray[index];
    if (self.reusablePVArray.count) {
        //3.1.有可复用的
        photoView = self.reusablePVArray.firstObject;
        
        [self.usablePVArray addObject:photoView];
        [self.reusablePVArray removeObject:photoView];
    } else {
        //3.2.创建新的
        photoView = [XZPhotoView classInitWithSize:self.pvSize];
        
        [self.usablePVArray addObject:photoView];
    }
    
    //4.刷新数据
    [photoView reloadDataWithLeft:self.stagger*(index+1) pic:photoM.imgName tag:kPhotoViewTag+index];
    
    //5.添加到scrollView，并返回
    [self.bgScrollView addSubview:photoView];
    return photoView;
}


@end
