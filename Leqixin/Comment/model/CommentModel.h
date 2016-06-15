//
//  CommentModel.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/1.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CommentStatusNoHandle = 0,//等待处理
    CommentStatusPassed,//通过
    CommentStatusTrash,//垃圾
    CommentStatusDeleted//删除
} CommentStatus;

@interface CommentModel : NSObject
//@property (nonatomic,strong)NSString *nameStr;
//@property (nonatomic,strong)NSString *iconUrlStr;
//@property (nonatomic,strong)NSString *locationStr;
//@property (nonatomic,assign)CommentStatus status;
//@property (nonatomic,strong)NSString *commentStr;
//@property (nonatomic,strong)NSString *bodyStr;
//@property (nonatomic,strong)NSString *timeStr;
@property (nonatomic,assign)NSInteger addtime;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *customername;
@property (nonatomic,strong)NSString *ischecked;
@property (nonatomic,assign)NSInteger itemid;
@property (nonatomic,assign)CommentStatus status;
@property (nonatomic,strong)NSString *reply;


@end
