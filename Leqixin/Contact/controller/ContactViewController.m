//
//  ContactViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/5/19.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactViewController.h"
#import "SDContactsTableViewCell.h"
#import "SDContactModel.h"
#import "SDAnalogDataGenerator.h"
#import "ZYPinYinSearch.h"
#import "ContactInfoController.h"
#import "ContactModel.h"
#import "UIImageView+WebCache.h"
#import "Contact.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface ContactViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UISearchBar* _searchBar;
//    NSMutableArray *nameArr;
//    NSArray *phoneArr;
}
@property (nonatomic,strong) NSMutableArray *sectionArray;

@property (nonatomic, strong) NSMutableArray *sectionTitlesArray;
@property (nonatomic, strong) NSMutableArray *dataArray;//显示数据

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *totalDataArr;//全部数据
@property (nonatomic,strong)NSMutableArray *indexArr;//全部搜索到的序列


@property (strong, nonatomic) NSMutableArray *newArray;
@property (strong, nonatomic)NSString *allNumStr;

@end

@implementation ContactViewController

@synthesize context;

-(NSMutableArray *)newArray
{
    if (_newArray == nil) {
        _newArray = [NSMutableArray array];
    }
    return _newArray;
}

-(NSMutableArray *)indexArr
{
    if (_indexArr == nil) {
        _indexArr = [NSMutableArray array];
    }
    return _indexArr;
}

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)totalDataArr
{
    if (_totalDataArr == nil) {
        _totalDataArr = [NSMutableArray array];
    }
    return _totalDataArr;
}
-(void)setupNav
{
    self.view.backgroundColor =[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"bt_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    self.title = @"通讯录";
    
}
-(void)backBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - coredata event

- (void)searchDataFromCoreData {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //1. 获得context
    NSManagedObjectContext *myContext = delegate.managedObjectContext;
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"Contact" inManagedObjectContext:myContext];
    [request setEntity:user];
    //排序
//    NSSortDescriptor* sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
//    NSArray* sortDescriptions=[[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [request setSortDescriptors:sortDescriptions];
    
    //根据查询条件查询数据
//    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"itemid==%@",model.itemid];
//    [request setPredicate:predicate];
    
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[myContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    for (Contact* aUser in mutableFetchResult) {
        NSLog(@"contact = %@",aUser);
    }
    
}

//增加数据
- (void)insert:(ContactModel *)model{
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //1. 获得context
    NSManagedObjectContext *myContext = delegate.managedObjectContext;
    //2. 找到实体结构,并生成一个实体对象
    /*     NSEntityDescription实体描述，也就是表的结构     参数1：表名字     参数2:实例化的对象由谁来管理，就是context     */    NSManagedObject *person = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:myContext];
    //3. 设置实体属性值
    [person setValue:model.name forKey:@"name"];
    [person setValue:model.department forKey:@"department"];
    [person setValue:model.img forKey:@"img"];
    [person setValue:model.itemid forKey:@"itemid"];
    [person setValue:model.position forKey:@"position"];
    [person setValue:model.initials forKey:@"initials"];
    [person setValue:model.mobile forKey:@"mobile"];
    [person setValue:model.brithday forKey:@"brithday"];
    [person setValue:model.entry forKey:@"entry"];
    [person setValue:model.type forKey:@"type"];
    [person setValue:model.rows forKey:@"rows"];
    [person setValue:model.userid forKey:@"userid"];
    [person setValue:model.email forKey:@"email"];
    [person setValue:model.telphone forKey:@"telphone"];

    //4. 调用context,保存实体,如果没有成功，返回错误信息
    NSError *error;
    if ([myContext save:&error]) {
        NSLog(@"save ok");
    }
    else{
        NSLog(@"%@",error);
    }
}
// 删除
- (void)deleteData:(ContactModel *)model
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //1. 获得context
    NSManagedObjectContext *myContext = delegate.managedObjectContext;

    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"Contact" inManagedObjectContext:myContext];
    [request setEntity:user];
    //查询条件
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"itemid==%@",model.itemid];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[myContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    for (Contact* aUser in mutableFetchResult) {
        [myContext deleteObject:aUser];
    }
    
    if ([myContext save:&error]) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
    
}
//更改数据
- (void)updateData:(ContactModel *)model
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //1. 获得context
    NSManagedObjectContext *myContext = delegate.managedObjectContext;
    
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:@"Contact" inManagedObjectContext:myContext];
    [request setEntity:user];
    //查询条件
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"itemid==%@",model.itemid];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[myContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %lu",(unsigned long)[mutableFetchResult count]);
    //更新age后要进行保存，否则没更新
    for (Contact* aUser in mutableFetchResult) {
        [aUser setValue:model.name forKey:@"name"];
        [aUser setValue:model.department forKey:@"department"];
        [aUser setValue:model.img forKey:@"img"];
        [aUser setValue:model.itemid forKey:@"itemid"];
        [aUser setValue:model.position forKey:@"position"];
        [aUser setValue:model.initials forKey:@"initials"];
        [aUser setValue:model.mobile forKey:@"mobile"];
        [aUser setValue:model.brithday forKey:@"brithday"];
        [aUser setValue:model.entry forKey:@"entry"];
        [aUser setValue:model.type forKey:@"type"];
        [aUser setValue:model.rows forKey:@"rows"];
        [aUser setValue:model.userid forKey:@"userid"];
    }
    [myContext save:&error];
    
}


