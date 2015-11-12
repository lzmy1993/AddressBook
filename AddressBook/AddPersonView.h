//
//  AddPersonView.h
//  AddressBook
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPersonView : UIView<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UITextField *personIDField;
@property (nonatomic, strong) UITextField *addressField;
@property (nonatomic, strong) UITextField *phoneNumField;
@property (nonatomic, strong) UITextField *shortPhoneNumField;
@property (nonatomic, strong) UITextField *QQField;
@property (nonatomic, strong) UITextField *emailFiled;
@property (nonatomic, strong) UITextField *sexLabel;
@property (nonatomic, strong) UIPickerView *sexPicker;
@property (nonatomic, strong) UITextField *birthdayLabel;
@property (nonatomic, strong) UIDatePicker *birthdayPicker;
@property (nonatomic, strong) UITextField *typeLabel;
@property (nonatomic, strong) UIPickerView *typePicker;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) NSArray *sexArray;
@property (nonatomic, strong) NSArray *typeArray;
@end
