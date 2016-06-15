//
//  RecordTableViewCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/25.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "RecordTableViewCell.h"

#define recordCellHeight 40

@implementation RecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //界面加载
        [self setRecordInfoView];
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"recordCell";
     RecordTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    return cell;
    
}
-(void)setRecordInfoView
{
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.x = 56 *SCREEN_SCALE_W;
    timeLabel.width = 150 * SCREEN_SCALE_W;
    timeLabel.height = 30* SCREEN_SCALE_H;
    timeLabel.y = (recordCellHeight - timeLabel.height)/2;
    timeLabel.font = [UIFont systemFontOfSize:16];
    timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    UILabel *statusLabel = [[UILabel alloc]init];
    statusLabel.width = 100*SCREEN_SCALE_W;
    statusLabel.height = 30 *SCREEN_SCALE_H;
    statusLabel.x = SCREEN_W - 10 - statusLabel.width;
    statusLabel.y = timeLabel.y;
    [self.contentView  addSubview:statusLabel];
    statusLabel.font = [UIFont systemFontOfSize:16];
    statusLabel.textColor = [UIColor grayColor];
    self.statusLabel = statusLabel;
}
@end
