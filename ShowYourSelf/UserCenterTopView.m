//
//  UserCenterTopView.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "UserCenterTopView.h"

@implementation UserCenterTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, self.height-20)];
        _backImageView.backgroundColor = BLACKCOLOR;
        [self addSubview:_backImageView];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH - 60, self.height-50, 50, 50)];
        VIEW_BORDERCOLOR(_iconImageView, LIGHTGRAYCOLOR);
        VIEW_BORDERWIDTH(_iconImageView, 0.5);
        VIEW_CLIPS(_iconImageView);
        VIEW_CORNERRADIUS(_iconImageView, 25);
        [self addSubview:_iconImageView];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _backImageView.bottom-20, kSCREEN_WIDTH-_iconImageView.width-20, 15)];
        _userNameLabel.textColor = WHITECOLOR;
        _userNameLabel.textAlignment = NSTextAlignmentRight;
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_userNameLabel];
    }
    return self;
}

- (void)setModel:(UserCenterTopModel *)model {
    _userNameLabel.text = model.userName;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL_STR(model.iconUrl)] placeholderImage:SET_IMAGE(@"icon", PNG)];
}

@end
