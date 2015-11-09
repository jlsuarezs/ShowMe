//
//  NSString+GetSize.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "NSString+GetSize.h"

@implementation NSString (GetSize)

+ (CGSize)getStringSizeWithString:(NSString *)str withStringFont:(UIFont *)font withStringMaxSize:(CGSize)maxSize {
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    return size;
}



@end
