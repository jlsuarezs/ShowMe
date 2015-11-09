//
//  LoginViewController.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "LoginViewController.h"
#import "CustomTextField.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>{
    UIView *inputView;
    UIImageView *icon;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登陆/注册";
    [self createUI];
}

- (void)createUI {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    imageView.image = SET_IMAGE(@"login", PNG);
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
    
    icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH/4, kSCREEN_WIDTH/4)];
    icon.center = self.view.center;
    icon.image = SET_IMAGE(@"icon", PNG);
    [self.view addSubview:icon];
    
    inputView = [[UIView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT-200, kSCREEN_WIDTH, 70)];
    [self.view addSubview:inputView];
    
    NSArray *titles = @[@"账号：",@"密码："];
    NSArray *pleaceHolders = @[@"请输入账号",@"请输入密码"];
    for (int i = 0; i < 2; i ++) {
        CustomTextField *textField = [[CustomTextField alloc] initWithFrame:CGRectMake(20,i * 40, kSCREEN_WIDTH - 40, 30)];
        textField.label.text = titles[i];
        textField.tag = i + 1;
        textField.textField.placeholder = pleaceHolders[i];
        if (i == 0) {
            textField.textField.returnKeyType = UIReturnKeyNext;
        }else {
            textField.textField.returnKeyType = UIReturnKeyDone;
            textField.textField.secureTextEntry = YES;
        }
        textField.textField.delegate = self;
        [inputView addSubview:textField];
    }
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(100, inputView.bottom + 30, kSCREEN_WIDTH - 200, 30);
    [loginButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    [loginButton setTitle:@"登入" forState:UIControlStateNormal];
    loginButton.backgroundColor = COLORWITHRGB(127, 247, 247,1);
    VIEW_BORDERCOLOR(loginButton, WHITECOLOR);
    VIEW_BORDERWIDTH(loginButton, 0.5);
    VIEW_CLIPS(loginButton);
    VIEW_CORNERRADIUS(loginButton, 3);
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, loginButton.bottom + 10, kSCREEN_WIDTH - 200, 10)];
    registerLabel.font = [UIFont systemFontOfSize:10];
    registerLabel.text = @"若您还没有账号，";
    registerLabel.textColor = WHITECOLOR;
    registerLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:registerLabel];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"请点击此处注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:COLORWITHRGB(246, 201, 225, 1) forState:UIControlStateNormal];
    registerButton.titleLabel.font = [UIFont systemFontOfSize:10];
    registerButton.frame = CGRectMake(registerLabel.right, registerLabel.y, 100, 10);
    CREATE_BOTTOM_LINEVIEW(registerButton.frame, registerButton, COLORWITHRGB(246, 201, 225, 1));
    [registerButton addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registerButton];
    
    
    [self addNotifition];
}

- (void)viewWillAppear:(BOOL)animated {
    __block UIImageView *bCion = icon;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        bCion.y = 100;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)addNotifition {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Notifition
- (void)keyBoardShow:(NSNotification *)note {
    CGRect mRect = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat y = mRect.origin.y;
    CGFloat height = mRect.size.height;
    if (height > kSCREEN_HEIGHT - inputView.bottom) {
        [UIView animateWithDuration:0.25f animations:^{
            inputView.y = y-70;
        }];
    }

}

- (void)keyBoardHide:(NSNotification *)note {
        [UIView animateWithDuration:0.25f animations:^{
            inputView.y =  kSCREEN_HEIGHT - 200;
        }];

}

#pragma mark textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    CustomTextField *text1 = (CustomTextField *)[inputView viewWithTag:1];
    CustomTextField *text = (CustomTextField *)[inputView viewWithTag:2];
    if (textField == text1.textField) {
        [text.textField becomeFirstResponder];
    }else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark buttonClicked

- (void)loginButtonClicked:(UIButton *)sender {
    VIEW_ADD_ANIMATION(sender);
    CustomTextField *text1 = (CustomTextField *)[inputView viewWithTag:1];
    CustomTextField *text = (CustomTextField *)[inputView viewWithTag:2];
    [BmobUser loginInbackgroundWithAccount:text1.textField.text andPassword:text.textField.text block:^(BmobUser *user, NSError *error) {
        if (error) {
            
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
        }
    }];
}

- (void)gotoRegister {
    RegisterViewController *ctl = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark GestureRecognizer

- (void)imageViewTap {
    CustomTextField *text1 = (CustomTextField *)[inputView viewWithTag:1];
    CustomTextField *text = (CustomTextField *)[inputView viewWithTag:2];
    [text resignFirstResponder];
    [text1 resignFirstResponder];
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