//从数据库读取通讯录数据

-(NSMutableArray *)readDataWithCompanyId:(NSString *)companyId
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //1. 获得context
    NSManagedObjectContext *myContext = delegate.managedObjectContext;
    //创建取回数据请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //设置要检索哪种类型的实体对象
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contact" inManagedObjectContext:myContext];
    //设置请求实体
    [request setEntity:entity];
    //查询条件
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"userid==%@",companyId];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    //执行获取数据请求，返回数组
    NSMutableArray *mutableFetchResult = [[myContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult == nil) {
        NSLog(@"Error: %@,%@",error,[error userInfo]);
    } else {
        //指定对结果的排序方式
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"ascending:NO];
        NSArray *sortDescriptions = [[NSArray alloc]initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptions];
    }
    
//    self.dataArray = mutableFetchResult;
    return mutableFetchResult;

}

//所有通讯录数据保存到数据库
-(void)saveAllData:(NSArray *)dataArr
{
    if (dataArr.count == 0) {
        return;
    }
    for (ContactModel *model in dataArr) {
        
        if ([self.dataArray containsObject:model]) {
            [self updateData:model];
        }else{
            [self insert:model];
        }
    }
    
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupSearchBar];


    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
     self.dataArray =[self readDataWithCompanyId:[NSString stringWithFormat:@"%li",(long)tempDelegate.userModel.companyid]];//从数据库读取本地数据
    self.totalDataArr = [self.dataArray mutableCopy];//保存全部数据
    [self setUpTableSection];
    [self setupContactView];//加载页面
    [self requestData];
}


-(void)setupSearchBar
{
    //创建searchBar对象
    _searchBar = [[UISearchBar alloc] init];
    //设置搜索框的占位符
    _searchBar.placeholder = @"请输入搜索的内容";
    //设置search的样式
    _searchBar.barStyle = UIBarStyleDefault;
    //搜索条的颜色
    _searchBar.barTintColor = ZXcolor(228, 228, 229);
//    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.backgroundImage = [[UIImage alloc] init];
    _searchBar.translucent = NO;
    _searchBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 46);
    //设置delegate
    _searchBar.delegate = self;
    [_searchBar setImage:[[UIImage alloc]init] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    //一个表只有一个表头:并且这个表头是一个空指针
    [self.view addSubview:_searchBar];
    
//    遮住搜索框中的叉号，去掉你就会发现问题了，嘻嘻－－
//        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_searchBar addSubview:btn1];
//        btn1.frame = CGRectMake(_searchBar.bounds.size.width - 30, 5, 30, 28);
//        btn1.backgroundColor = [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1];
}


