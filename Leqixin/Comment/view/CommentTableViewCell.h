//
//  CommentTableViewCell.h
//  乐企信
//
//  Created by 震霄 张 on 16/4/1.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFrame.h"

@protocol commentCellDelegate <NSObject>
//对评论进行通过处理
-(void)commentPassed:(CommentFrame *)passedFrame;
//对评论进行垃圾处理
-(void)commentTrashed:(CommentFrame *)trashFrame;
//对评论进行删除处理
-(void)commentDeleted:(CommentFrame *)deleteFrame;

@end

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic,strong)CommentFrame *cmframe;

+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath;
@property (nonatomic,strong)id<commentCellDelegate>delegate;
@property (nonatomic,weak)UIView *lineView;

@end
