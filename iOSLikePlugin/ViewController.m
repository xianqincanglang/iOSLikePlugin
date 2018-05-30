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
    NSArray *tableViewDataArray;
}
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"世界,你好";
    self.view.backgroundColor = [UIColor whiteColor];
    tableViewDataArray = @[kGifFanye,kQRScan,kQRCreate];
    [self createSubView];
    
}

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
