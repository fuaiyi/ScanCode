//
//  NSString+QRCode.h
//  demo
//
//  Created by gaofu on 2017/4/10.
//  Copyright © 2017年 siruijk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (QRCode)
/**
 1.生成二维码
 
 - returns: 黑白普通二维码(大小为300)
 */
-(UIImage*)generateQRCode;



/**
 2.生成二维码
 
 - parameter size: 大小
 
 - returns: 生成带大小参数的黑白普通二维码
 */
-(UIImage*)generateQRCodeWithSize:(CGFloat)size;



/**
 3.生成二维码
 
 - parameter logo: 图标
 
 - returns: 生成带Logo二维码(大小:300)
 */
-(UIImage*)generateQRCodeWithLogo:(UIImage*)logo;



/**
 4.生成二维码
 
 - parameter size: 大小
 - parameter logo: 图标
 
 - returns: 生成大小和Logo的二维码
 */
-(UIImage*)generateQRCodeWithSize:(CGFloat)size
                             logo:(UIImage*)logo;



/**
 5.生成二维码
 
 - parameter size:    大小
 - parameter color:   颜色
 - parameter bgColor: 背景颜色
 - parameter logo:    图标
 
 - returns: 带Logo、颜色二维码
 */
-(UIImage*)generateQRCodeWithSize:(CGFloat)size
                            color:(UIColor*)color
                          bgColor:(UIColor*)bgColor
                             logo:(UIImage*)logo;



/**
 6.生成二维码
 
 - parameter size:            大小
 - parameter color:           颜色
 - parameter bgColor:         背景颜色
 - parameter logo:            图标
 - parameter radius:          圆角
 - parameter borderLineWidth: 线宽
 - parameter borderLineColor: 线颜色
 - parameter boderWidth:      带宽
 - parameter borderColor:     带颜色
 
 - returns: 自定义二维码
 */
-(UIImage*)generateQRCodeWithSize:(CGFloat)size
                            color:(UIColor*)color
                          bgColor:(UIColor*)bgColor
                             logo:(UIImage*)logo
                           radius:(CGFloat)radius
                  borderLineWidth:(CGFloat)borderLineWidth
                  borderLineColor:(UIColor*)borderLineColor
                       boderWidth:(CGFloat)boderWidth
                      borderColor:(UIColor*)borderColor;





@end
