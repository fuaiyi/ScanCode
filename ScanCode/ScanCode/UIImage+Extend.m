//
//  UIImage+Extend.m
//  demo
//
//  Created by gaofu on 2017/3/10.
//  Copyright © 2017年 siruijk. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage (Extend)


-(UIImage*)getRoundRectImageWithSize:(CGFloat)size radius:(CGFloat)radius
{
    return [self getRoundRectImageWithSize:size radius:radius borderWidth:0 borderColor:nil];
}

-(UIImage*)getRoundRectImageWithSize:(CGFloat)size radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor*)borderColor
{
    
    CGFloat scale = 1.0f * self.size.width / size ;
    
    //初始值
    CGFloat defaultBorderWidth = borderWidth * scale;
    UIColor* defaultBorderColor = borderColor ? borderColor : [UIColor clearColor];
    
    radius = radius * scale;
    CGRect react = CGRectMake(defaultBorderWidth,defaultBorderWidth,self.size.width - 2 * defaultBorderWidth,self.size.height - 2 * defaultBorderWidth);
    
    //绘制图片设置
    UIGraphicsBeginImageContextWithOptions(self.size, false, [UIScreen mainScreen].scale);
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:react cornerRadius:radius];
    
    //绘制边框
    path.lineWidth = defaultBorderWidth;
    [defaultBorderColor setStroke];
    [path stroke];
    [path addClip];
    
    //画图片
    [self drawInRect:react];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


-(NSString*)scanCodeContent
{
    NSData *imageData = UIImagePNGRepresentation(self);
    CIImage *ciImage = [CIImage imageWithData:imageData];
    
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(false), kCIContextPriorityRequestLow : @(false)}];
    //创建探测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    NSArray *features = [detector featuresInImage:ciImage];
    CIQRCodeFeature *feature = [features firstObject];
    
    return feature.messageString.length ? feature.messageString : @"未识别!";
}

@end
