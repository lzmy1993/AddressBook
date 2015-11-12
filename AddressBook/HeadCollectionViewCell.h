//
//  HeadCollectionViewCell.h
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "personModel.h"
@interface HeadCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIView *extraView;
@property (nonatomic, strong) UIImageView *sexImageV;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *nick;
@property (nonatomic, strong) UILabel *address;

- (void)showWithModel:(personModel *)model;
@end
