//
//  RootViewController.h
//  UUChatTableView
//
//  Created by shake on 15/1/4.
//  Copyright (c) 2015年 uyiuyao. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FaceViewController.h"
#import "NewConsultModel.h"

@interface ChatViewController : UIViewController

@property (nonatomic,strong)NSMutableDictionary *msgDic;

@property (nonatomic,strong)NewConsultModel *model;

-(void)regisFirstBecome;
@end
