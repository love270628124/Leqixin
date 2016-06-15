//
//  MineInfoViewController.h
//  乐企信
//
//  Created by 震霄 张 on 16/3/30.
//  Copyright © 2016年 SDW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol changeIconImageDelegate <NSObject>

@optional
-(void)changeIconImage;

@end
@interface MineInfoViewController : UIViewController
@property (nonatomic,weak)id<changeIconImageDelegate>delegate;
@end
