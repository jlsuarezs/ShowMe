//
//  PublicNewVideoViewController.h
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoModel.h"

typedef void(^PublicNewVideoBlock) (VideoModel* model);
@interface PublicNewVideoViewController : BaseViewController
@property (nonatomic,strong)PublicNewVideoBlock block;

@end
