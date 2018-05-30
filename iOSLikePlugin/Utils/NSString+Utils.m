//
//  NSString+Utils.m
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/5/30.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

+(NSString *)IntegerToString:(NSInteger) value
{
    return @(value).stringValue;
}
+(NSInteger)StringToInteger:(NSString *)value
{
    return [value integerValue];
}

@end
