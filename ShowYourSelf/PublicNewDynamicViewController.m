//
//  PublicNewDynamicViewController.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "PublicNewDynamicViewController.h"
#import <BUKImagePickerController/BUKImagePickerController.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PublicNewDynamicViewController ()<BUKImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
    UITextView *_textView;
    UIView *_imagesView;
    UIButton *_addPictureButton;
    NSMutableArray *_imagesArray;
}

@end

@implementation PublicNewDynamicViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imagesArray = [NSMutableArray array];
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self createUI];
}

- (void)createUI {
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendButtonClicked)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-20, 80)];
    _textView.placeHolder = @"说出你此刻的想法...";
    VIEW_BORDERCOLOR(_textView, LIGHTGRAYCOLOR);
    VIEW_BORDERWIDTH(_textView, 1);
    VIEW_CLIPS(_textView);
    VIEW_CORNERRADIUS(_textView, 5);
    [self.view addSubview:_textView];
    
    _imagesView = [[UIView alloc] initWithFrame:CGRectMake(20, _textView.bottom + 10, kSCREEN_WIDTH-40, (kSCREEN_WIDTH-40)/3.0)];
    [self.view addSubview:_imagesView];
    _addPictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addPictureButton.tag = 1;
    _addPictureButton.titleLabel.font = [UIFont systemFontOfSize:(kSCREEN_WIDTH-40)/3.0-30];
    _addPictureButton.frame = CGRectMake(0, 0, (kSCREEN_WIDTH-40)/3.0, (kSCREEN_WIDTH-40)/3.0);
    [_addPictureButton setTitle:@"+" forState:UIControlStateNormal];
    [_addPictureButton setTitleColor:LIGHTGRAYCOLOR forState:UIControlStateNormal];
    VIEW_BORDERCOLOR(_addPictureButton, LIGHTGRAYCOLOR);
    VIEW_BORDERWIDTH(_addPictureButton, 1);
    [_addPictureButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_imagesView addSubview:_addPictureButton];
}

#pragma mark buttonClick

- (void)addButtonClick {
    BUKImagePickerController *pickerCtl = [[BUKImagePickerController alloc]init];
    pickerCtl.maximumNumberOfSelection = 9;
    pickerCtl.delegate = self;
    pickerCtl.sourceType = BUKImagePickerControllerSourceTypeLibrary;
    [self presentViewController:pickerCtl animated:YES completion:nil];
}



- (void)buk_imagePickerController:(BUKImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    NSMutableArray *images = [NSMutableArray array];
    for (ALAsset *asset in assets) {
        UIImage *image = [UIImage imageWithCGImage:[asset thumbnail]];
        [images addObject:image];
        
        UIImage *updateImage = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        [_imagesArray addObject:updateImage];
    }
    [self createImagesView:images];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)buk_imagePickerControllerDidCancel:(BUKImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark create images view

- (void)createImagesView:(NSArray *)images {
    NSArray *subViews = [_imagesView subviews];
    for (UIView *view in subViews) {
        if (view.tag != 1) {
            [view removeFromSuperview];
        }
    }
    
    @autoreleasepool {
        for (int i = 0; i <= images.count; i ++) {
            if (i < images.count) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * ((kSCREEN_WIDTH-40)/3.0+1), i/3*((kSCREEN_WIDTH-40)/3.0+1), (kSCREEN_WIDTH-40)/3.0, (kSCREEN_WIDTH-40)/3.0)];
                imageView.image = images[i];
                [_imagesView addSubview:imageView];
            }else {
                _addPictureButton.frame = CGRectMake(i%3 * ((kSCREEN_WIDTH-40)/3.0+1), i/3*((kSCREEN_WIDTH-40)/3.0+1), (kSCREEN_WIDTH-40)/3.0, (kSCREEN_WIDTH-40)/3.0);
                _imagesView.height = _addPictureButton.bottom;
            }
        }
    }
}

#pragma mark button clicked
- (void)sendButtonClicked {
    
    if (_imagesArray.count == 0 && _textView.text.length == 0) {
        return;
    }
    
    NSMutableArray *images = [NSMutableArray array];
    for (UIImage *image in _imagesArray) {
        NSData *data = UIImageJPEGRepresentation(image, 1);
        NSDictionary *dictory = [[NSDictionary alloc] initWithObjectsAndKeys:@"image.jpg",@"filename",data,@"data", nil];
        [images addObject:dictory];
    }
    __weak typeof(self) weakSelf = self;
    [BmobProFile uploadFilesWithDatas:images resultBlock:^(NSArray *filenameArray, NSArray *urlArray, NSArray *bmobFileArray, NSError *error) {
        if (error) {
            
        }else {
            [weakSelf upLoadDynamic:urlArray];
        }
    } progress:^(NSUInteger index, CGFloat progress) {
        
    }];
}

- (void)upLoadDynamic:(NSArray *)urls {
    BmobUser *user = [BmobUser getCurrentUser];
    NSString *userName = [user objectForKey:@"username"];
    NSString *usericon = [user objectForKey:@"usericon"];
    BmobObject *dynamic = [BmobObject objectWithClassName:USER_DYNAMIC];
    [dynamic setObject:urls forKey:@"images"];
    [dynamic setObject:_textView.text forKey:@"content"];
    [dynamic setObject:userName forKey:@"username"];
    [dynamic setObject:usericon forKey:@"usericon"];
    [dynamic setObject:user.objectId forKey:@"userid"];
    DynamicModel *model = [[DynamicModel alloc] init];
    model.userName = userName;
    model.userIcon = usericon;
    model.content = _textView.text;
    model.images = urls;
     __weak typeof(self) weakSelf = self;
    [dynamic saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            if (_block) {
                _block(model);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
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
