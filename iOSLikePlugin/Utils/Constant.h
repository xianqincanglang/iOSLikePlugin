//
//  Constant.h
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/5/30.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define SCREEN_HEIGHT ([UIScreen instancesRespondToSelector:@selector(fixedCoordinateSpace)] ? [[UIScreen mainScreen].coordinateSpace convertRect:[UIScreen mainScreen].bounds toCoordinateSpace:[UIScreen mainScreen].fixedCoordinateSpace].size.height : [[UIScreen mainScreen] bounds].size.height)

#define SCREEN_WIDTH ([UIScreen instancesRespondToSelector:@selector(fixedCoordinateSpace)] ? [[UIScreen mainScreen].coordinateSpace convertRect:[UIScreen mainScreen].bounds toCoordinateSpace:[UIScreen mainScreen].fixedCoordinateSpace].size.width : [[UIScreen mainScreen] bounds].size.width)

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kStatusBarHeight                 ((isIphoneX) ? (44) : (20))
#define NAV_BAR_HEIGHT                  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) ? (kStatusBarHeight+44) : 44)

#endif /* Constant_h */
