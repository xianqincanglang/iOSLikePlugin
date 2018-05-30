//
//  CTYGifFanyeDemoViewController.m
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/3/28.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "CTYGifFanyeDemoViewController.h"
#import "CTYGifDisplayLineImage.h"
#import "CTYGifDisplayLineImageView.h"
@interface CTYGifFanyeDemoViewController ()

@end

@implementation CTYGifFanyeDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CTYGifDisplayLineImageView *displayImageView = [[CTYGifDisplayLineImageView alloc] initWithFrame:CGRectMake(0, 0, 86,86)];
    [displayImageView setCenter:self.view.center];
    [self.view addSubview:displayImageView];
    CTYGifDisplayLineImage *tempImg = [CTYGifDisplayLineImage imageNamed:@"gif_fanye.gif"];
    [displayImageView setImage:tempImg];
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
