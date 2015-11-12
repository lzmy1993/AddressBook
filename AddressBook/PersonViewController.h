//
//  PersonViewController.h
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PersonViewControllerDelegate <NSObject>
//0 == 修改, 1 == 删除, 2 == 修改班级（从dataArray里删除）
- (void)updateView:(personModel *)model withReason:(NSInteger)reason isTeacher:(BOOL)isTeacher;
@end

@interface PersonViewController : UIViewController
@property (nonatomic, strong) personModel *model;
@property (nonatomic, assign) id <PersonViewControllerDelegate> delegate;
@end
