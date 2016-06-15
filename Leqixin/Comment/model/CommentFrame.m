//
//  CommentFrame.m
//  乐企信
//
//  Created by 震霄 张 on 16/4/1.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import "CommentFrame.h"

@implementation CommentFrame

-(void)setModel:(CommentModel *)model
{
    _model = model;
    
    //计算frame
    CGFloat iconX = 13 * SCREEN_SCALE_W;
    CGFloat iconY = 18 * SCREEN_SCALE_H;
    CGFloat iconW = 60 * SCREEN_SCALE_W;
    CGFloat iconH = iconW;
    self.iconViewFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    CGFloat nameX = CGRectGetMaxX(self.iconViewFrame)+14*SCREEN_SCALE_W;
    CGFloat nameY = iconY;
    CGFloat nameW = [model.customername sizeWithFont:[UIFont systemFontOfSize:16]].width;
    CGFloat nameH = [model.customername sizeWithFont:[UIFont systemFontOfSize:16]].height;
    self.nameLabelFrame = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelFrame);
    CGFloat timeH = iconH - nameH;
    CGFloat timeW = 120*SCREEN_SCALE_W;
    self.timeLabelFrame = CGRectMake(timeX, timeY, timeW, timeH);

//    CGFloat locationX = nameX;
//    CGFloat locationY = CGRectGetMaxY(self.nameLabelFrame)+9*SCREEN_SCALE_H;
//    CGFloat locationW = [model.locationStr sizeWithFont:[UIFont systemFontOfSize:14]].width;
//    CGFloat locationH = [model.locationStr sizeWithFont:[UIFont systemFontOfSize:14]].height;
//    self.locationLabelFrame = CGRectMake(locationX, locationY, locationW, locationH);
    
    CGFloat statusW =  100* SCREEN_SCALE_W;
    CGFloat statusH =  60 * SCREEN_SCALE_H;
    CGFloat statusX = SCREEN_W - 13 * SCREEN_SCALE_W - statusW;
    CGFloat statusY = nameY;
    self.statusViewFrame = CGRectMake(statusX, statusY, statusW, statusH);
    
    CGFloat commentX = 13 * SCREEN_SCALE_W;
    CGFloat commentY = CGRectGetMaxY(self.iconViewFrame)+16* SCREEN_SCALE_H;
    CGFloat commentW = SCREEN_W - 26 * SCREEN_SCALE_W;
    CGFloat commentH = [model.content sizeWithFont:[UIFont systemFontOfSize:15] maxW:commentW].height;
    self.commentLabelFrame = CGRectMake(commentX, commentY, commentW, commentH);
    
//    CGFloat bodyX = commentX;
//    CGFloat bodyY = CGRectGetMaxY(self.commentLabelFrame)+14*SCREEN_SCALE_H;
//    CGFloat bodyW = SCREEN_W - 26 * SCREEN_SCALE_W;
//    CGFloat bodyH = 30 *SCREEN_SCALE_H;
//    self.bodyLabelFrame = CGRectMake(bodyX, bodyY, bodyW, bodyH);
    
//    CGFloat timeX = iconX;
//    CGFloat timeY = CGRectGetMaxY(self.commentLabelFrame)+21*SCREEN_SCALE_H;
    
    CGFloat btnW = 50 * SCREEN_SCALE_W;
    CGFloat btnH = 40 * SCREEN_SCALE_H;
    CGFloat btnY = CGRectGetMaxY(self.commentLabelFrame)+10*SCREEN_SCALE_H;
    
    CGFloat deleteX = SCREEN_W - 15 * SCREEN_SCALE_W - btnW;
    self.deleteBtnFrame = CGRectMake(deleteX, btnY, btnW, btnH);
    CGFloat trashX = deleteX - 6 * SCREEN_SCALE_W - btnW;
    self.trashBtnFrame = CGRectMake(trashX, btnY, btnW, btnH);
    CGFloat passX = trashX - 6 * SCREEN_SCALE_W - btnW;
    self.passBtnFrame = CGRectMake(passX, btnY, btnW, btnH);
    

//    CGFloat timeW = passX - timeX-10*SCREEN_SCALE_W;
//    CGFloat timeH = 40 * SCREEN_SCALE_H;
    self.timeLabelFrame = CGRectMake(timeX, timeY, timeW, timeH);
    
    
    CGFloat lineX = 0;
    CGFloat lineY = 0;
    CGFloat lineW = SCREEN_W;
    CGFloat lineH = 10*SCREEN_SCALE_H;
    if ([model.ischecked isEqualToString:@""]) {
        lineY = CGRectGetMaxY(self.commentLabelFrame)+60*SCREEN_SCALE_H;
    }else{
        lineY = CGRectGetMaxY(self.commentLabelFrame)+20*SCREEN_SCALE_H;

    }
    self.lineViewFrame = CGRectMake(lineX, lineY, lineW, lineH);
    
    self.cellHeight = CGRectGetMaxY(self.lineViewFrame);
    
}
@end
