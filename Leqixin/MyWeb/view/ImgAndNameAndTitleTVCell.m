//
//  ImgAndNameAndTitleTVCell.m
//  乐企信
//
//  Created by Raija on 16/5/27.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "ImgAndNameAndTitleTVCell.h"

@interface ImgAndNameAndTitleTVCell () {
    
    UIImageView *iconImgView,*lineImgView,*rightImgView;
    UILabel *nameLabel;
    UILabel *detailLabel;
}

@end

@implementation ImgAndNameAndTitleTVCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self == nil) {
        
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
//    self.contentView.backgroundColor = [UIColor redColor];
    if (iconImgView && nameLabel && detailLabel && rightImgView && lineImgView) {
        
        [iconImgView removeFromSuperview];
        [nameLabel removeFromSuperview];
        [detailLabel removeFromSuperview];
        [rightImgView removeFromSuperview];
        [lineImgView removeFromSuperview];
        //        return;
    }
    
    CGFloat space_Left = 12 * SCREEN_SCALE_W;
    CGFloat space_right = 15 *SCREEN_SCALE_W;
    CGFloat width_Cell = CGRectGetWidth(self.contentView.frame);
    CGFloat height_cell = CGRectGetHeight(self.contentView.frame);
    //
    iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(space_Left, 0, 17, 17)];
    iconImgView.centerY = height_cell / 2;
    iconImgView.image = [UIImage imageNamed:self.iconString];
//    iconImgView.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:iconImgView];
    //
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImgView.frame) + space_Left + 2, 0, 80, 20)];
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    nameLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    nameLabel.centerY = iconImgView.centerY;
    nameLabel.text = self.nameString;
//    nameLabel.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:nameLabel];
    //
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), 0, width_Cell - CGRectGetMaxX(nameLabel.frame) - space_right, 20)];
    detailLabel.font = [UIFont systemFontOfSize:14.0];
    detailLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    detailLabel.centerY = iconImgView.centerY;
    detailLabel.adjustsFontSizeToFitWidth = YES;
    detailLabel.text = self.detailString;
    [self.contentView addSubview:detailLabel];
    //
    if ( !self.isNotShowRightImg) {
        rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(width_Cell - space_right - 12, 0, 12, 12)];
        rightImgView.centerY = iconImgView.centerY;
        rightImgView.image = [UIImage imageNamed:@"web_jiantou"];
        [self.contentView addSubview:rightImgView];
        //
        lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height_cell, width_Cell, 1)];
        lineImgView.image = [UIImage imageNamed:@"web_huixian"];
        [self.contentView addSubview:lineImgView];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
