//
//  AppDelegate.m
//  Leqixin
//
//  Created by 震霄 张 on 16/3/8.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "GuideView.h"
#import <AdSupport/AdSupport.h>
#import "WebDetialData.h"
#import "WebData.h"

#import "SingletonWebSocket.h"

@interface AppDelegate () <WXApiDelegate,AlertViewDelegate>

@property(nonatomic,strong) UIMutableUserNotificationCategory* categorys;

@end

@implementation AppDelegate

-(NSMutableArray *)haveNewMsgIdArr
{
    if (_haveNewMsgIdArr == nil) {
        _haveNewMsgIdArr = [NSMutableArray array];
    }
    return _haveNewMsgIdArr;
}
- (NSMutableDictionary *)chatRoomDataDic {
    if (!_chatRoomDataDic) {
        _chatRoomDataDic = [NSMutableDictionary dictionary];
    }
    return _chatRoomDataDic;
}

-(NSMutableArray *)receiveUnReadMsgArr
{
    if (_receiveUnReadMsgArr == nil) {
        _receiveUnReadMsgArr = [NSMutableArray array];
    }
    return _receiveUnReadMsgArr;
}
-(NSMutableArray *)pvLast7DayArr
{
    if (_pvLast7DayArr == nil) {
        _pvLast7DayArr = [NSMutableArray array];
    }
    return _pvLast7DayArr;
}
-(NSMutableArray *)uvLast7DayArr
{
    if (_uvLast7DayArr == nil) {
        _uvLast7DayArr = [NSMutableArray array];
    }
    return _uvLast7DayArr;
}
-(NSMutableArray *)spLast7DayArr
{
    if (_spLast7DayArr == nil) {
        _spLast7DayArr = [NSMutableArray array];
    }
    return _spLast7DayArr;
}

-(void)setupView
{
    //登录界面
    
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用(用户引导页面) 作为根视图
        UIViewController * controller = [[UIViewController alloc]init];
        [controller.view addSubview:[[GuideView alloc]initWithFrame:controller.view.frame]];
        self.window.rootViewController = controller;
    }
    else
    {
        NSLog(@"不是第一次启动");
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[LoginViewController alloc]init]];
        self.window.rootViewController = nav;
    }

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.isGrabOut = YES;
//    [NSThread sleepForTimeInterval:3.0];//设置启动页面时间
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    //设置Jpush
    
    // Override point for customization after application launch.
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
  //  self.rootViewController = [[RootViewController alloc]init];
    self.pushModel = [[JpushModel alloc]init];
    
    
#warning e ZHAN 登录
   // [self userLogin];
    [self setupView];
    
    
//    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
//    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
//    
//    [self getUpdateVersion:currentVersion];
    
    [SingletonWebSocket shareWebSocket];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
//    [self registerLocalNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self
                      selector:@selector(registerLocalNotification)
                          name:ReceivedChatMessage object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [self userLogin];//获取E站数据
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    [self getUpdateVersion:currentVersion];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
   // self.rootViewController.deviceTokenValueLabel.text =
   // [NSString stringWithFormat:@"%@", deviceToken];
  //  self.rootViewController.deviceToken =  [NSString stringWithFormat:@"%@", deviceToken];
    self.pushModel.deviceTokenStr = [NSString stringWithFormat:@"%@", deviceToken];
//    self.rootViewController.deviceTokenValueLabel.textColor =
//    [UIColor colorWithRed:0.0 / 255
//                    green:122.0 / 255
//                     blue:255.0 / 255
//                    alpha:1];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    self.pushModel.registrationID = [JPUSHService registrationID];
    [JPUSHService registerDeviceToken:deviceToken];
    
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    self.pushModel.userInfoDic = userInfo;
    NSInteger num = [UIApplication sharedApplication].applicationIconBadgeNumber;
    num += 1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:num];
  //  [self.rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    self.pushModel.userInfoDic = userInfo;
  //  [self.rootViewController addNotificationCount];
    
    NSInteger num = [UIApplication sharedApplication].applicationIconBadgeNumber;
    num += 1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:num];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
    
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    
    return [WXApi handleOpenURL:url delegate:self];
}

