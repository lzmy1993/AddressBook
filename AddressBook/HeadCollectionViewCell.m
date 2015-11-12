//
//  HeadCollectionViewCell.m
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "HeadCollectionViewCell.h"
#import "UIColor+AddColor.h"

@implementation HeadCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.frame = CGRectMake(0, 0, 95, 95);
        _headImageView.layer.cornerRadius = WIDTH(_headImageView)/2.f;
        _headImageView.layer.masksToBounds = YES;
        //_headImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_headImageView];
        
        _extraView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT(_headImageView)-18, WIDTH(_headImageView), 18)];
        _extraView.alpha = 0.75;
        [_headImageView addSubview:_extraView];
        
        _sexImageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(_headImageView)/2-12, 3, 12, 12)];
        //_sexImageV.backgroundColor = [UIColor whiteColor];
        [_extraView addSubview:_sexImageV];
        
        _ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH(_headImageView)/2+5, 3, 12, 12)];
        //_ageLabel.backgroundColor = [UIColor grayColor];
        _ageLabel.textAlignment = NSTextAlignmentCenter;
        _ageLabel.textColor = [UIColor whiteColor];
        _ageLabel.font = [UIFont systemFontOfSize:10.f];
        [_extraView addSubview:_ageLabel];
        
        _nick = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT(_headImageView)+8, WIDTH(_headImageView), 12)];
        _nick.textAlignment = NSTextAlignmentCenter;
        //_nick.backgroundColor = [UIColor blueColor];
        _nick.font = [UIFont systemFontOfSize:12.f];
        _nick.textColor = [UIColor colorWithHexString:@"#353535"];
        [self.contentView addSubview:_nick];
        
        UIImageView *addressImageV = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(_headImageView)/10, VIEW_Y(_nick)+HEIGHT(_nick)+6, 10, 10)];
        addressImageV.image = [UIImage imageNamed:@"marker"];
        //addressImageV.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:addressImageV];
        
        _address = [[UILabel alloc]initWithFrame:CGRectMake(VIEW_X(addressImageV) + WIDTH(addressImageV)+5, VIEW_Y(_nick)+HEIGHT(_nick)+6, frame.size.width - VIEW_X(addressImageV) - WIDTH(addressImageV) - 5, 10)];
        _address.textColor = [UIColor colorWithHexString:@"#bbbbbb"];
        //_address.backgroundColor = [UIColor yellowColor];
        _address.font = [UIFont systemFontOfSize:10.f];
        [self.contentView addSubview:_address];
    }
    return self;
}
- (void)showWithModel:(personModel *)model{
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",model.imageUrl]];
    _headImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    
    //性别背景
    if ([model.sex isEqualToString:@"1"]) {
        [_extraView setBackgroundColor:[UIColor colorWithHexString:@"#72cae2"]];
        _sexImageV.image = [UIImage imageNamed:@"iconfont-nan"];
    }else{
        [_extraView setBackgroundColor:[UIColor colorWithHexString:@"#ff5959"]];
        _sexImageV.image = [UIImage imageNamed:@"iconfont-nv"];
    }
    //年龄
    NSDate *nowYear = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSString *dateStr = [formatter stringFromDate:nowYear];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *birthYear = [formatter1 dateFromString:model.birthday];
    NSString *birthday = [formatter stringFromDate:birthYear];
    
    NSInteger age = [dateStr integerValue] - [birthday integerValue];
    _ageLabel.text = [NSString stringWithFormat:@"%@",@(age)];
    
    _nick.text = model.name;
    _address.text = model.phoneNum;
}
@end
