//
//  shareDataFrame.m
//  乐企信
//
//  Created by 震霄 张 on 16/3/31.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "shareDataFrame.h"

@implementation shareDataFrame

-(void)setModel:(shareDataModel *)model
{
    _model = model;
    
    //计算frame
    CGFloat maxW = SCREEN_W - 20 * SCREEN_SCALE_W - 10 *SCREEN_SCALE_W;

    
    CGFloat titleLabelX = 10 * SCREEN_SCALE_W;
    CGFloat titleLabelY = 10 * SCREEN_SCALE_H;
    CGSize titleLabelSize = [model.title sizeWithFont:[UIFont systemFontOfSize:16] maxW:maxW];
    self.titleFrame = CGRectMake(titleLabelX, titleLabelY, titleLabelSize.width, titleLabelSize.height);
    
    CGFloat contentX = titleLabelX;
    CGFloat contentY = CGRectGetMaxY(self.titleFrame)+10 * SCREEN_SCALE_H;
    CGSize contentSize = [model.content sizeWithFont:[UIFont systemFontOfSize:14] maxW:maxW];
    self.contentFrame = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    CGFloat shareIconX = titleLabelX;
    CGFloat shareIconY = CGRectGetMaxY(self.contentFrame)+14 * SCREEN_SCALE_H;
    UIImage *shareImage = [UIImage imageNamed:@"icon_xiaolian"];
    self.shareIconFrame = CGRectMake(shareIconX, shareIconY, shareImage.size.width, shareImage.size.height);
    
    CGFloat shareLabelX = CGRectGetMaxX(self.shareIconFrame)+10 * SCREEN_SCALE_W;
    CGFloat shareLabelY = shareIconY;
    CGFloat shareLabelWidth = 40 * SCREEN_SCALE_W;
    CGFloat sharelabelHeight = self.shareIconFrame.size.height;
    self.shareLabelFrame = CGRectMake(shareLabelX, shareLabelY, shareLabelWidth, sharelabelHeight);
    
    UIImage *btnImage = [UIImage imageNamed:@"icon_share"];
    CGFloat btnX = maxW - btnImage.size.width - 10 * SCREEN_SCALE_W;
    CGFloat btnY = shareIconY-10*SCREEN_SCALE_H;
    CGFloat btnW = btnImage.size.width*1.2;
    CGFloat btnH = btnImage.size.height*1.2;
    self.shareBtnFrame = CGRectMake(btnX, btnY, btnW, btnH);
    
    CGFloat lineX = 0;
    CGFloat lineY = CGRectGetMaxY(self.shareIconFrame)+10*SCREEN_SCALE_H;
    CGFloat lineW = SCREEN_W;
    CGFloat lineH =  10*SCREEN_SCALE_H;
    self.lineViewFrame = CGRectMake(lineX, lineY, lineW, lineH);
    
    self.cellHeight = CGRectGetMaxY(self.lineViewFrame);
    
}

@end
