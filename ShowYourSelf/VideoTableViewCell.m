//
//  VideoTableViewCell.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "VideoTableViewCell.h"

@implementation VideoTableViewCell{
    UIView *uiview;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        VIEW_CLIPS(_iconImageView);
        VIEW_CORNERRADIUS(_iconImageView, 20);
        [self.contentView addSubview:_iconImageView];
        
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.right + 10, 10,kSCREEN_WIDTH - _iconImageView.right - 10-10, 30)];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        _userNameLabel.textColor = BLACKCOLOR;
        [self.contentView addSubview:_userNameLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.x, _userNameLabel.bottom + 5, self.width-_userNameLabel.x-10, 0)];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = BLACKCOLOR;
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        _thumbilImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _contentLabel.bottom + 10, kSCREEN_WIDTH - 20, kSCREEN_WIDTH/kSCREEN_HEIGHT * (kSCREEN_WIDTH-20))];
        _thumbilImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        _thumbilImageView.userInteractionEnabled = YES;
        _thumbilImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_thumbilImageView addGestureRecognizer:tap];
        [self.contentView addSubview:_thumbilImageView];
        
        _playView = [[VideoPlayView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH - 20, kSCREEN_WIDTH/kSCREEN_HEIGHT * (kSCREEN_WIDTH-20)) andUrl:nil fromNet:NO];
        _playView.userInteractionEnabled = YES;
        [_thumbilImageView addSubview:_playView];
        _progressView = [SDLoopProgressView progressView];
        _progressView.frame = CGRectMake((_thumbilImageView.width-60)/2.0, (_thumbilImageView.height-60)/2.0, 60, 60);
        [_thumbilImageView addSubview:_progressView];
        _progressView.hidden = YES;
    }
    return self;
}

- (void)setModel:(VideoModel *)model {
    _model = model;
    _userNameLabel.text = model.userName;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL_STR(model.iconUrl)] placeholderImage:SET_IMAGE(@"icon", PNG)];
    _contentLabel.text = model.content;
    _contentLabel.height = [NSString getStringSizeWithString:model.content withStringFont:[UIFont systemFontOfSize:14] withStringMaxSize:CGSizeMake(_contentLabel.width, MAXFLOAT)].height;
    _thumbilImageView.y = _contentLabel.bottom + 10;
    [_thumbilImageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL_STR(model.thumbilUrl)] placeholderImage:SET_IMAGE(@"icon", PNG)];
    //_playView.url = model.videoUrl;
    
    
    
}

- (void)tap {
    _playView.hidden = NO;
    _progressView.hidden = NO;
    [BmobProFile downloadFileWithFilename:_model.videoUrl block:^(BOOL isSuccessful, NSError *error, NSString *filepath) {
        [_playView setUrl:filepath];
         [_playView.player play];
    } progress:^(CGFloat progress) {
            _progressView.progress = progress;
       
    }];
}

- (VideoPlayView *)createPlayView:(NSString *)filePath {
    if (!_playView) {
       
       
    }
    return _playView;
}

@end
