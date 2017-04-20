//
//  NSString+QRCode.m
//  demo
//
//  Created by gaofu on 2017/4/10.
//  Copyright © 2017年 siruijk. All rights reserved.
//

#import "NSString+QRCode.h"
#import "UIImage+Extend.h"

@implementation NSString (QRCode)


/**
 1.生成二维码
 
 - returns: 黑白普通二维码(大小为300)
 */
-(UIImage*)generateQRCode
{
    return [self generateQRCodeWithSize:0.f];
}


/**
 2.生成二维码
 
 - parameter size: 大小
 
 - returns: 生成带大小参数的黑白普通二维码
 */
-(UIImage*)generateQRCodeWithSize:(CGFloat)size
{
    return [self generateQRCodeWithSize:size logo:nil];
}


/**
 3.生成二维码
 
 - parameter logo: 图标
 
 - returns: 生成带Logo二维码(大小:300)
 */
-(UIImage*)generateQRCodeWithLogo:(UIImage*)logo
{
    return [self generateQRCodeWithSize:0 logo:logo];
}


/**
 4.生成二维码
 
 - parameter size: 大小
 - parameter logo: 图标
 
 - returns: 生成大小和Logo的二维码
 */
-(UIImage*)generateQRCodeWithSize:(CGFloat)size
                             logo:(UIImage*)logo
{
    UIColor* color = [UIColor blackColor];//二维码颜色
    UIColor* bgColor = [UIColor whiteColor];//二维码背景颜色
    
    return [self generateQRCodeWithSize:size color:color bgColor:bgColor logo:logo];
}


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
                             logo:(UIImage*)logo
{
    CGFloat radius = 5.0f;//圆角
    CGFloat borderLineWidth = 1.5f;//线宽
    UIColor* borderLineColor = [UIColor grayColor];//线颜色
    CGFloat boderWidth = 8.0f;//白带宽度
    UIColor* borderColor = [UIColor whiteColor];//白带颜色
    
    return [self generateQRCodeWithSize:size color:color bgColor:bgColor logo:logo radius:radius borderLineWidth:borderLineWidth borderLineColor:borderLineColor boderWidth:boderWidth borderColor:borderColor];
}


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
                      borderColor:(UIColor*)borderColor
{
    CIImage* ciImage = [self generateCIImageWithSize:size color:color bgColor:bgColor];
    UIImage *image = [UIImage imageWithCIImage:ciImage];
    if (!logo) return image;
    if (!image) return nil;
    
    CGFloat logoWidth = image.size.width/4;
    CGRect logoFrame = CGRectMake((image.size.width - logoWidth) /  2,(image.size.width - logoWidth) / 2,logoWidth,logoWidth);
    
    // 绘制logo
    UIGraphicsBeginImageContextWithOptions(image.size, false, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    //线框
    UIImage*logoBorderLineImagae = [logo getRoundRectImageWithSize:logoWidth radius:radius borderWidth:borderLineWidth borderColor:borderLineColor];
    //边框
      UIImage*logoBorderImagae = [logoBorderLineImagae getRoundRectImageWithSize:logoWidth radius:radius borderWidth:boderWidth borderColor:borderColor];
    
    [logoBorderImagae drawInRect:logoFrame];
    
    UIImage* QRCodeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return QRCodeImage;
}


/**
 7.生成CIImage
 
 - parameter size:    大小
 - parameter color:   颜色
 - parameter bgColor: 背景颜色
 
 - returns: CIImage
 */
-(CIImage*)generateCIImageWithSize:(CGFloat)size color:(UIColor*)color bgColor:(UIColor*)bgColor
{
    //设置缺省值
    CGFloat QRCodeSize = 300;//默认300
    UIColor* QRCodeColor = [UIColor blackColor];//默认黑色二维码
    UIColor * QRCodeBgColor = [UIColor whiteColor];//默认白色背景
    
    //2.二维码滤镜
    NSData* contentData = [self dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *fileter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [fileter setValue:contentData forKey:@"inputMessage"];
    [fileter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = fileter.outputImage;
    
    //3.颜色滤镜
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    [colorFilter setValue:ciImage forKey:@"inputImage"];
    [colorFilter setValue:[CIColor colorWithCGColor:QRCodeColor.CGColor] forKey:@"inputColor0"];// 二维码颜色
    [colorFilter setValue:[CIColor colorWithCGColor:QRCodeBgColor.CGColor] forKey:@"inputColor1"];// 背景色

    
    //4.生成处理
    CIImage*outImage = colorFilter.outputImage;
    CGFloat scale = QRCodeSize / outImage.extent.size.width;
    
    return [colorFilter.outputImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
}


@end
