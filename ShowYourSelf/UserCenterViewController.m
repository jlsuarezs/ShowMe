//
//  UserCenterViewController.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "UserCenterViewController.h"
#import "UserCenterTopView.h"
#import "UserCenterTopModel.h"
@interface UserCenterViewController (){
    UserCenterTopView *_topView;
    UIScrollView *_scrollView;
    UserCenterTopModel *_model;
}

@end

@implementation UserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getUserInfo];
    [self createUI];
}

- (void)getUserInfo {
    BmobUser *userInfo = [BmobUser getCurrentUser];
    _model = [[UserCenterTopModel alloc] init];
    _model.userName = [userInfo objectForKey:@"username"];
    _model.iconUrl = [userInfo objectForKey:@"usericon"];
}

- (void)createUI {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _topView = [[UserCenterTopView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH+20)];
    _topView.model = _model;
    [_scrollView addSubview:_topView];
    
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake(100, kSCREEN_HEIGHT - 50, kSCREEN_WIDTH-200, 30);
    [logoutButton setTitle:@"登出" forState:UIControlStateNormal];
    [logoutButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    VIEW_BORDERCOLOR(logoutButton, WHITECOLOR);
    VIEW_BORDERWIDTH(logoutButton, 0.5);
    VIEW_CLIPS(logoutButton);
    VIEW_CORNERRADIUS(logoutButton, 3);
    [logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    logoutButton.backgroundColor = COLORWITHRGB(127, 247, 247,1);
    [_scrollView addSubview:logoutButton];
    
    _scrollView.contentSize = CGSizeMake(0, logoutButton.bottom + 10);
}


#pragma mark buttonClick 
- (void)logoutButtonClicked:(UIButton *)sender {
    VIEW_ADD_ANIMATION(sender);
    [BmobUser logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
