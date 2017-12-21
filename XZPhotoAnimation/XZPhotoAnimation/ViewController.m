//
//  ViewController.m
//  XZPhotoAnimation
//
//  Created by 夜风 on 2017/10/31.
//  Copyright © 2017年 夜风. All rights reserved.
//

#import "ViewController.h"
#import "XZRosterView.h"

@interface ViewController ()

/** 花名册视图 */
@property (nonatomic, strong) XZRosterView *rosterView;
/** 照片数据源 */
@property (nonatomic, strong) NSMutableArray <XZPhotoModel *>*photoArray;

@end

@implementation ViewController
#pragma mark - 懒加载
- (XZRosterView *)rosterView {
    if (_rosterView) return _rosterView;
    
    _rosterView = [XZRosterView classInitWithTop:120.0];
    [self.view addSubview:_rosterView];
    return _rosterView;
}

- (NSMutableArray<XZPhotoModel *> *)photoArray {
    if (_photoArray) return _photoArray;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"roster" ofType:@"plist"];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:filePath];
    _photoArray = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++) {
        XZPhotoModel *item = [XZPhotoModel classInitWithDict:dataArray[i]];
        item.index = i;
        
        [_photoArray addObject:item];
    }
    return _photoArray;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rosterView.photoArray = self.photoArray;
}





@end
