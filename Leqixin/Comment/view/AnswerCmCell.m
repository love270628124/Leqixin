//
//  AnswerCmCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "AnswerCmCell.h"
#import "UsrAnswerFrame.h"
#import "UsrAnswerModel.h"

@interface AnswerCmCell()
@property (nonatomic,weak)UIImageView *iconView;
@property (nonatomic,weak)UILabel *nameLabel;
@property (nonatomic,weak)UILabel *locationLabel;
@property (nonatomic,weak)UILabel *commentLabel;
@property (nonatomic,weak)UILabel *timeLabel;


@end
@implementation AnswerCmCell

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
        [self setCmAnswerCellView];
        
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"answerCmCell";
    
    AnswerCmCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    
    return cell;
    
}
-(void)setCmAnswerCellView
{
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_moren-tx"]];
    self.iconView = iconView;
    [self.contentView addSubview:iconView];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *locationLabel = [[UILabel alloc]init];
    locationLabel.font = [UIFont systemFontOfSize:14];
    locationLabel.textColor = ZXcolor(153, 153, 153);
    [self.contentView addSubview:locationLabel];
    self.locationLabel = locationLabel;
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = ZXcolor(153, 153, 153);
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;

    UILabel *commentLabel = [[UILabel alloc]init];
    commentLabel.numberOfLines = 0;
    commentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:commentLabel];
    self.commentLabel = commentLabel;

}
-(void)setAnsFrame:(UsrAnswerFrame *)ansFrame
{
    _ansFrame = ansFrame;
    self.iconView.frame = ansFrame.iconViewFrame;
    self.nameLabel.frame = ansFrame.nameLabelFrame;
    self.nameLabel.text = ansFrame.model.nameStr;
    self.locationLabel.frame = ansFrame.locationLabelFrame;
    self.locationLabel.text = ansFrame.model.locationStr;
    self.timeLabel.frame =  ansFrame.timeLabelFrame;
    self.timeLabel.text = ansFrame.model.timeStr;
    self.commentLabel.frame = ansFrame.commentLabelFrame;
    self.commentLabel.text = ansFrame.model.commentStr;

}
@end