-(void)setupContactView
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.frame = CGRectMake(0, 46, self.view.bounds.size.width, self.view.bounds.size.height-46-64);
    self.tableView.rowHeight = [SDContactsTableViewCell fixedHeight];
    self.tableView.sectionIndexColor = [UIColor lightGrayColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.sectionHeaderHeight = 25;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
-(void)requestData
{
    AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UserInfoModel *userModel = tempDelegate.userModel;
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *timeStr = [defaults valueForKey:@"contactTime"];
    if (timeStr == nil) {
        timeStr = @"0";
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)userModel.companyid] forKey:@"userid"];

    [params setObject:timeStr forKey:@"time"];//先传0测试
    
    NSString *url = [NSString stringWithFormat:@"%@/index.php",rootUrl];
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    [muDic setObject:@"Interface" forKey:@"g"];
    [muDic setObject:@"New" forKey:@"m"];
    [muDic setObject:@"communication" forKey:@"a"];
    
    [muDic setObject:[self dictionaryToJson:params] forKey:@"data"];
    [manager GET:url parameters:muDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //保存总共通讯录人数

        self.allNumStr = dic[@"number"];
        
        if ([dic[@"result"] isEqualToString:@"0"]) {//没有更新数据
            NSLog(@"没有更新数据");
            
            if (self.dataArray.count == 0 || self.dataArray.count<[self.allNumStr integerValue]) {
                NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
                NSString *timeString = @"0";
                [defaults setObject:timeString forKey:@"contactTime"];
                [self requestData];
            }
            
        } else {
            self.newArray = [ContactModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            //如果是第一次请求，保存到数据库
            if (self.newArray.count == [dic[@"number"] integerValue]) {
                [self.dataArray removeAllObjects];
                [self saveAllData:self.newArray];
               self.dataArray = [self readDataWithCompanyId:[NSString stringWithFormat:@"%li",(long)userModel.companyid]];//从数据库读取本地数据
            } else {
                //根据数据类型处理新数据(增，删，改，以及保存到数据库)
                [self manageNewArr:(self.newArray)];
            }
            [self setUpTableSection];//将数据进行转化
            [self.tableView reloadData];
        }
        self.totalDataArr = [self.dataArray mutableCopy];//保存全部数据
        
        
        //保存请求成功当前的时间戳
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        long long int date = (long long int)time;
        NSString *timeString = [NSString stringWithFormat:@"%lld", date];
        [defaults setObject:timeString forKey:@"contactTime"];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);

    }];


}

//处理服务器返回的数据（增加，删除，修改）
-(void)manageNewArr:(NSArray *)newArr
{
    if (newArr.count == 0) {
        return;
    }
    
    for (ContactModel *model in newArr) {
        //add
        if ([model.type isEqualToString:@"add"]) {
            [self.dataArray addObject:model];
            [self insert:model];//添加到数据库
            
        }else if ([model.type isEqualToString:@"save"]){
            //edit
            NSInteger index = [self getIndexFromArr:self.dataArray withObj:model];
            if (index>=0) {
                [self.dataArray replaceObjectAtIndex:index withObject:model];
                [self updateData:model];
            }

        }else if ([model.type isEqualToString:@"delete"]){
            //delete
            NSInteger index = [self getIndexFromArr:self.dataArray withObj:model];
            if (index > 0) {
                [self.dataArray removeObjectAtIndex:index];
                [self deleteData:model];
            }
            
        }
    }
    
}
-(NSInteger)getIndexFromArr:(NSArray *)dataArr withObj:(ContactModel *)model
{
    if (dataArr.count==0) {
        return -1;
    }
    for (int i = 0;i<dataArr.count;i++) {
        ContactModel *tempModel = dataArr[i];
        if ([model.itemid isEqualToString:tempModel.itemid]) {
            return i;
        }
    }
    return -2;
}

