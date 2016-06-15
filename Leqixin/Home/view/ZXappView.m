//
//  ZXappView.m
//  shishenghuo
//
//  Created by 震霄 张 on 15/11/25.
//  Copyright © 2015年 SDW. All rights reserved.
//

#import "ZXappView.h"

@implementation ZXappView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.userInteractionEnabled = YES;
        [self addSubview:iconView];
        self.iconView = iconView;
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:12];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(appViewSingleTap:)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
      //  singleTapGestureRecognizer.delegate = self;
        [self addGestureRecognizer:singleTapGestureRecognizer];

    }
    return self;
}
-(void)appViewSingleTap:(UIGestureRecognizer*)gestureRecognizer
{
    ZXappView *appView =  (ZXappView *)gestureRecognizer.self.view;
    NSInteger tag = appView.tag;
    if ([self.delegate respondsToSelector:@selector(getTouchViewTag:)]) {
        [self.delegate getTouchViewTag:tag];
    }
    
}
-(void)layoutSubviews
{
    self.iconView.x = 0;
    self.iconView.y = 0;
    self.iconView.width = self.width;
    self.iconView.height = self.width;
    self.nameLabel.x = 0;
    self.nameLabel.y = CGRectGetMaxY(self.iconView.frame)+10;
    self.nameLabel.width = self.width;
    self.nameLabel.height = self.height-self.iconView.height-10;
}
-(void)setAppModel:(ZXappModel *)appModel
{
    _appModel = appModel;
#warning image获取后期要改
    self.iconView.image = [UIImage imageNamed:appModel.iconUrl];
    self.nameLabel.text = appModel.name;
}
@end
