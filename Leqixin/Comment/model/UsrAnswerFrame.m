//
//  UsrAnswerFrame.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/5.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "UsrAnswerFrame.h"
#import "UsrAnswerModel.h"
@implementation UsrAnswerFrame

-(void)setModel:(UsrAnswerModel *)model
{
    _model = model;
    //计算frame
    CGFloat iconX = 13 * SCREEN_SCALE_W;
    CGFloat iconY = 18 * SCREEN_SCALE_H;
    CGFloat iconW = 40 * SCREEN_SCALE_W;
    CGFloat iconH = iconW;
    self.iconViewFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat nameX = CGRectGetMaxX(self.iconViewFrame)+14*SCREEN_SCALE_W;
    CGFloat nameY = iconY;
    CGFloat nameW = [model.nameStr sizeWithFont:[UIFont systemFontOfSize:16]].width;
    CGFloat nameH = [model.nameStr sizeWithFont:[UIFont systemFontOfSize:16]].height;
    self.nameLabelFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat locationX = nameX;
    CGFloat locationY = CGRectGetMaxY(self.nameLabelFrame)+9*SCREEN_SCALE_H;
    CGFloat locationW = [model.locationStr sizeWithFont:[UIFont systemFontOfSize:14]].width;
    CGFloat locationH = [model.locationStr sizeWithFont:[UIFont systemFontOfSize:14]].height;
    self.locationLabelFrame = CGRectMake(locationX, locationY, locationW, locationH);
    
    CGFloat timeY = 19 * SCREEN_SCALE_H;
    CGFloat timeW = 80 * SCREEN_SCALE_W;
    CGFloat timeH = 40 * SCREEN_SCALE_H;
    CGFloat timeX = SCREEN_W - timeW - 13 * SCREEN_SCALE_W;
    self.timeLabelFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    CGFloat commentX = 13 * SCREEN_SCALE_W;
    CGFloat commentY = CGRectGetMaxY(self.iconViewFrame)+16* SCREEN_SCALE_H;
    CGFloat commentW = SCREEN_W - 26 * SCREEN_SCALE_W;
    CGFloat commentH = [model.commentStr sizeWithFont:[UIFont systemFontOfSize:15] maxW:commentW].height;
    self.commentLabelFrame = CGRectMake(commentX, commentY, commentW, commentH);

    self.ansCellHeight = CGRectGetMaxY(self.commentLabelFrame)+21*SCREEN_SCALE_H;

}

@end
