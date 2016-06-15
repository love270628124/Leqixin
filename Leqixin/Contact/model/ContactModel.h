//
//  ContactModel.h
//  乐企信
//
//  Created by 震霄 张 on 16/5/19.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (nonatomic,strong)NSString *userid;//公司id
@property (nonatomic,strong)NSString *department;//部门
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *img;//头像
@property (nonatomic,strong)NSString *itemid;//用户id
@property (nonatomic,strong)NSString *name;//用户真实名字
@property (nonatomic,strong)NSString *position;//职位
@property (nonatomic,strong)NSString *initials;//姓
@property (nonatomic,strong)NSString *mobile;//手机
@property (nonatomic,strong)NSString *brithday;//生日
@property (nonatomic,strong)NSString *entry;//入职时间
@property (nonatomic,strong)NSString *telphone;
@property (nonatomic,strong)NSString *type;//数据类型（save,add,delete）
@property (nonatomic,strong)NSString *rows;//行数

@end
