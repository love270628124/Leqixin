//
//  RecordCmCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFrame.h"
@interface RecordCmCell : UITableViewCell
@property (nonatomic,strong)CommentFrame *cmframe;
@property (nonatomic,weak)UIView *lineView;

+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;


@end
