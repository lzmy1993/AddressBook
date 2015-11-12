//
//  AcademyCollectionViewCell.m
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AcademyCollectionViewCell.h"

@implementation AcademyCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.shadowOffset = CGSizeMake(10, 10);//偏移距离
        self.layer.shadowOpacity = 0.5;//不透明度
        self.layer.shadowRadius = 10.0;//半径
//        self.layer.borderWidth = 1.f;
//        self.layer.borderColor = [UIColor greenColor].CGColor;
        
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.contentView addSubview:_imageView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.font = [UIFont boldSystemFontOfSize:50.0];
        self.label.backgroundColor = [UIColor grayColor];
        self.label.alpha = 0.4;
        self.label.textColor = [UIColor blackColor];
        [_imageView addSubview:self.label];
        
        _classIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, frame.size.width, 30)];
        _classIDLabel.textAlignment = NSTextAlignmentCenter;
        _classIDLabel.backgroundColor = [UIColor clearColor];
        _classIDLabel.textColor = [UIColor whiteColor];
        _classIDLabel.font = [UIFont systemFontOfSize:20.f];
        [self.contentView addSubview:_classIDLabel];
        
        _boyNumLabel = [[UILabel alloc]initWithFrame:CGRectMake((frame.size.width - 50)/2, VIEW_Y(_classIDLabel)+HEIGHT(_classIDLabel) + 5, 50, 20)];
        _boyNumLabel.textAlignment = NSTextAlignmentCenter;
        _boyNumLabel.backgroundColor = [UIColor clearColor];
        _boyNumLabel.textColor = [UIColor whiteColor];
        _boyNumLabel.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:_boyNumLabel];
        
        UIImageView *boyImageV = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_X(_boyNumLabel) - 12, VIEW_Y(_classIDLabel)+HEIGHT(_classIDLabel) + 10, 12, 12)];
        boyImageV.image = [UIImage imageNamed:@"iconfont-nan"];
        [self.contentView addSubview:boyImageV];
        
        UIImageView *girlImageV = [[UIImageView alloc]initWithFrame:CGRectMake(VIEW_X(_boyNumLabel) + WIDTH(_boyNumLabel) , VIEW_Y(_classIDLabel)+HEIGHT(_classIDLabel) + 10, 12, 12)];
        girlImageV.image = [UIImage imageNamed:@"iconfont-nv"];
        [self.contentView addSubview:girlImageV];
        
        _inrtroduction = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height - 50, frame.size.width, 40)];
        _inrtroduction.textAlignment = NSTextAlignmentCenter;
        _inrtroduction.numberOfLines = 0;
        _inrtroduction.backgroundColor = [UIColor clearColor];
        _inrtroduction.textColor = [UIColor whiteColor];
        _inrtroduction.font = [UIFont systemFontOfSize:15.f];
        [self.contentView addSubview:_inrtroduction];
    }
    return self;
}

- (void)showWithModel:(classModel *)model{
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",model.imageUrl]];
    _imageView.image = [UIImage imageWithContentsOfFile:imagePath];

    _classIDLabel.text = model.classID;
    _boyNumLabel.text = [NSString stringWithFormat:@"%@/%@",model.boyNum,model.girlNum];
    _inrtroduction.text = model.introduction;
}
@end
