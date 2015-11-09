//
//  UIView+Layout.h
//  Tools
//
//  Created by rg-hpf on 15/10/7.
//  Copyright © 2015年 julie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Layout)

/*
 获取或设置上下左右位置
 */
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat right;

/*
 获取或设置坐标
 */
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGPoint origin;

/*
 获取或设置中心坐标
 */
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;

/*
 获取或设置尺寸
 */
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGSize size;

@end
