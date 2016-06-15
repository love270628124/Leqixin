//
//  ContactTableViewCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/6/1.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ContactTableViewCell.h"

@interface ContactTableViewCell()
@property (nonatomic,weak)UILabel *showLabel;
@property (nonatomic,weak)UILabel *dataLabel;
@end

@implementation ContactTableViewCell

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
        [self setContactView];
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"showContactCell";
    ContactTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)setContactView
{
    UILabel *showLabel = [[UILabel alloc]init];
    showLabel.frame = CGRectMake(20*SCREEN_SCALE_W, 5*SCREEN_SCALE_H, 80*SCREEN_SCALE_W, 40*SCREEN_SCALE_H);
//    showLabel.backgroundColor = [UIColor redColor];
    showLabel.adjustsFontSizeToFitWidth = YES;
    self.showLabel =  showLabel;
    [self.contentView addSubview:showLabel];
    
    UILabel *dataLabel = [[UILabel alloc]init];
    dataLabel.frame = CGRectMake(CGRectGetMaxX(showLabel.frame), showLabel.y, SCREEN_W - 40*SCREEN_SCALE_W - showLabel.width, showLabel.height);
    dataLabel.adjustsFontSizeToFitWidth = YES;
    self.dataLabel = dataLabel;
    [self.contentView addSubview:dataLabel];
    
}


-(void)setModel:(ShowContactModel *)model
{
    _model = model;
    self.showLabel.text = model.showStr;
    if ([model.showStr isEqualToString:@"联系热线："]) {
        self.dataLabel.attributedText = [self changeTextColor:model.dataStr];
    }else{
        self.dataLabel.text = model.dataStr;
    }
}
-(NSMutableAttributedString *)changeTextColor:(NSString *)str
{
    NSMutableAttributedString *tempstr = [[NSMutableAttributedString alloc]initWithString:str];
    //设置：在0-3个单位长度内的内容显示成红色
    [tempstr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, 13)];
    return tempstr;
}

@end
