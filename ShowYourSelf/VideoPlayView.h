//
//  VideoPlayView.h
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayView : UIView


- (id)initWithFrame:(CGRect)frame andUrl:(NSString *)url fromNet:(BOOL)flag;
@property (nonatomic,strong) AVPlayer *player;

@property (nonatomic,strong) UIProgressView *progress;

@property (nonatomic,strong) NSString *url;

@end
