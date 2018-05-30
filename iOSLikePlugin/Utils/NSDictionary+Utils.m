//
//  NSDictionary+Utils.m
//  iOSLikePlugin
//
//  Created by chentianyu on 2018/5/30.
//  Copyright © 2018年 chentianyu. All rights reserved.
//

#import "NSDictionary+Utils.h"

@implementation NSDictionary (Utils)

-(id)safeObjectForKey:(id)aKey
{
    if(aKey && [aKey length])
    {
        return [self objectForKey:aKey];
    }
    return nil;
}

@end
