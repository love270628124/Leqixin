//
//  SDAnalogDataGenerator.m
//
//  Created by 侯伟玉 on 16/3/10.
//  Copyright © 2016年 侯伟玉. All rights reserved.
//
//----------------------------------QQ:846286641-------------------------------------------
//**********************************备注姓名***********************************************
//模拟器无法实现拨号，建议真机调试（号码我随便写的，记得改一下）
//
//没事写的一个类似手机通讯录的Demo，代码没整理，有点乱，不喜勿喷
//欢迎加QQ：846286641 交流
//
//
//
//

#import "SDAnalogDataGenerator.h"

static NSArray *namesArray;
static NSArray *iconNamesArray;
static NSArray *messagesArray;

@implementation SDAnalogDataGenerator



+ (NSString *)randomIconImageName
{
    int randomIndex = arc4random_uniform((int)[self iconNames].count);
    return iconNamesArray[randomIndex];
}


+ (NSArray *)iconNames
{
    if (!iconNamesArray) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < 24; i++) {
            NSString *iconName = [NSString stringWithFormat:@"%d.jpg", i];
            [temp addObject:iconName];
        }
        iconNamesArray = [temp copy];
    }
    return iconNamesArray;
}



@end
