//
//  MineCollectionViewCell.m
//  CollectionviewSort
//
//  Created by wangwenke on 16/4/12.
//  Copyright © 2016年 wangwenke. All rights reserved.
//

#import "MineCollectionViewCell.h"

@implementation MineCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        UIImage *image = [UIImage imageNamed:@"home_fangkezixun"];
        _cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(width*0.5 - image.size.width*0.5*1.2, height*7/23, 22*SCREEN_SCALE_W, 22*SCREEN_SCALE_W)];
        [self.contentView addSubview:_cellImage];
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cellImage.frame)+11*SCREEN_SCALE_H, width, 30*SCREEN_SCALE_H)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        
//        _nameLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_nameLabel];
        _circleImage = [[UIImageView alloc]init];
        _circleImage.width = 8;
        _circleImage.height = 8;
        _circleImage.y = 10;
        _circleImage.x = width-_circleImage.width-10;
//        _circleImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_nameLabel.frame)+6*SCREEN_SCALE_W, _nameLabel.centerY-5*SCREEN_SCALE_H,8*SCREEN_SCALE_H,8*SCREEN_SCALE_H)];
        _circleImage.image = [UIImage imageNamed:@"home_btn_tishi"];
        [self.contentView addSubview:_circleImage];
        _circleImage.layer.cornerRadius = 8*SCREEN_SCALE_H * 0.5;
        _circleImage.layer.masksToBounds = YES;
        _circleImage.hidden = YES;
    }
    return self;
}


@end
