//
//  AnswerCmCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UsrAnswerFrame;

@interface AnswerCmCell : UITableViewCell

@property(nonatomic,strong)UsrAnswerFrame *ansFrame;
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;

@end
