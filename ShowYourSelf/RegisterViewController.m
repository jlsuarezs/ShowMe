//
//  RegisterViewController.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "RegisterViewController.h"
#import "CustomTextField.h"
@interface RegisterViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UIView *inputView;
    UIImageView *icon;
    BOOL isSetIcon;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
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
    UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconTap)];
    icon.userInteractionEnabled = YES;
    [icon addGestureRecognizer:iconTap];
    [self.view addSubview:icon];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, kSCREEN_WIDTH, 10)];
    noteLabel.font = [UIFont systemFontOfSize:10];
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.textColor = WHITECOLOR;
    noteLabel.text = @"请点击下方设置头像";
    [self.view addSubview:noteLabel];
    
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
    [loginButton setTitle:@"注册" forState:UIControlStateNormal];
    loginButton.backgroundColor = COLORWITHRGB(127, 247, 247,1);
    VIEW_BORDERCOLOR(loginButton, WHITECOLOR);
    VIEW_BORDERWIDTH(loginButton, 0.5);
    VIEW_CLIPS(loginButton);
    VIEW_CORNERRADIUS(loginButton, 3);
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    [self addNotifition];

}

- (void)addNotifition {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    __block UIImageView *bCion = icon;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
        bCion.y = 100;
    } completion:^(BOOL finished) {
        
    }];
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

#pragma mark GestureRecognizer

- (void)imageViewTap {
    CustomTextField *text1 = (CustomTextField *)[inputView viewWithTag:1];
    CustomTextField *text = (CustomTextField *)[inputView viewWithTag:2];
    [text resignFirstResponder];
    [text1 resignFirstResponder];
}

- (void)iconTap {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *iconImage = [info objectForKey:UIImagePickerControllerEditedImage];
        icon.image = iconImage;
        isSetIcon = YES;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        
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

#pragma mark buttonClick

- (void)loginButtonClicked:(UIButton *)sender {
    VIEW_ADD_ANIMATION(sender);
    CustomTextField *text1 = (CustomTextField *)[inputView viewWithTag:1];
    CustomTextField *text = (CustomTextField *)[inputView viewWithTag:2];
    if (!isSetIcon || text1.textField.text.length == 0 || text.textField.text.length == 0) {
        return;
    }
    
    NSData *iconData = UIImageJPEGRepresentation(icon.image, 0.5);
    
    
    __weak typeof(self) weakSelf = self;
    [BmobProFile uploadFileWithFilename:@"image.jpg" fileData:iconData block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        if (isSuccessful) {
            NSLog(@"%@",filename);
            [weakSelf registerUserInfo:url];
        }
    } progress:^(CGFloat progress) {
        
    }];
    
}

- (void)registerUserInfo:(NSString *)iconUrl {
    CustomTextField *text1 = (CustomTextField *)[inputView viewWithTag:1];
    CustomTextField *text = (CustomTextField *)[inputView viewWithTag:2];
    BmobUser *registerNewUser = [[BmobUser alloc] init];
    [registerNewUser setUsername:text1.textField.text];
    [registerNewUser setPassword:text.textField.text];
    [registerNewUser setObject:iconUrl forKey:@"usericon"];
    [registerNewUser signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];

        }
    }];
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