-(void) onReq:(BaseReq*)req {
    
    NSLog(@"111111");
}

-(void) onResp:(BaseResp*)resp {
    NSLog(@"%i",resp.type);
    if (resp.errCode == -2) {
        //取消
    }
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.houweiyu.ShareLove.________" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ContactCoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}



- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
//    if (_persistentStoreCoordinator.persistentStores.count == 0) {
//        //需要删除数据库文件
//        
//        
//    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ContactCoreData.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];

    
//    if (_persistentStoreCoordinator.persistentStores.count>0) {
//        //删除数据库
//        [self deleteCoreData];
//    }
    
    NSDictionary *sourceMetaData = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:NSSQLiteStoreType URL:storeURL error:&error];
    NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetaData];
    if (sourceModel == nil) {
        NSLog(@"not found");
    }
    BOOL compare = [self.managedObjectModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetaData];
    if (!compare) {
        
        [self deleteCoreData];

    }
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
    }

    
    return _persistentStoreCoordinator;
}

-(void)deleteCoreData
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *MapLayerDataPath = [documentsDirectory stringByAppendingPathComponent:@"ContactCoreData.sqlite"];
    BOOL bRet = [fileMgr fileExistsAtPath:MapLayerDataPath];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:MapLayerDataPath error:&err];
    }
    
}
- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)getUpdateVersion:(NSString *)versionStr
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:versionStr forKey:@"version"];


    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"New" forKey:@"m"];
    [muDic setObject:@"version_ios" forKey:@"a"];

    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:[NSString stringWithFormat:@"%@/index.php",rootUrl] parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        NSLog(@"%@",dic);
        if ([dic[@"results"] isEqualToString:@"200"]) {
            NSLog(@"没有更新");
        }else if([dic[@"results"]isEqualToString:@"400"]){
            self.versionUpdateUrl = dic[@"url"];
            self.newerVersion = dic[@"number"];
        
        }else{
        
            NSLog(@"update error");
        }


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

