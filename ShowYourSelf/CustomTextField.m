//
//  CustomTextField.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CREATE_BOTTOM_LINEVIEW(frame, self,WHITECOLOR);
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/5, frame.size.height)];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textAlignment = NSTextAlignmentRight;
        _label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addSubview:_label];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(_label.right + 5, 0, self.width-_label.right + 5, self.height)];
        _textField.textColor = WHITECOLOR;
        _textField.tintColor = WHITECOLOR;
        [self addSubview:_textField];
    }
    return self;
}
@end
