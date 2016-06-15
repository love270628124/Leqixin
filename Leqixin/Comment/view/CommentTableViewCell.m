//
//  CommentTableViewCell.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/1.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "CommentModel.h"
#import "CommentFrame.h"
@interface CommentTableViewCell()

@property (nonatomic,weak)UIImageView *iconView;
@property (nonatomic,weak)UILabel *nameLabel;
//@property (nonatomic,weak)UILabel *locationLabel;
@property (nonatomic,weak)UILabel *statusLabel;
@property (nonatomic,weak)UIImageView *statusView;
@property (nonatomic,weak)UILabel *commentLabel;
//@property (nonatomic,weak)UILabel *bodyLabel;
@property (nonatomic,weak)UILabel *timeLabel;
@property (nonatomic,weak)UIButton *passBtn;
@property (nonatomic,weak)UIButton *trashBtn;
@property (nonatomic,weak)UIButton *deleteBtn;


@end

@implementation CommentTableViewCell

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
        [self setCommentCellView];
        
    }
    return self;
}
+(id)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"commentCell";
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity forIndexPath:indexPath];
    
    return cell;
    
}
-(void)setCommentCellView
{
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_moren-tx"]];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    UILabel *nameLabel = [[UILabel alloc]init];
  //  nameLabel.backgroundColor = [UIColor redColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
//    UILabel *locationLabel = [[UILabel alloc]init];
//  //  locationLabel.backgroundColor = [UIColor greenColor];
//    locationLabel.font = [UIFont systemFontOfSize:14];
//    locationLabel.textColor = ZXcolor(153, 153, 153);
//    [self.contentView addSubview:locationLabel];
//    self.locationLabel = locationLabel;
    
//    UILabel *statusLabel = [[UILabel alloc]init];
//   // statusLabel.backgroundColor = [UIColor orangeColor];
//    statusLabel.font = [UIFont systemFontOfSize:15];
//    statusLabel.textColor = ZXcolor(10, 212, 134);
//    [self.contentView addSubview:statusLabel];
//    self.statusLabel = statusLabel;
    UIImageView *statusView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_daifankui"]];
    self.statusView = statusView;
    [self.contentView addSubview:statusView];
    
    
    UILabel *commentLabel = [[UILabel alloc]init];
  //  commentLabel.backgroundColor = [UIColor blueColor];
    commentLabel.numberOfLines = 0;
    commentLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:commentLabel];
    self.commentLabel = commentLabel;
    
//    UILabel *bodyLabel = [[UILabel alloc]init];
//    bodyLabel.backgroundColor = ZXcolor(236, 236, 236);
//    bodyLabel.font = [UIFont systemFontOfSize:14];
//    [self.contentView addSubview:bodyLabel];
//    self.bodyLabel = bodyLabel;
    
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.font = [UIFont systemFontOfSize:12];
    timeLabel.textColor = ZXcolor(153, 153, 153);
    [self.contentView addSubview:timeLabel];
    timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel = timeLabel;
    
    UIButton *passBtn = [[UIButton alloc]init];
    [passBtn setBackgroundImage:[UIImage imageNamed:@"btn_anniu_mormal"] forState:UIControlStateNormal];
    [passBtn setBackgroundImage:[UIImage imageNamed:@"btn_anniu_click"] forState:UIControlStateHighlighted];
    [passBtn setTitle:@"通过" forState:UIControlStateNormal];
    UIColor *btnColor = ZXcolor(153, 153, 153);
    [passBtn setTitleColor:btnColor forState:UIControlStateNormal];
    passBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:passBtn];
    self.passBtn = passBtn;
    [passBtn addTarget:self action:@selector(passBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *trashBtn = [[UIButton alloc]init];
    [trashBtn setBackgroundImage:[UIImage imageNamed:@"btn_anniu_mormal"] forState:UIControlStateNormal];
    [trashBtn setBackgroundImage:[UIImage imageNamed:@"btn_anniu_click"] forState:UIControlStateHighlighted];
    [trashBtn setTitle:@"垃圾" forState:UIControlStateNormal];
    trashBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [trashBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [self.contentView addSubview:trashBtn];
    self.trashBtn = trashBtn;
    [trashBtn addTarget:self action:@selector(trashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteBtn = [[UIButton alloc]init];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_anniu_mormal"] forState:UIControlStateNormal];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_anniu_click"] forState:UIControlStateHighlighted];

    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [deleteBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [self.contentView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    [deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = ZXcolor(235, 235, 235);
    self.lineView = lineView;
    [self.contentView addSubview:lineView];
}
-(void)deleteBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(commentDeleted:)]) {
        [self.delegate commentDeleted:self.cmframe];
    }
}

-(void)trashBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(commentTrashed:)]) {
        [self.delegate commentTrashed:self.cmframe];
    }
}
-(void)passBtnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(commentPassed:)]) {
        [self.delegate commentPassed:self.cmframe];
    }
}

-(void)setCmframe:(CommentFrame *)cmframe
{
    _cmframe = cmframe;
    //设置frame和数据
    self.iconView.frame = cmframe.iconViewFrame;
    self.nameLabel.frame = cmframe.nameLabelFrame;
    self.nameLabel.text = cmframe.model.customername;
//    self.locationLabel.frame = cmframe.locationLabelFrame;
   // self.locationLabel.text = cmframe.model.locationStr;
//    if ([cmframe.model ischecked]==CommentStatusPassed) {
//        self.statusView.image = [UIImage imageNamed:@"bg_tongguo"];
//    }else if ([cmframe.model status] == CommentStatusTrash){
//        self.statusView.image = [UIImage imageNamed:@"bg_laji"];
//    }else{
        self.statusView.image = [UIImage imageNamed:@"bg_daifankui"];
//    }
    self.statusView.frame = cmframe.statusViewFrame;
    self.commentLabel.frame = cmframe.commentLabelFrame;
    self.commentLabel.text = cmframe.model.content;
//    self.bodyLabel.frame = cmframe.bodyLabelFrame;
//    self.bodyLabel.text = cmframe.model.bodyStr;
    self.timeLabel.frame = cmframe.timeLabelFrame;
    
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:cmframe.model.addtime];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    self.timeLabel.text = [dateFormatter stringFromDate:date];
    self.timeLabel.text = [self transformTime:cmframe.model.addtime];
    self.passBtn.frame = cmframe.passBtnFrame;
    self.trashBtn.frame = cmframe.trashBtnFrame;
    self.deleteBtn.frame = cmframe.deleteBtnFrame;
    
    self.lineView.frame = cmframe.lineViewFrame;
}

-(NSString *)transformTime:(NSInteger)addtime
{
    
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:addtime];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    
    
//    NSDate *createDate = [dateFormatter dateFromString:date];
    //
    //    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    //    return [fmt stringFromDate:createDate];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    NSDateComponents *dateCmps = [calendar components:unit fromDate:createDate];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:now];
    if (nowCmps.year == dateCmps.year) {//今年
        if (nowCmps.day==(dateCmps.day + 1)) {//昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        }else if (nowCmps.day == dateCmps.day){//今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前",(long)cmps.hour];
            }else if(cmps.minute >1){
                return [NSString stringWithFormat:@"%ld分钟前",(long)cmps.minute];
            }else{
                return @"刚刚";
            }
        }else{//今年的其他日子
            fmt.dateFormat =@"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }else{//非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

@end
