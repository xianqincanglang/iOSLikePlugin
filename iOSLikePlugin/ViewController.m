//
//  ViewController.m
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/5/30.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "ViewController.h"

#import <CoreImage/CoreImage.h>
#import "CTYScanViewController.h"
#import "CTYGifFanyeDemoViewController.h"
#import "CTYQRCodeCreateDemoVC.h"
#include <sys/stat.h>

#define kGifFanye   @"gif翻页"
#define kQRScan     @"二维码扫码"
#define kQRCreate   @"二维码生成"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView *tableView;
    NSMutableArray *tableViewDataArray;
}
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    self.title = @"世界,你好";
    self.view.backgroundColor = [UIColor whiteColor];
    tableViewDataArray = [NSMutableArray array];

//    [tableViewDataArray addObject:kGifFanye];
    [tableViewDataArray addObject:kQRScan];
    [tableViewDataArray addObject:kQRCreate];

    [self createSubView];
	
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:4];
//    [userInfo setValue:@"1" forKey:@"1"];
//    [userInfo setValue:@"1" forKey:@"2"];
////    [userInfo setValue:@"1" forKey:@"3"];
////    [userInfo setValue:@"1" forKey:@"4"];
////    [userInfo setValue:@"1" forKey:@"5"];
////    [userInfo setValue:@"1" forKey:@"6"];
//    NSLog(@"你好%@",userInfo);
//	UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 200)]
//	[self.view addSubview:tempView];
//
//	UIButton *temp = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
//	[temp setTitle:@"你好" forState:UIControlStateNormal];
//	[temp setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//	[tempView addSubview:temp];
//	tempView.backgroundColor = [UIColor ]
	
//	UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 88, 88)];
//	bgImage.layer.cornerRadius = 44;
//	bgImage.clipsToBounds = YES;
//	bgImage.image = [UIImage imageNamed:<#(nonnull NSString *)#>];
//	[self.view addSubview:bgImage];
//
//	UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 88, 88)];
//	image.backgroundColor = [UIColor clearColor];
//	bgImage.layer.cornerRadius = 44;
//	bgImage.clipsToBounds = YES;
//	bgImage.image = [UIImage imageNamed:<#(nonnull NSString *)#>];
//	[self.view addSubview:bgImage];
	
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好1"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好12"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好123"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好1234"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好-_"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好—_%"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好a"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好A"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好Ab"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好Abc"]);
//	NSLog(@"%ld/n",[self unicodeLengthOfString:@"你好Abc_"]);
}

//汉字:2个字符，


- (void)createSubView
{
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.bounces = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
}
#pragma mark - tableView delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = tableViewDataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTitle = cell.textLabel.text;
    
    UIViewController *vc;
    if ([cellTitle isEqualToString:kGifFanye]) {
        vc = [[CTYGifFanyeDemoViewController alloc] init];
        
    }else if ([cellTitle isEqualToString:kQRScan]){
        vc = [[CTYScanViewController alloc] init];
    }else if ([cellTitle isEqualToString:kQRCreate]){
        vc = [[CTYQRCodeCreateDemoVC alloc] init];
    }
    
    [self.navigationController pushViewController:vc animated:NO];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableViewDataArray.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - test
- (void)test
{
    //获取沙盒文件
    NSArray *pathArray =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
    NSString *file = [NSString stringWithFormat:@"%@/file.txt",pathArray.firstObject];
    NSString *content = @"test";
    NSError *error;
    [content writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return;
    }
    //对文件映射
    
    //获取文件内容
    NSString *result = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
    
    
}
int mapFile(char * inPathName, void ** outDataPtr, size_t *outDataLength)
{
    int outError = 0;
    struct stat statInfo;
    *outDataPtr = NULL;
    *outDataLength  = 0;
    int fileDescriptor = open(inPathName, O_RDWR,0);
    if (fileDescriptor < 0) {
        outError = errno;
    }else{
        ftruncate(fileDescriptor, statInfo.st_size+4);//增加文件大小
        fsync(fileDescriptor);
        //        *outDataPtr = _MMAPw
    }
    return outError;
    
    
}

@end
