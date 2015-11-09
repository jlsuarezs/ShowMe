//
//  PublicNewDynamicViewController.h
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "BaseViewController.h"
#import "DynamicModel.h"
typedef void(^NewDynamicBlock) (DynamicModel *model);

@interface PublicNewDynamicViewController : BaseViewController

@property (nonatomic,strong)NewDynamicBlock block;

@end