-(void)userLogin
{
    //    if ([self.tempDelegate.chergeModel.shujuzhongxin isEqualToString:@"false"]) {
    //        self.sevenJpLabel.text = @"--";
    //        self.sevenPvLabel.text = @"--";
    //        self.sevenSpLabel.text = @"--";
    //        self.sevenUvLabel.text = @"--";
    //        return;
    //    }
    UserInfoModel *model = self.userModel;
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/opt/login";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)model.companyid] forKey:@"uname"];
    [params setObject:@"sdw123456" forKey:@"upwd"];
    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
        if ([responseObject[@"code"] intValue] == 200) {
            
            NSDictionary *loginInfoDic = responseObject[@"param"];
            self.tokenStr = loginInfoDic[@"token"];
            self.idStr = loginInfoDic[@"id"];
            
            
            NSDate *todayDate = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *lastDayDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:todayDate];//前一天
            NSString *lastDayStr= [dateFormatter stringFromDate:lastDayDate];
            
            NSDate *last7DayDate = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:todayDate];//前一天
            NSString *last7DayStr= [dateFormatter stringFromDate:last7DayDate];
            [self requestForDataWithStartTime:last7DayStr endTime:lastDayStr type:@"3"];//请求7天数据
            
        } else if ([responseObject[@"code"] intValue]== 400) {
            
            NSString *error = [NSString stringWithFormat:@"E站%@",responseObject[@"message"]];
            NSLog(@"error:%@",error);
//            AlertView *alter = [[AlertView alloc] initWithTitle:error style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
//            [alter showInView:self.view];
//            [[JSSDWProgressHUD shareProgressHud] hiddenProgressHud];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    }];
}
-(void)requestForDataWithStartTime:(NSString *)startTime endTime:(NSString *)endTime type:(NSString *)type
{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *Eurl = @"http://2016.iezhan.com/ezhan/phone/get/getAllData";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.idStr forKey:@"id"];
    [params setObject:self.tokenStr forKey:@"token"];
    [params setObject:startTime forKey:@"startime"];
    [params setObject:endTime forKey:@"endtime"];
    
    [manger POST:Eurl parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject[@"code"]);
        WebData *data = [WebData mj_objectWithKeyValues:responseObject[@"param"]];
        //        self.sevenPvLabel.text = data.PV;
        //        self.sevenUvLabel.text = data.UV;
        //#warning fix 0522
        //        self.sevenJpLabel.text = [NSString stringWithFormat:@"%@%%",data.JP];
        //        self.sevenSpLabel.text = data.SP;
        
        BOOL isDataValiable = YES;
        if (data.PV==nil || [data.PV isEqualToString:@""]) {
            isDataValiable = NO;
        }
        if (data.UV == nil || [data.UV isEqualToString:@""]) {
            isDataValiable = NO;
        }
        if (data.JP == nil || [data.JP isEqualToString:@""] || [data.JP isEqualToString:@"null"]) {
            isDataValiable = NO;
        }
        if (data.SP == nil || [data.SP isEqualToString:@""]) {
            isDataValiable = NO;
        }
        if (isDataValiable ==YES){
            NSUserDefaults *sevenDefault =[NSUserDefaults  standardUserDefaults];
            [sevenDefault setObject:data.PV forKey:@"sevenPV"];
            [sevenDefault setObject:data.UV forKey:@"sevenUV"];
            [sevenDefault setObject:[NSString stringWithFormat:@"%@%%",data.JP] forKey:@"sevenJP"];
            [sevenDefault setObject:data.SP forKey:@"sevenSP"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
     
- (void)dealloc {
    //
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - 

- (void)registerLocalNotification
{
    NSLog(@"4444");
    
    UIMutableUserNotificationAction* action1 = [[UIMutableUserNotificationAction alloc] init];
    
    action1.identifier = KNotificationActionIdentifileStar;
    action1.authenticationRequired = NO;
    action1.destructive = NO;
    action1.activationMode = UIUserNotificationActivationModeBackground;
    action1.title = @"五分钟后响";
    UIMutableUserNotificationAction* action2 = [[UIMutableUserNotificationAction alloc] init];
    
    action2.identifier = KNotificationActionIdentifileComment;
    action2.title = @"关闭闹钟";
    action2.authenticationRequired = NO;
    action2.destructive = NO;
    action2.activationMode = UIUserNotificationActivationModeBackground;
    
    self.categorys = [[UIMutableUserNotificationCategory alloc] init];
    self.categorys.identifier = KNotificationCategoryIdentifile;
    [self.categorys setActions:@[action1,action2] forContext:UIUserNotificationActionContextDefault];
    UIUserNotificationSettings* newSetting= [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObject:self.categorys]];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:newSetting];
    
    if(newSetting.types==UIUserNotificationTypeNone){
        NSLog(@"aaaaaaaaaaa");
        UIUserNotificationSettings* newSetting= [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObject:self.categorys]];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:newSetting];
    }else{
        NSLog(@"bbbbbbbbbbb");
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self addLocalNotification];
    }
}


#pragma mark - 私有方法
#pragma mark 添加本地通知
- (void) addLocalNotification{
    
    //    NSLog(@"22222");
    [UIApplication sharedApplication].delegate = self;
    UILocalNotification * notification=[[UILocalNotification alloc] init];
    
    notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:0];
    
    notification.alertBody=@"你有新消息！";
    
    notification.repeatInterval=NSCalendarUnitDay;
    
    NSInteger num = [UIApplication sharedApplication].applicationIconBadgeNumber;
    num += 1;
    
    notification.applicationIconBadgeNumber= num;
    notification.hasAction = YES;
    notification.category = KNotificationCategoryIdentifile;
    
    notification.userInfo=@{@"name":@"zhangsan"};
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
}


@end

