//
//  UserCenterTopView.h
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCenterTopModel.h"

@interface UserCenterTopView : UIView

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *userNameLabel;
@property (nonatomic,strong)UserCenterTopModel *model;
@end
