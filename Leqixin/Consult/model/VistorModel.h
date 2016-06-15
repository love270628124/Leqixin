//
//  VistorModel.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/19.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VistorModel : NSObject

@property (nonatomic,strong)NSString *nameid;//聊天编号
@property (nonatomic,strong)NSString *img;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *country;//来自省市
@property (nonatomic,assign)NSInteger time;//时间戳
@property (nonatomic,strong)NSString *itemid;
@property (nonatomic,assign)BOOL isHaveNewMsg;//是否有新消息

//@property (nonatomic,strong)NSString *area;
//@property (nonatomic,assign)NSInteger itemid;
//@property (nonatomic,strong)NSString *name;
//@property (nonatomic,strong)NSString *pagetitle;
//@property (nonatomic,strong)NSString *pageurl;
//@property (nonatomic,strong)NSString *remark;
//@property (nonatomic,assign)NSInteger staytime;
//@property (nonatomic,strong)NSString *telphone;
//@property (nonatomic,strong)NSString *type;
//@property (nonatomic,assign)NSInteger userid;
//@property (nonatomic,assign)NSInteger workerid;


@end