//字典转json字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void) setUpTableSection {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //create a temp sectionArray
    NSUInteger numberOfSections = [[collation sectionTitles] count];
    NSMutableArray *newSectionArray =  [[NSMutableArray alloc]init];
    for (NSUInteger index = 0; index<numberOfSections; index++) {
        [newSectionArray addObject:[[NSMutableArray alloc]init]];
    }
    
    // insert Persons info into newSectionArray
    for (ContactModel *model in self.dataArray) {
        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(name)];
        [newSectionArray[sectionIndex] addObject:model];
    }
    
    //sort the person of each section
    for (NSUInteger index=0; index<numberOfSections; index++) {
        NSMutableArray *personsForSection = newSectionArray[index];
        NSArray *sortedPersonsForSection = [collation sortedArrayFromArray:personsForSection collationStringSelector:@selector(name)];
        newSectionArray[index] = sortedPersonsForSection;
    }
    
    NSMutableArray *temp = [NSMutableArray new];
    self.sectionTitlesArray = [NSMutableArray new];
    
    [newSectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {
        if (arr.count == 0) {
            [temp addObject:arr];
        } else {
            [self.sectionTitlesArray addObject:[collation sectionTitles][idx]];
        }
    }];
    [newSectionArray removeObjectsInArray:temp];
    self.sectionArray = newSectionArray;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitlesArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"SDContacts";
    SDContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SDContactsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    ContactModel *model = self.sectionArray[section][row];
    cell.model = model;
    //NSLog(@"self.sectionArray == %@",self.sectionArray);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60*SCREEN_SCALE_H;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitlesArray objectAtIndex:section];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitlesArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ContactModel *model = self.sectionArray[indexPath.section][indexPath.row];
    ContactInfoController *vc = [[ContactInfoController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

//滚动键盘隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [_searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma -mark searchBarDelegate点击搜索按钮时调用
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSMutableArray *newArr = [NSMutableArray array];
    //主要功能，调用方法实现搜索
    newArr = [ZYPinYinSearch searchWithOriginalArray:self.totalDataArr andSearchText:searchBar.text andSearchByPropertyName:@"name"];
    [newArr addObjectsFromArray:[ZYPinYinSearch searchWithOriginalArray:self.totalDataArr andSearchText:searchBar.text andSearchByPropertyName:@"department"]];
    [newArr addObjectsFromArray:[ZYPinYinSearch searchWithOriginalArray:self.totalDataArr andSearchText:searchBar.text andSearchByPropertyName:@"position"]];
//    NSLog(@"name %@",newArr);
    
    //数组去重

    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [newArr count]; i++){
        if ([categoryArray containsObject:[newArr objectAtIndex:i]] == NO){
            [categoryArray addObject:[newArr objectAtIndex:i]];
        }
        
    }
    
    //删除一开始数据
    [self.dataArray removeAllObjects];
    
    //重新添加数据
    for (int i = 0; i < categoryArray.count; i++)
    {
        ContactModel *model = newArr[i];
        [self.dataArray addObject:model];
    }
    [self setUpTableSection];
    [_tableView reloadData];
    [_searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //搜索条件为空时，重新加载界面
    if ([searchText isEqualToString:@""]) {
        [_searchBar resignFirstResponder];
//        [self viewDidLoad];
        
        self.dataArray = self.totalDataArr;
//        AppDelegate *tempDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        self.dataArray =[self readDataWithCompanyId:[NSString stringWithFormat:@"%li",(long)tempDelegate.userModel.companyid]];//从数据库读取本地数据
//        self.totalDataArr = [self.dataArray mutableCopy];//保存全部数据
//
        [self setUpTableSection];
        [_tableView reloadData];
    }
    else{
        NSMutableArray *newArr1 = [NSMutableArray array];

        //主要功能，调用方法实现搜索
        newArr1 = [ZYPinYinSearch searchWithOriginalArray:self.totalDataArr andSearchText:searchText andSearchByPropertyName:@"name"];
        [newArr1 addObjectsFromArray:[ZYPinYinSearch searchWithOriginalArray:self.totalDataArr andSearchText:searchText andSearchByPropertyName:@"department"]];
        [newArr1 addObjectsFromArray:[ZYPinYinSearch searchWithOriginalArray:self.totalDataArr andSearchText:searchText andSearchByPropertyName:@"position"]];
        
//        NSLog(@"name %@",newArr1);
        //数组去重
        NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
        for (unsigned i = 0; i < [newArr1 count]; i++){
            if ([categoryArray containsObject:[newArr1 objectAtIndex:i]] == NO){
                [categoryArray addObject:[newArr1 objectAtIndex:i]];
            }
        }
        
        //移除原有数据
        [self.dataArray removeAllObjects];
        //添加新数据
        for (int i = 0; i < categoryArray.count; i++)
        {
            ContactModel *model =  newArr1[i];
            [self.dataArray addObject:model];
        }

        [self setUpTableSection];
        [_tableView reloadData];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
