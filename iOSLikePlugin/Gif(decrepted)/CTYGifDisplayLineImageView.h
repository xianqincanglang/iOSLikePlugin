//
//  CTYGifDisplayLineImageView.h
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/3/28.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTYGifDisplayLineImage.h"
@interface CTYGifDisplayLineImageView : UIImageView

@property (nonatomic,copy) NSString *runLoopMode;
-(void)setAnimatedImage:(CTYGifDisplayLineImage *)animatedImage;

@end
