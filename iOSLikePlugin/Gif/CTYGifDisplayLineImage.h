//
//  CTYGifDisplayLineImage.h
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/3/28.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTYGifDisplayLineImage : UIImage

@property (nonatomic,readonly) NSTimeInterval *frameDurations;
@property (nonatomic,readonly) NSUInteger loopCount;
@property (nonatomic,readonly) NSTimeInterval totalDuratoin;

-(UIImage *)getFrameWithIndex:(NSUInteger)idx;

@end
