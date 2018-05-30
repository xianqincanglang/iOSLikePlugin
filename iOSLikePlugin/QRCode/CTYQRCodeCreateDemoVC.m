//
//  CTYQRCodeCreateDemoVC.m
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/3/28.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "CTYQRCodeCreateDemoVC.h"
#import "Constant.h"
/**
 限制:iOS 7之后，可使用苹果生成二维码
 1.使用CIFilter滤镜类生成二维码
 2.对生成的二维码进行加工，使其更加清晰
 3.自定义二维码图案颜色
    定义二维码颜色的实现思路是，遍历生成的二维码的像素点，将其中为白色的像素点填充为透明色，非白色则填充为我们自定义的颜色。但是，这里的白色并不单单指纯白色，rgb值高于一定数值的灰色我们也可以视作白色处理。在这里我对白色的定义为rgb值高于0xd0d0d0的颜色值为白色
 4.在二维码中心插入圆角小图片
 
 */


@interface CTYQRCodeCreateDemoVC ()



@end

@implementation CTYQRCodeCreateDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self qrCorde];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CIImage *)createQrcode
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    //设置数据(通过filter的kvc)
    NSString *info = @"你好";
    NSData *infoData = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:infoData forKeyPath:@"inputMessage"];
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",filter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:[UIColor blueColor].CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:[UIColor whiteColor].CGColor], nil];
    NSLog(@"colorFilter:%@",colorFilter.inputKeys);
    
    return [filter outputImage];
    
}
- (void)qrCorde
{
    //二维码
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
    [self.view addSubview:imageView];
    imageView.center = CGPointMake(SCREEN_WIDTH/2, imageView.center.y);
    UIImage *originImage = [self handleImageFilteredCIImage:[self createQrcode] size:300];
    imageView.image = originImage;
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 205, 100, 40)];
    firstLabel.text = @"普通二维码";
    firstLabel.font = [UIFont systemFontOfSize:14.0f];
    firstLabel.textColor = [UIColor grayColor];
    [self.view addSubview:firstLabel];
    [firstLabel sizeToFit];
    firstLabel.center = CGPointMake(SCREEN_WIDTH/2, firstLabel.center.y);
    
    //二维码+logo
    UIImageView *customColorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 250, 100, 100)];
    [self.view addSubview:customColorImageView];
    customColorImageView.center = CGPointMake(SCREEN_WIDTH/2, customColorImageView.center.y);
    customColorImageView.image = [self imageFillBlackColorAndTransparent:originImage red:220 green:120 blue:198];
    
    UILabel *customColorDescriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, customColorImageView.frame.origin.y+customColorImageView.frame.size.height+5, 100, 40)];
    customColorDescriptLabel.text = @"自定义图案颜色的二维码";
    customColorDescriptLabel.font = [UIFont systemFontOfSize:14.0f];
    customColorDescriptLabel.textColor = [UIColor grayColor];
    [self.view addSubview:customColorDescriptLabel];
    [customColorDescriptLabel sizeToFit];
    customColorDescriptLabel.center = CGPointMake(SCREEN_WIDTH/2, customColorDescriptLabel.center.y);
}

//根据CIImage生成指定大小的UIImage
- (UIImage *)handleImageFilteredCIImage:(CIImage *)image size:(CGFloat)size
{
    
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
#pragma mark - 3.自定义二维码图案颜色
- (UIImage *)imageFillBlackColorAndTransparent:(UIImage *)image red:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue
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
#pragma mark 5.带logo的二维码


@end
