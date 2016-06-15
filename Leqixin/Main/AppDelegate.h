//
//  AppDelegate.h
//  Leqixin
//
//  Created by 震霄 张 on 16/3/8.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "UserInfoModel.h"
#import "ChergeModel.h"
#import "JpushModel.h"
#import "HomeViewController.h"
static NSString *appKey = @"8a597e9ba8af99bee6f6fc82";
static NSString *channel = @"Publish channel";
static BOOL isProduction =  YES;

#define KNotificationActionIdentifileStar @"knotificationActionIdentifileStar"
#define KNotificationActionIdentifileComment @"kNotificationActionIdentifileComment"
#define KNotificationCategoryIdentifile @"KNOtificationCategoryIdentifile"

//e4a00d7eb0b98641bddc77e9
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) UINavigationController * mainNavigationController;

@property (nonatomic,strong)UserInfoModel *userModel;

@property (nonatomic, strong) ChergeModel *chergeModel;


@property (nonatomic,strong)JpushModel *pushModel;

@property (nonatomic,strong)NSString *tokenStr;//E zhan
@property (nonatomic,strong)NSString *idStr;//E zhan

@property (nonatomic,strong)NSMutableArray *pvLast7DayArr;
@property (nonatomic,strong)NSMutableArray *uvLast7DayArr;
@property (nonatomic,strong)NSMutableArray *spLast7DayArr;

@property (nonatomic, assign) BOOL isReceivedNewMsg;
@property (nonatomic,strong)NSMutableArray *receiveUnReadMsgArr;
@property (nonatomic, strong)NSMutableDictionary *chatRoomDataDic;

@property (nonatomic,assign)BOOL isChatRoomExist;

//@property (nonatomic,strong)LeftSortsViewController *leftView;
@property (nonatomic,strong)HomeViewController *homeVc;

@property (nonatomic,strong)UIImage *meIconImage;

@property (nonatomic,strong)NSMutableArray *haveNewMsgIdArr;//有新消息的id

@property (nonatomic,strong)NSString *chatingVistorId;//保存正在聊天的客户ID

@property (nonatomic,assign)BOOL isGrabOut;//是否抢单弹窗

@property (nonatomic,strong)NSString *versionUpdateUrl;//app更新地址
@property (nonatomic,strong)NSString *newerVersion;//新的app版本

//CoreData
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

