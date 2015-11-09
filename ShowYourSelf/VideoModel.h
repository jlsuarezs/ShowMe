//
//  VideoModel.h
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic,strong)NSString *iconUrl;

@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)NSString *videoUrl;

@property (nonatomic,strong)NSString *content;

@property (nonatomic,strong)NSDate *createDate;

@property (nonatomic,strong)NSString *thumbilUrl;

@end
