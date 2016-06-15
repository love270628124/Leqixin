//
//  ZXappView.h
//  shishenghuo
//
//  Created by 震霄 张 on 15/11/25.
//  Copyright © 2015年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXappModel.h"

@protocol ZXappViewDelegate <NSObject>
@optional

-(void)getTouchViewTag:(NSInteger)tag;
@end
@interface ZXappView : UIView

@property (nonatomic,assign)UIImageView *iconView;
@property (nonatomic,assign)UILabel *nameLabel;

@property (nonatomic,strong)ZXappModel *appModel;

@property (nonatomic,weak)id<ZXappViewDelegate>delegate;
@end
