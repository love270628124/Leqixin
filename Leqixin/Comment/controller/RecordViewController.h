//
//  RecordViewController.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    ChoiceStatusAll = 0,//等待处理
    ChoiceStatusPassed,//通过
    ChoiceStatusTrash,//垃圾
    ChoiceStatusHandled//已处理
} ChoiceStatus;
@interface RecordViewController : UIViewController

@end
