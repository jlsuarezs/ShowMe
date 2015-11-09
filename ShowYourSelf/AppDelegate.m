//
//  AppDelegate.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/6.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "UserCenterViewController.h"
#import "DynamicViewController.h"
#import "VideoViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    BmobUser *currentUser = [BmobUser getCurrentUser];
    if (currentUser) {
        [self hadLogin];
    }else{
        [self notLogin];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"login" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:@"logout" object:nil];

    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginSuccess {
    [self hadLogin];
}

- (void)logOut {
    [self notLogin];
}

- (void)notLogin{
    LoginViewController *loginCtl = [[LoginViewController alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:loginCtl];
    
    self.window.rootViewController = navc;
}

- (void)hadLogin {
    DynamicViewController *dynamicCtl = [[DynamicViewController alloc]init];
    VideoViewController *videoCtl = [[VideoViewController alloc]init];
    UserCenterViewController *userCenterCtl = [[UserCenterViewController alloc]init];
    NSMutableArray *controllers = [NSMutableArray arrayWithObjects:dynamicCtl,videoCtl,userCenterCtl, nil];
    NSArray *titles = @[@"动态",@"视频",@"个人"];
    NSMutableArray *array = [NSMutableArray array];
    int i = 0;
    for (UIViewController *controller in controllers) {
        UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:controller];
        controller.title = titles[i];
        [array addObject:navc];
        i ++;
    }
    
    UITabBarController *tabbarCtl = [[UITabBarController alloc] init];
    tabbarCtl.viewControllers = array;
    self.window.rootViewController = tabbarCtl;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
