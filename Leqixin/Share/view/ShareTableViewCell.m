//
//  ShareTableViewCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/31.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "shareDataModel.h"

@interface ShareTableViewCell()

@property (nonatomic,weak)UILabel *titleLabel;
@property (nonatomic,weak)UILabel *contentLabel;
@property (nonatomic,weak)UIImageView *sharedView;
@property (nonatomic,weak)UILabel *shareStatusLabel;
@property (nonatomic,weak)UIButton *toShareBtn;


@end
@implementation ShareTableViewCell

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
        [self setShareCellView];
        
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"shareCell";
    
    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    
    return cell;
    
}
-(void)setShareCellView
{
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = ZXcolor(102, 102, 102);
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIImage *sharedImage = [UIImage imageNamed:@"icon_xiaolian"];
    UIImageView *sharedView = [[UIImageView alloc]initWithImage:sharedImage];
    [self.contentView addSubview:sharedView];
    self.sharedView = sharedView;
    
    UILabel *shareStatusLabel = [[UILabel alloc]init];
    shareStatusLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:shareStatusLabel];
    shareStatusLabel.text = @"已分享";
    shareStatusLabel.adjustsFontSizeToFitWidth = YES;
    shareStatusLabel.textColor = [UIColor greenColor];
    self.shareStatusLabel = shareStatusLabel;

    
    UIButton *toShareBtn = [[UIButton alloc]init];
    [toShareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView  addSubview:toShareBtn];
    self.toShareBtn = toShareBtn;
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = ZXcolor(235, 235, 235);
    [self.contentView addSubview:lineView];
    self.lineView = lineView;
    
}
-(void)shareBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(createShareView:)]) {
        [self.delegate createShareView:self.shareFrame.model];
    }
    
}
-(void)setShareFrame:(shareDataFrame *)shareFrame
{
    shareDataModel *model = shareFrame.model;
    _shareFrame = shareFrame;
    
    self.titleLabel.frame = shareFrame.titleFrame;
    self.titleLabel.text = model.title;

    self.contentLabel.frame = shareFrame.contentFrame;
    self.contentLabel.text = model.content;
    
    self.sharedView.frame = shareFrame.shareIconFrame;
    if ([model.status isEqualToString:@"1"]) {
        self.sharedView.image = [UIImage imageNamed:@"icon_xiaolian"];
        self.shareStatusLabel.text = @"已分享";
        self.shareStatusLabel.textColor = [UIColor grayColor];
    }else{
        self.sharedView.image = [UIImage imageNamed:@"icon_ku"];
        self.shareStatusLabel.text = @"未分享";
        self.shareStatusLabel.textColor = [UIColor orangeColor];
    }
    
    self.shareStatusLabel.frame = shareFrame.shareLabelFrame;
    
    self.toShareBtn.frame = shareFrame.shareBtnFrame;
    [self.toShareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    self.lineView.frame = shareFrame.lineViewFrame;
}







@end
