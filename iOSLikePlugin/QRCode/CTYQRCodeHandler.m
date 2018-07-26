//
//  CTYQRCodeHandler.m
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/7/18.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "CTYQRCodeHandler.h"
#import "Constant.h"

/*
 查看资料
 https://cli.im/news/help/category/renshierweima
 https://cli.im/news/260
 https://cli.im/news/tag/qr%E7%A0%81%E7%BA%A0%E9%94%99%E8%83%BD%E5%8A%9B
 */


@implementation CTYQRCodeHandler


#pragma mark - 根据传入的data、size生成简单二维码
+ (CIImage *)createQRCodeImage:(NSString *)dataStr
{
	
//	[self printFilterBuildIn];
//	CIFilter *inputFilter = [CIFilter filterWithName:@"qrcodeHandler"];
//	[inputFilter setDefaults];
//	[inputFilter setValue:[dataStr dataUsingEncoding:NSUTF8StringEncoding] forKey:@"info"];
	
	CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
	[filter setDefaults];//因为滤镜有可能保存上一次的默认属性
	//设置数据(通过filter的kvc)
	NSData *infoData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
	[filter setValue:infoData forKeyPath:@"inputMessage"];
	[filter setValue:@"M" forKey:@"inputCorrectionLevel"];
	//容错率：https://cli.im/news/help/21072，可根据图像确定容错率级别;
	
//	//上色
//	CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
//									   keysAndValues:
//							 @"inputImage",filter.outputImage,
//							 @"inputColor0",[CIColor colorWithCGColor:[UIColor blueColor].CGColor],
//							 @"inputColor1",[CIColor colorWithCGColor:[UIColor whiteColor].CGColor], nil];
//	NSLog(@"colorFilter:%@",colorFilter.inputKeys);
	
	
	
	return filter.outputImage;
	
}


/**
 *对生成的二维码图像进行压缩
 *由于生成的二维码图像尺寸一般都比较小，为了避免模糊,通常需要对他进行压缩以适应图像视图的大小。
  * 其缩放比例一般为图像视图宽度(或高度)与二维码图像宽度(或高度的)的比值.
*/

+ (UIImage *)qrCodeImageWithDataStr:(NSString *)dataStr size:(CGFloat)size
{
	CIImage *image = [self createQRCodeImage:dataStr];
	
	//采用CoreGraphics
	CGRect extent = CGRectIntegral(image.extent);   //get the size of origin image
	CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
	
	//1.创建bitmap
	size_t width = CGRectGetWidth(extent)*scale;
	size_t height = CGRectGetHeight(extent)*scale;
	CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
	CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
	CIContext *context = [CIContext contextWithOptions:nil];
	CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
	CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
	CGContextScaleCTM(bitmapRef, scale, scale);
	CGContextDrawImage(bitmapRef, extent, bitmapImage); //允许在指定的尺寸和位置上画图
	
	//2.保存bitmap到图片
	CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
	CGContextRelease(bitmapRef);
	CGImageRelease(bitmapImage);
	return [UIImage imageWithCGImage:scaledImage];
}



#pragma mark - 自定义二维码图案颜色
+ (UIImage *)qrCodeImageFillBgColor:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue
{
	int imageWidth  = image.size.width;
	int imageHeight = image.size.height;
	size_t bytesPerRow = imageWidth * 4;
	uint32_t* rgbImageBuf = (uint32_t *)malloc(bytesPerRow*imageHeight);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);     //Note:option非常重要，值得重视
	CGContextDrawImage(context, (CGRect){(CGPointZero),(image.size)}, image.CGImage);
	//遍历所有像素点进行替换
	NSUInteger rgb = (red << 16) + (green << 8) + blue;
	
	NSAssert((rgb & 0xffffff00) <= 0xd0d0d000, @"The color of QR code is two close to white color than it will diffculty to scan");
	
	int pixelNum = imageWidth * imageHeight;
	uint32_t *pCurPtr = rgbImageBuf;
	for (int i = 0; i<pixelNum; i++, pCurPtr++) {
		if ((*pCurPtr & 0xffffff00) < 0xd0d0d000) {
			//将黑点变成自定义的颜色
			uint8_t* ptr = (uint8_t*)pCurPtr;
			ptr[3] = red*255;
			ptr[2] = green*255;
			ptr[1] = blue*255;
		}else{
			//将白点变成透明色，如不需要变透明则屏蔽
			uint8_t* ptr = (uint8_t*)pCurPtr;
			ptr[0] = 0;
		}
	}
	
	CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow*imageHeight, ProviderReleaseData);
	CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
										kCGImageAlphaLast | kCGBitmapByteOrder32Little,  dataProvider,
										NULL, YES, kCGRenderingIntentDefault);
	UIImage *resultImage = [UIImage imageWithCGImage:imageRef];
	CGImageRelease(imageRef);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	return resultImage;
}
void ProviderReleaseData(void * __nullable info,const void *  data, size_t size)
{
	free((void *)data);
}

#pragma mark - 带logo的二维码
+ (UIImage *)qrCodeImageWithQRCodeImage:(UIImage *)qrCodeImage logoImage:(UIImage *)logoImage logoSize:(CGFloat)logoSize
{
	UIGraphicsBeginImageContext(qrCodeImage.size);
	[qrCodeImage drawInRect:CGRectMake(0, 0, qrCodeImage.size.width, qrCodeImage.size.height)];
	[logoImage drawInRect:CGRectMake(qrCodeImage.size.width/2-logoSize/2, qrCodeImage.size.height/2-logoSize/2, logoSize, logoSize)];
	UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return finalImage;
}

#pragma mark - 对logo进行圆角处理
+ (UIImage *)qrCodeImageWithCornerRadius:(CGFloat)cornerRadius image:(UIImage *)image size:(CGSize)size
{
	CGRect frame = CGRectMake(0, 0, size.width, size.height);
	UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
	[[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:cornerRadius] addClip];
	[image drawInRect:frame];
	UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return finalImage;
}
@end
