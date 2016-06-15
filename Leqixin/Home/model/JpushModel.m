//
//  JpushModel.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/14.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "JpushModel.h"

@implementation JpushModel

-(NSString *)description
{
    
    return [NSString stringWithFormat:@"status = %@ \n deviceToken = %@ \n registrationID = %@ \n userInfo = %@",_connectStatusStr,_deviceTokenStr,_registrationID,_userInfoDic];
}
@end
