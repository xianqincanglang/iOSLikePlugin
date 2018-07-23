//
//  CTYUILabelViewController.m
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/7/23.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "CTYUILabelViewController.h"
#import "Constant.h"

@interface CTYUILabelViewController ()

@end

@implementation CTYUILabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self testUILabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
	
#pragma mark - UILabel指定行数，最后一行带有省略号...
- (void)testUILabel{
	
	CGFloat maxWidth = 280;
	
	UILabel *_descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_descriptionLabel.textColor = [UIColor redColor];
	_descriptionLabel.font = [UIFont systemFontOfSize:24];
	_descriptionLabel.textAlignment = NSTextAlignmentLeft;
	_descriptionLabel.numberOfLines = 3;
	_descriptionLabel.layer.borderColor = [UIColor blueColor].CGColor;
	_descriptionLabel.layer.borderWidth = 1.0f;

	[self.view addSubview:_descriptionLabel];

	NSString *textA = @"sdfjskl莱克斯顿缴费了所肩负的了圣诞节来看电视剧斐林试剂东方丽景了看见水电费离开家";
	NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:textA];
	[attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, textA.length)];
	//	attrString
	NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
	paraStyle.lineSpacing = 5;
	paraStyle.alignment = NSTextAlignmentLeft;
	paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
	
	[attrString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, textA.length)];
	
	CGFloat textHeight = [attrString boundingRectWithSize:CGSizeMake(maxWidth, SCREEN_HEIGHT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
	if(textHeight < 2*24){
		textHeight = 24;
	}
	
	_descriptionLabel.attributedText = attrString;
	//因为label设置了属性，导致lineBreakMode失效，不能正常获取到行的高度，需要重新设置一下
	_descriptionLabel.lineBreakMode = NSLineBreakByTruncatingTail;
	_descriptionLabel.frame = CGRectMake(20, 100, maxWidth, textHeight);
	[_descriptionLabel sizeToFit];//需要调用，否则textHeight会为计算出来的高度;
	
	
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
