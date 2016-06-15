//
//  ImgAndNameAndTitleTVCell.h
//  乐企信
//
//  Created by Raija on 16/5/27.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgAndNameAndTitleTVCell : UITableViewCell

@property (nonatomic, assign) BOOL isNotShowRightImg;

@property (nonatomic, strong) NSString *iconString;
@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) NSString *detailString;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
