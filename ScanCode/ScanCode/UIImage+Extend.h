//
//  UIImage+Extend.h
//  demo
//
//  Created by gaofu on 2017/3/10.
//  Copyright © 2017年 siruijk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

/**
 生成圆角图片

 @param size 大小
 @param radius 圆角
 @param borderWidth 线宽
 @param borderColor 线颜色
 @return 图片
 */
-(UIImage*)getRoundRectImageWithSize:(CGFloat)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor;
-(UIImage*)getRoundRectImageWithSize:(CGFloat)size radius:(CGFloat)radius;


/**
 识别图片二维码

 @return 二维码内容
 */
-(NSString*)scanCodeContent;
@end
