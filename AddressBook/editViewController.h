//
//  editViewController.h
//  AddressBook
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol editViewControllerDelegate <NSObject>
@optional - (void)updateView:(personModel *)model;
@end

@interface editViewController : UIViewController
@property (nonatomic, strong) NSString *dbCode;
@property (nonatomic, strong) NSString *originData;
@property (nonatomic, strong) NSString *studentID;
@property (nonatomic, strong) NSString *classID;
@property (nonatomic, assign) NSInteger PIndex;

@property (nonatomic, strong) UIPickerView *sexPicker;
@property (nonatomic, strong) UIDatePicker *birthdayPicker;
@property (nonatomic, strong) UIPickerView *typePicker;
@property (nonatomic, strong) NSArray *sexArray;
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, assign) id <editViewControllerDelegate> delegate;
@end
