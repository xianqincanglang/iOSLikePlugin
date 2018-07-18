//
//  CTYQRCodeHandler.h
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/7/18.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CTYQRCodeHandler : NSObject


+ (UIImage *)qrCodeImageWithDataStr:(NSString *)dataStr size:(CGFloat)size;

+ (UIImage *)qrCodeImageWithQRCodeImage:(UIImage *)qrCodeImage logoImage:(UIImage *)logoImage logoSize:(CGFloat)logoSize;

//指定二维码颜色
+ (UIImage *)qrCodeImageFillBgColor:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue;
//设置圆角
+ (UIImage *)qrCodeImageWithCornerRadius:(CGFloat)cornerRadius image:(UIImage *)image size:(CGSize)size;
@end
