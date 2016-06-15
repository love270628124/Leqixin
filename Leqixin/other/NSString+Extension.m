//
//  NSString+Extension.m
//  zxweibo
//
//  Created by 震霄 张 on 15/8/23.
//  Copyright (c) 2015年 neo. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = font;
    //   return  [text sizeWithAttributes:attributes];
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
}

-(CGSize)sizeWithFont:(UIFont *)font
{
    return  [self sizeWithFont:font maxW:MAXFLOAT];
    //    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    //    attributes[NSFontAttributeName] = font;
    //       return  [text sizeWithAttributes:attributes];
}

@end
