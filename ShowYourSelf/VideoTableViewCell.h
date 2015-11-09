//
//  VideoTableViewCell.h
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

#import "VideoPlayView.h"
@interface VideoTableViewCell : UITableViewCell

@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UILabel *userNameLabel;

@property (nonatomic,strong)UILabel *contentLabel;

@property (nonatomic,strong)VideoModel *model;

@property (nonatomic,strong)VideoPlayView *playView;

@property (nonatomic,strong)UIImageView *thumbilImageView;

@property (nonatomic,strong)SDPieLoopProgressView *progressView;

@end
