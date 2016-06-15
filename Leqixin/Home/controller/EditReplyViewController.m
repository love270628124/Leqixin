//
//  EditReplyViewController.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/25.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "EditReplyViewController.h"

#define editReplyCellHeight 50
#define footViewHeight 60

@interface EditReplyViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong)NSMutableArray *replyArr;
@property(nonatomic,weak)UITableView *tableView;
@property (nonatomic,weak)UITextField *textField;

@property (nonatomic,assign)CGFloat keyboardH;
@end

@implementation EditReplyViewController

-(NSMutableArray *)replyArr
{
    if (_replyArr == nil) {
        _replyArr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]valueForKey:@"quickReply"]];
        if (_replyArr == nil) {
            _replyArr = [NSMutableArray array];
        }
//       [_replyArr addObjectsFromArray:@[@"您好，有什么能帮到您",@"刚在开会",@"你电话号码多少的",@"eeee"]];
//        [_replyArr addObjectsFromArray:self.savedReplyArr];
    }
    return _replyArr;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnClick:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

    self.title = @"快捷回复";
    UITableView *tableView = [[UITableView alloc]init];
    tableView.x = 0;
    tableView.y = 0;
    tableView.width = SCREEN_W;
    //tableView.height = editReplyCellHeight * self.replyArr.count*SCREEN_SCALE_H+footViewHeight * SCREEN_SCALE_H;
    tableView.height = SCREEN_H-64;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"editReplyCell"];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    [tableView setEditing:YES animated:YES];
    [self.view addSubview:tableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    tap.delegate = self;
    [self.tableView addGestureRecognizer:tap];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:self.view];
    if(location.x<40*SCREEN_SCALE_W)
    {
        return NO;
    }
    return YES;
}

- (void)tapGes:(UITapGestureRecognizer *)aTapGes {
        [self.view endEditing:YES];
}

#pragma mark uitableViewDelegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 2) {
//        return UITableViewCellEditingStyleInsert;
//    }else
        return UITableViewCellEditingStyleDelete;     //return UITableViewCellEditingStyleInsert;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)     {
        [self.replyArr removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];

    }else if(editingStyle == UITableViewCellEditingStyleInsert)     {
        [self.replyArr insertObject:@"new Item" atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.replyArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return editReplyCellHeight * SCREEN_SCALE_H;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return footViewHeight * SCREEN_SCALE_H;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:229/255.0 alpha:1.0];
    UIButton *addBtn = [[UIButton alloc]init];
    addBtn.x = 16 * SCREEN_SCALE_W;
    addBtn.y = 16 * SCREEN_SCALE_H;
    addBtn.width = 21 * SCREEN_SCALE_W;
    addBtn.height = addBtn.width;
    [addBtn setBackgroundImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    [view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addQuickReplyBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    UITextField *textFied = [[UITextField alloc]init];
    textFied.x = CGRectGetMaxX(addBtn.frame)+16 * SCREEN_SCALE_W;
    textFied.y = addBtn.y;
    textFied.width = SCREEN_W - 2 * textFied.x;
    textFied.height = addBtn.height;
    textFied.font = [UIFont systemFontOfSize:18];
    textFied.placeholder = @"添加新回复";
    textFied.adjustsFontSizeToFitWidth = YES;
    //[textFied becomeFirstResponder];
    [view addSubview:textFied];
    self.textField = textFied;
   // [textFied setValue:[UIColor orangeColor] forKeyPath:@"_placeholderLabel.textColor"];
    return view;
}

-(void)addQuickReplyBtnClick:(UIButton *)btn
{
    if (self.textField.text.length>0) {
        [self.replyArr addObject:self.textField.text];
        self.textField.text = nil;
        [self.textField resignFirstResponder];
        [self.tableView reloadData];
        //进行快捷回复存储
    }else{
        AlertView *showView = [[AlertView alloc]initWithTitle:@"请输入内容再添加" style:kAlertViewStyleWarn showTime:kAlerViewShowTimeOneSecond];
        [showView showInView:self.view];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editReplyCell" forIndexPath:indexPath];
    cell.textLabel.text = self.replyArr[indexPath.row];

    return cell;
}
-(void)backBtnClick:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)complete:(UIButton *)btn
{
    if (self.textField.text.length>0) {
        [self addQuickReplyBtnClick:nil];
    }
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//    [self.replyArr addObject:self.textField.text];
    [defaults setObject:self.replyArr forKey:@"quickReply"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 伴随键盘移动

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (notification.name == UIKeyboardWillShowNotification)
    {
        NSLog(@"%f-%f",keyboardEndFrame.size.height,self.keyboardH);
        self.tableView.height -= keyboardEndFrame.size.height-self.keyboardH;
        self.keyboardH = keyboardEndFrame.size.height;

    }else
    {
        self.tableView.height += keyboardEndFrame.size.height;
        self.keyboardH = 0.f;
//        self.keyboardH = keyboardEndFrame.size.height;
        

    }
    [self.view layoutIfNeeded];
    [UIView commitAnimations];
}
- (void)tableViewScrollToBottom
{
    if (self.replyArr.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.replyArr.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.view endEditing:YES];
//}
@end
