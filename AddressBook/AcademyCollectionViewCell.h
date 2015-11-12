//
//  AcademyCollectionViewCell.h
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "classModel.h"
@interface AcademyCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *classIDLabel;
@property (strong, nonatomic) UILabel *boyNumLabel;
@property (strong, nonatomic) UILabel *girlNumLabel;
@property (strong, nonatomic) UILabel *inrtroduction;

- (void)showWithModel:(classModel *)model;
@end
