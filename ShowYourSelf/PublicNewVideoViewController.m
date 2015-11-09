//
//  PublicNewVideoViewController.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "PublicNewVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <BUKImagePickerController/BUKImagePickerController.h>
#import "VideoPlayView.h"
#import "VideoModel.h"

#import "SDProgressView.h"
@interface PublicNewVideoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    NSString *videoUrl;
    BOOL _hadVideo;
}

@property (nonatomic,strong)UIImagePickerController *imagePicker;

@property (nonatomic,strong)VideoPlayView *playView;

@property (nonatomic,strong)UITextView *textView;

@property (nonatomic,strong)SDLoopProgressView *progressView;

@end

@implementation PublicNewVideoViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *public = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(publicNewVideo)];
    UIBarButtonItem *video = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(getNewVideo)];

    self.navigationItem.rightBarButtonItems = @[public,video];
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    [self createImagePicker];
    [self createUI];
}

- (void)createUI {
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, kSCREEN_WIDTH-20, 80)];
    _textView.placeHolder = @"说出你此刻的想法...";
    VIEW_BORDERCOLOR(_textView, LIGHTGRAYCOLOR);
    VIEW_BORDERWIDTH(_textView, 1);
    VIEW_CLIPS(_textView);
    VIEW_CORNERRADIUS(_textView, 5);
    [self.view addSubview:_textView];
    
    
}


#pragma mark create imagepicker
- (UIImagePickerController *)createImagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        _imagePicker.videoQuality = UIImagePickerControllerQualityType640x480;
        _imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

#pragma mark button click

- (void)publicNewVideo {
    if (!_hadVideo || _textView.text.length ==0 ) {
        return;
    }
    
    _progressView = [SDLoopProgressView progressView];
    _progressView.frame = CGRectMake((_playView.width-60)/2.0, (_playView.height-60)/2.0, 60, 60);
    [_playView addSubview:_progressView];
    NSData *data = [NSData dataWithContentsOfFile:videoUrl];
    
    __weak typeof(self) weakSelf = self;
    [BmobProFile uploadFileWithFilename:@"video.mp4" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
        if (isSuccessful) {
            [weakSelf upLoadVideoImage:filename];
        }
    } progress:^(CGFloat progress) {
        _progressView.progress = progress;
    }];
    
   
}

- (void)upLoadVideoImage:(NSString *)videoFilename {
    UIImage *viewImage = [self getImage:videoUrl];
    NSData *data = UIImageJPEGRepresentation(viewImage, 1.0);
    __weak typeof(self) weakSelf = self;
     [BmobProFile uploadFileWithFilename:@"image.jpg" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
         [weakSelf upLoadVideo:url andFileName:videoFilename];
     } progress:^(CGFloat progress) {
         
     }];
}



- (void)upLoadVideo:(NSString *)url andFileName:(NSString *)filename{
    BmobUser *user = [BmobUser getCurrentUser];
    NSString *userName = [user objectForKey:@"username"];
    NSString *usericon = [user objectForKey:@"usericon"];
    BmobObject *video = [BmobObject objectWithClassName:USER_VIDEO];
    [video setObject:filename forKey:@"videourl"];
    [video setObject:_textView.text forKey:@"content"];
    [video setObject:userName forKey:@"username"];
    [video setObject:usericon forKey:@"usericon"];
    [video setObject:user.objectId forKey:@"userid"];
    [video setObject:url forKey:@"thumbil"];
    NSLog(@"%@,,,%@",filename,url);
    VideoModel *model = [[VideoModel alloc] init];
    model.userName = userName;
    model.iconUrl = usericon;
    model.content = _textView.text;
    model.videoUrl = filename;
    model.thumbilUrl = url;
    __weak typeof(self) weakSelf = self;
    [video saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            if (_block) {
                _block(model);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }else {
            NSLog(@"%@",[error description]);
        }
    }];

}


- (void)getNewVideo {
    [self presentViewController:_imagePicker animated:YES completion:nil];

}

#pragma mark picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    NSString *urlStr = [url path];
    videoUrl = urlStr;
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
        UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        _hadVideo = YES;
        [self createVideoPlayerViewWithUrl:videoUrl fromNet:NO];
    }
}

- (void)createVideoPlayerViewWithUrl:(NSString *)url fromNet:(BOOL)flag {
    _playView = [[VideoPlayView alloc] initWithFrame:CGRectMake(10, _textView.bottom + 10, kSCREEN_WIDTH - 20, kSCREEN_WIDTH/kSCREEN_HEIGHT * (kSCREEN_WIDTH-20)) andUrl:url fromNet:NO];
    
    [self.view addSubview:_playView];
    
    
    
    
    [_playView.player play];
}

-(UIImage *)getImage:(NSString *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoURL] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
    
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
