//
//  GetPicturesHeight.m
//  ShowYourSelf
//
//  Created by 郝鹏飞 on 15/11/8.
//  Copyright © 2015年 郝鹏飞. All rights reserved.
//

#import "GetPicturesHeight.h"
#define OnePicture kSCREEN_WIDTH-70

#define LessFour (kSCREEN_WIDTH-70)/3.0

#define LessSeven (kSCREEN_WIDTH-70)/3.0*2

#define lessTen (kSCREEN_WIDTH-70)/3.0*3

@implementation GetPicturesHeight

+ (CGFloat)getPicturesHeightWith:(NSArray *)array {
    if (array.count == 0) {
        return 0;
    }else if (array.count == 1){
        return OnePicture;
    }else if (array.count <= 3) {
        return LessFour;
    }else if (array.count <= 6) {
        return LessSeven;
    }else {
        return lessTen;
    }
}

@end
