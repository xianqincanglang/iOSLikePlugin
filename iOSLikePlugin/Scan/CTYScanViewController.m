//
//  CTYScanViewController.m
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/3/28.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "CTYScanViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface CTYScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>//用于处理采集信息的代理
{
    AVCaptureSession *session;//输入输出的桥梁
    UIView *scanBox;    //扫描框
    CAGradientLayer *scanLayer; //扫描线
}
@end

#define SelfBoundsRect self.view.bounds.size
#define ScanLineH  30
@implementation CTYScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCamera];
    
    
    
}
- (void)setCamera
{
    
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    NSError *inputError;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&inputError];
    if (!input) {
        return;
    }
    
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];//设置代理，在主线程李刷新
    
        output.rectOfInterest =  CGRectMake(0.35f, 0.2f, 0.7f, 0.8f);//设置扫描范围
    
    session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;//高质量采集率
    [session addInput:input];
    [session addOutput:output];
    
    //warning:metadataObjectTypes必须在addOutput之后设置,否则metadataObjectTypes为空
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                   AVMetadataObjectTypeEAN13Code,
                                   AVMetadataObjectTypeEAN8Code,
                                   AVMetadataObjectTypeCode128Code];//设置扫码支持的编码格式,后三者支持条形码,
//    output
    
    //在屏幕上显示摄像头捕获到的图像
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    UIView *maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self.view addSubview:maskView];
    
    
    
    //设置扫描框
    scanBox = [[UIView alloc] initWithFrame:CGRectMake(SelfBoundsRect.width*0.2f, SelfBoundsRect.height*0.35, SelfBoundsRect.width-SelfBoundsRect.width*0.4f, SelfBoundsRect.height-SelfBoundsRect.height*0.7f)];
    scanBox.layer.borderColor = [UIColor greenColor].CGColor;
    scanBox.layer.borderWidth = 1.0f;
    [self.view addSubview:scanBox];
    
    UIImage *borderImag = [UIImage new];
//    [borderImag stretchableImageWithLeftCapWidth:<#(NSInteger)#> topCapHeight:<#(NSInteger)#>]
    
    //扫描线
    scanLayer = [[CAGradientLayer alloc] init];
    scanLayer.frame = CGRectMake(0, 0, scanBox.bounds.size.width, ScanLineH);
    scanLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor brownColor].CGColor];
    scanLayer.startPoint = CGPointZero;
    scanLayer.endPoint = CGPointMake(0, 1);
    [scanBox.layer addSublayer:scanLayer];
    
    //
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [timer fire];
    //开始捕获
    [session startRunning];
}
- (void)moveScanLayer:(NSTimer *)timer
{
    CGRect frame = scanLayer.frame;
    if (scanBox.frame.size.height < (scanLayer.frame.origin.y+ScanLineH+5)) {
        frame.origin.y = -5;
        scanLayer.frame = frame;
    }else{
        frame.origin.y += 5;
        [UIView animateWithDuration:0.1 animations:^{
            scanLayer.frame = frame;
        }];
    }
}
#pragma mark - 获取扫描区域的比例关系
- (CGRect)getScanScrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    return CGRectMake(x, y, width, height);
}

#pragma mark - delegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        [session stopRunning];
        NSLog(@"%@",metadataObject.stringValue);//输出扫描字符串
        [scanLayer removeFromSuperlayer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
