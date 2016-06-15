//
//  ConsultModel.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/19.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsultModel : NSObject

@property (nonatomic,strong)NSString *total;//总询盘数
@property (nonatomic,strong)NSString *reception;//已接待人数
@property (nonatomic,strong)NSString *total_today;//今日询盘人数
@property (nonatomic,strong)NSString *reception_today;//今日接待人数

@property (nonatomic,strong)NSString *totalReceptRate;//总接待lv
@property (nonatomic,strong)NSString *todayReceptRate;//今日接待率

@end

