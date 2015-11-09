//
//  main.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/6.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *appKey = @"34729b1649ed008ca3ac793ad16661db";
        [Bmob registerWithAppKey:appKey];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
