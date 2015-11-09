//
//  UITextView+PlaceHolder.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "UITextView+PlaceHolder.h"

@implementation UITextView (PlaceHolder)

@dynamic placeHolder;

- (void)setPlaceHolder:(NSString *)placeHolder {
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.width-10, 14)];
    placeHolderLabel.text = placeHolder;
    placeHolderLabel.textColor = LIGHTGRAYCOLOR;
    placeHolderLabel.tag = 1;
    placeHolderLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:placeHolderLabel];
    self.scrollEnabled = NO;
    self.scrollsToTop = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valueChange) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)valueChange {
    UILabel *label = (UILabel *)[self viewWithTag:1];
    if (self.text.length > 0) {
        label.hidden = YES;
    }else {
        label.hidden = NO;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
