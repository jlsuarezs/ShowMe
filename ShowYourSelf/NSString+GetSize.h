//
//  NSString+GetSize.h
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GetSize)

+ (CGSize)getStringSizeWithString:(NSString *)str withStringFont:(UIFont *)font withStringMaxSize:(CGSize)maxSize;

@end
