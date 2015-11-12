//
//  ClassViewController.h
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClassViewControllerDelegate <NSObject>
- (void) updateClass:(classModel *)model;
@end
@interface ClassViewController : UIViewController
@property (nonatomic, strong) classModel *classModel;
@property (nonatomic, assign) id <ClassViewControllerDelegate> delegate;
@end
