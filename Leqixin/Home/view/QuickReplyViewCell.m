//
//  QuickReplyViewCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/24.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "QuickReplyViewCell.h"

@interface QuickReplyViewCell()
@property (nonatomic,weak)UILabel *infoLabel;
@end

@implementation QuickReplyViewCell

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
        [self setQuickReplyView];
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"replyCell";
    
    QuickReplyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    return cell;
    
}
-(void)setQuickReplyView
{
    UILabel *label = [[UILabel alloc]init];
    label.frame = self.bounds;
    label.width = SCREEN_W;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:label];
    self.infoLabel = label;
}
-(void)setShowInfo:(NSString *)showInfo
{
    _showInfo = showInfo;

    self.infoLabel.textColor = [UIColor blackColor];

    self.infoLabel.text = showInfo;

}
@end
