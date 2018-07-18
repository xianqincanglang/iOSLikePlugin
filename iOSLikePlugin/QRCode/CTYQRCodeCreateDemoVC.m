//
//  CTYQRCodeCreateDemoVC.m
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/3/28.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "CTYQRCodeCreateDemoVC.h"
#import "Constant.h"
#import "CTYQRCodeHandler.h"
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


- (void)qrCorde
{
    //二维码
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
    [self.view addSubview:imageView];
    imageView.center = CGPointMake(SCREEN_WIDTH/2, imageView.center.y);
	
	UIImage *originImage = [CTYQRCodeHandler qrCodeImageWithDataStr:@"你好" size:300];
	UIImage *colorImage = [CTYQRCodeHandler qrCodeImageFillBgColor:originImage red:155 green:200 blue:100];
	
	UIImage *clipImage = [CTYQRCodeHandler qrCodeImageWithCornerRadius:50 image:[UIImage imageNamed:@"qrcode"] size:CGSizeMake(100, 100)];
	UIImage *finalImage =  [CTYQRCodeHandler qrCodeImageWithQRCodeImage:colorImage logoImage:clipImage logoSize:100] ;
    imageView.image = finalImage;
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 205, 100, 40)];
    firstLabel.text = @"普通二维码";
    firstLabel.font = [UIFont systemFontOfSize:14.0f];
    firstLabel.textColor = [UIColor grayColor];
    [self.view addSubview:firstLabel];
    [firstLabel sizeToFit];
    firstLabel.center = CGPointMake(SCREEN_WIDTH/2, firstLabel.center.y);
    
//    //二维码+logo
//    UIImageView *customColorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 250, 100, 100)];
//    [self.view addSubview:customColorImageView];
//    customColorImageView.center = CGPointMake(SCREEN_WIDTH/2, customColorImageView.center.y);
//    customColorImageView.image = [self imageFillBlackColorAndTransparent:originImage red:220 green:120 blue:198];
//    
//    UILabel *customColorDescriptLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, customColorImageView.frame.origin.y+customColorImageView.frame.size.height+5, 100, 40)];
//    customColorDescriptLabel.text = @"自定义图案颜色的二维码";
//    customColorDescriptLabel.font = [UIFont systemFontOfSize:14.0f];
//    customColorDescriptLabel.textColor = [UIColor grayColor];
//    [self.view addSubview:customColorDescriptLabel];
//    [customColorDescriptLabel sizeToFit];
//    customColorDescriptLabel.center = CGPointMake(SCREEN_WIDTH/2, customColorDescriptLabel.center.y);
}




@end
