//
//  UserInfoModel.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/13.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic,assign)NSInteger companyid;
@property (nonatomic,strong)NSString *companyname;
@property (nonatomic,strong)NSString *haeremai;//快捷语句
@property (nonatomic,strong)NSString *headimg;//头像
@property (nonatomic,assign)NSInteger isshow;
@property (nonatomic,strong)NSString *nickname;
@property (nonatomic,assign)NSString *password;
@property (nonatomic,strong)NSString *qrcodepath;
@property (nonatomic,assign)NSInteger telphone;
@property (nonatomic,strong)NSString *truename;//真是姓名
@property (nonatomic,assign)NSInteger userid;
@property (nonatomic,assign)NSInteger waittime;
@property (nonatomic,assign)NSInteger birthday_status;
@property (nonatomic,strong)NSString *blog;
@property (nonatomic,strong)NSString *brithday;
@property (nonatomic,strong)NSString *department;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *entry;//进公司时间
@property (nonatomic,assign)NSInteger groupid;
@property (nonatomic,strong)NSString *groupname;
@property (nonatomic,strong)NSString *initials;
@property (nonatomic,assign)NSInteger isdel;
@property (nonatomic,assign)NSInteger leavetime;
@property (nonatomic,strong)NSString *lastdevice;
@property (nonatomic,strong)NSString *lastdevicetoken;
@property (nonatomic,assign)NSInteger logintime;
@property (nonatomic,assign)NSInteger mobile;
@property (nonatomic,strong)NSString *officer;//职位
@property (nonatomic,assign)NSInteger sex;
@property (nonatomic,assign)NSInteger updatetime;
@property (nonatomic,strong)NSString *username;//账号名称
@property (nonatomic,strong)NSString *wxnumber;// 微信号
@property (nonatomic,strong)NSString *wxqrcodepath;
@property (nonatomic,strong)NSString *domain;

@property (nonatomic, strong) NSString *thumb;

@end
