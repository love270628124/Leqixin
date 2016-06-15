//
//  JpushModel.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/14.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JpushModel : NSObject

@property (nonatomic,strong)NSString *connectStatusStr;
@property (nonatomic,strong)NSString *deviceTokenStr;
@property (nonatomic,strong)NSString *registrationID;
@property (nonatomic,strong)NSDictionary *userInfoDic;
@end
