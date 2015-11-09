//
//  DynamicModel.h
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicModel : NSObject

@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *userIcon;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSDate *createDate;

@end
