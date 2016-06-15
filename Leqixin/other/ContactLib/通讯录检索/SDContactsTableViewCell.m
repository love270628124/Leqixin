//
//  SDContactsTableViewCell.m
//
//  Created by 侯伟玉 on 16/3/10.
//  Copyright © 2016年 侯伟玉. All rights reserved.
//
//----------------------------------QQ:846286641-------------------------------------------
//**********************************备注姓名***********************************************
//模拟器无法实现拨号，建议真机调试（号码我随便写的，记得改一下）
//
//没事写的一个类似手机通讯录的Demo，代码没整理，有点乱，不喜勿喷
//欢迎加QQ：846286641 交流
//
//
//
//

#import "SDContactsTableViewCell.h"
#import "UIView+SDAutoLayout.h"
#import "SDContactModel.h"
#import "ContactModel.h"
#import "UIImageView+WebCache.h"


@implementation SDContactsTableViewCell
{
    UIImageView *_iconImageView;
    UILabel *_nameLabel;
    UILabel *_phoneLab;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 这行代是为了解决tableview开启了字母序列索引之后cell会向左缩进一段距离的问题
        self.contentView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        [self setupView];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width = self.bounds.size.width;
    [super setFrame:frame];
}

- (void)setupView
{
    _iconImageView = [UIImageView new];
    _iconImageView.clipsToBounds = YES;
    _iconImageView.layer.cornerRadius = 5.0f;
    _iconImageView.contentMode = UIViewContentModeScaleToFill;
    [self.contentView addSubview:_iconImageView];
    
    _nameLabel = [UILabel new];
    _nameLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    //_nameLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_nameLabel];
    
    _phoneLab = [UILabel new];
    _phoneLab.textColor = [UIColor darkGrayColor];
    _phoneLab.font = [UIFont systemFontOfSize:13];
    //_phoneLab.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_phoneLab];
    
    
    _iconImageView.sd_layout
    .leftSpaceToView(self.contentView, 14)
    .widthIs(44)
    .heightEqualToWidth()
    .centerYEqualToView(self.contentView);
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconImageView, 15)
    .topEqualToView(_iconImageView)
    .rightSpaceToView(self.contentView,14)
    .heightIs(20);
    
    _phoneLab.sd_layout
    .leftSpaceToView(_iconImageView, 15)
//    .topSpaceToView(_nameLabel,9)
    .bottomEqualToView(_iconImageView)
    .rightSpaceToView(self.contentView,14)
    .heightIs(20);
    
//    _iconImageView.layer.masksToBounds = YES;
//    _iconImageView.layer.cornerRadius = _iconImageView.width * 0.5;
//    _iconImageView.layer.borderWidth = 1.0;
//    _iconImageView.layer.borderColor = [UIColor grayColor].CGColor;

}

- (void)setModel:(ContactModel *)model
{
    _model = model;
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@",rootUrl,model.img];
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_moren-tx"]];
    _phoneLab.text = model.position;
}

+ (CGFloat)fixedHeight
{
    return 60;
}

@end
