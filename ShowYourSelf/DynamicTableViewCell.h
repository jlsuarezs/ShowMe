//
//  DynamicTableViewCell.h
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"
#define DEFAYLT_HEIGHT 75

#define PICTURE_WIDTH (kSCREEN_WIDTH-70)/3.0

@interface DynamicTableViewCell : UITableViewCell <XHImageViewerDelegate>

@property (nonatomic,strong)UILabel *contetLabel;
@property (nonatomic,strong)UILabel *userNameLabel;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UIView *imagesView;

@property (nonatomic,strong)DynamicModel *model;

@end
