//
//  DynamicTableViewCell.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/7.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "DynamicTableViewCell.h"
#import "NSString+GetSize.h"
@implementation DynamicTableViewCell {
    NSMutableArray *imageViews;
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
        imageViews = [NSMutableArray array];
        _iconImageView  = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        VIEW_CLIPS(_iconImageView);
        VIEW_CORNERRADIUS(_iconImageView, 20);
        [self.contentView addSubview:_iconImageView];
        
        _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_iconImageView.right + 10, 10,kSCREEN_WIDTH - _iconImageView.right - 10-10, 30)];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        _userNameLabel.textColor = BLACKCOLOR;
        [self.contentView addSubview:_userNameLabel];
        
        _contetLabel = [[UILabel alloc] initWithFrame:CGRectMake(_userNameLabel.x, _userNameLabel.bottom + 5, self.width-_userNameLabel.x-10, 0)];
        _contetLabel.font = [UIFont systemFontOfSize:14];
        _contetLabel.textColor = BLACKCOLOR;
        _contetLabel.numberOfLines = 0;
        [self.contentView addSubview:_contetLabel];
        
        _imagesView = [[UIImageView alloc] initWithFrame:CGRectMake(_contetLabel.x, _contetLabel.bottom + 5, _userNameLabel.width, 0)];
        _imagesView.userInteractionEnabled = YES;
        [self.contentView addSubview:_imagesView];
    }
    return self;
}

- (void)setModel:(DynamicModel *)model {
    [imageViews removeAllObjects];
    _contetLabel.text = model.content;
    _contetLabel.height = [NSString getStringSizeWithString:model.content withStringFont:[UIFont systemFontOfSize:14] withStringMaxSize:CGSizeMake(_contetLabel.width, MAXFLOAT)].height;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL_STR(model.userIcon)] placeholderImage:[UIImage imageNamed:@"icon"]];
    _imagesView.y = _contetLabel.bottom + 5;
    _userNameLabel.text = model.userName;
    
    [_imagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (model.images.count > 1) {
        for (int i = 0 ; i < model.images.count; i ++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * (PICTURE_WIDTH+1), i/3*(PICTURE_WIDTH+1), PICTURE_WIDTH, PICTURE_WIDTH)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL_STR(model.images[i])] placeholderImage:SET_IMAGE(@"icon", PNG)];
            [imageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
            //imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
            [imageView addGestureRecognizer:tap];
            VIEW_CLIPS(imageView);
            [_imagesView addSubview:imageView];
            if (i == model.images.count - 1) {
                _imagesView.height = imageView.bottom + 5;
            }
            [imageViews addObject:imageView];
        }
    }else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,_contetLabel.width,_contetLabel.width)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:IMAGE_URL_STR(model.images[0])] placeholderImage:SET_IMAGE(@"icon", PNG)];
        [imageView setContentScaleFactor:[[UIScreen mainScreen]scale]];
        //imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTap:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        VIEW_CLIPS(imageView);
        _imagesView.height = imageView.bottom + 5;
        [_imagesView addSubview:imageView];
        [imageViews addObject:imageView];
    }
    
}

- (void)viewTap:(UITapGestureRecognizer *)tap {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
        imageViewer.frame = CGRectMake(0,0, self.frame.size.width, window.frame.size.height);
        imageViewer.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        imageViewer.delegate = self;
        [imageViewer showWithImageViews:imageViews selectedView:(UIImageView *)tap.view];

}

@end
