//
//  AddPersonView.m
//  AddressBook
//
//  Created by apple on 15/9/8.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AddPersonView.h"

@implementation AddPersonView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _sexArray = @[@"男",@"女"];
        _typeArray = @[@"班长",@"团支书",@"普通成员"];
        self.backgroundColor = [UIColor colorWithHexString:@"#faebd7"];
        
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        _imageV.userInteractionEnabled = YES;
        _imageV.layer.masksToBounds = YES;
        _imageV.layer.cornerRadius = WIDTH(_imageV)/2.f;
        _imageV.backgroundColor = [UIColor blueColor];
        [self addSubview:_imageV];
        
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(120, 10, frame.size.width - 130, 30)];
        _nameField.placeholder = @"姓名";
        _nameField.textAlignment = NSTextAlignmentCenter;
        _nameField.font = [UIFont systemFontOfSize:15.f];
        _nameField.layer.cornerRadius = 5.f;
        _nameField.layer.borderColor = [UIColor blackColor].CGColor;
        _nameField.layer.borderWidth = 0.5f;
        _nameField.delegate = self;
        [self addSubview:_nameField];
        
        _personIDField = [[UITextField alloc] initWithFrame:CGRectMake(120, VIEW_Y(_nameField)+HEIGHT(_nameField)+5, frame.size.width - 130, 30)];
        _personIDField.placeholder = @"学号";
        _personIDField.textAlignment = NSTextAlignmentCenter;
        _personIDField.font = [UIFont systemFontOfSize:15.f];
        _personIDField.layer.cornerRadius = 5.f;
        _personIDField.layer.borderColor = [UIColor blackColor].CGColor;
        _personIDField.layer.borderWidth = 0.5f;
        _personIDField.keyboardType = UIKeyboardTypeNumberPad;
        _personIDField.delegate = self;
        [self addSubview:_personIDField];
        
        _sexLabel = [[UITextField alloc] initWithFrame:CGRectMake(120, VIEW_Y(_personIDField)+HEIGHT(_personIDField) + 5, frame.size.width - 130, 30)];
        _sexLabel.text = @"男";
        _sexLabel.textAlignment = NSTextAlignmentCenter;
        _sexLabel.font = [UIFont systemFontOfSize:15.f];
        _sexLabel.layer.cornerRadius = 5.f;
        _sexLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _sexLabel.layer.borderWidth = 0.5f;
        _sexLabel.delegate = self;
        [self addSubview:_sexLabel];
        
        _sexPicker = [[UIPickerView alloc] init];
        _sexPicker.delegate = self;
        _sexPicker.dataSource = self;
        _sexLabel.inputView = _sexPicker;
        
        _birthdayLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, VIEW_Y(_sexLabel)+HEIGHT(_sexLabel) + 10, frame.size.width - 20, 30)];
        _birthdayLabel.font = [UIFont systemFontOfSize:15.f];
        _birthdayLabel.placeholder = @"生日";
        _birthdayLabel.textAlignment = NSTextAlignmentCenter;
        _birthdayLabel.layer.cornerRadius = 5.f;
        _birthdayLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _birthdayLabel.layer.borderWidth = 0.5f;
        _birthdayLabel.delegate = self;
        [self addSubview:_birthdayLabel];
        
        _birthdayPicker = [[UIDatePicker alloc]init];
        _birthdayPicker.datePickerMode = UIDatePickerModeDate;
        _birthdayPicker.maximumDate = [NSDate date];
        [_birthdayPicker addTarget:self action:@selector(getBirthday:) forControlEvents:UIControlEventValueChanged];
        _birthdayLabel.inputView = _birthdayPicker;
        
        _typeLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, VIEW_Y(_birthdayLabel)+HEIGHT(_birthdayLabel) + 5, frame.size.width - 20, 30)];
        _typeLabel.text = @"普通成员";
        _typeLabel.font = [UIFont systemFontOfSize:15.f];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.cornerRadius = 5.f;
        _typeLabel.layer.borderColor = [UIColor blackColor].CGColor;
        _typeLabel.layer.borderWidth = 0.5f;
        _typeLabel.delegate = self;
        [self addSubview:_typeLabel];
        
        _typePicker = [[UIPickerView alloc] init];
        _typePicker.delegate = self;
        _typePicker.dataSource = self;
        _typeLabel.inputView = _typePicker;
        
        _addressField = [[UITextField alloc] initWithFrame:CGRectMake(10, VIEW_Y(_typeLabel)+HEIGHT(_typeLabel)+5, frame.size.width - 20, 30)];
        _addressField.placeholder = @"籍贯";
        _addressField.font = [UIFont systemFontOfSize:15.f];
        _addressField.textAlignment = NSTextAlignmentCenter;
        _addressField.layer.cornerRadius = 5.f;
        _addressField.layer.borderColor = [UIColor blackColor].CGColor;
        _addressField.layer.borderWidth = 0.5f;
        _addressField.delegate = self;
        [self addSubview:_addressField];
        
        _phoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(10, VIEW_Y(_addressField)+HEIGHT(_addressField)+5, frame.size.width - 20, 30)];
        _phoneNumField.placeholder = @"长号";
        _phoneNumField.font = [UIFont systemFontOfSize:15.f];
        _phoneNumField.textAlignment = NSTextAlignmentCenter;
        _phoneNumField.layer.cornerRadius = 5.f;
        _phoneNumField.layer.borderColor = [UIColor blackColor].CGColor;
        _phoneNumField.layer.borderWidth = 0.5f;
        _phoneNumField.keyboardType = UIKeyboardTypePhonePad;
        _phoneNumField.delegate = self;
        [self addSubview:_phoneNumField];

        _shortPhoneNumField = [[UITextField alloc] initWithFrame:CGRectMake(10, VIEW_Y(_phoneNumField)+HEIGHT(_phoneNumField)+5, frame.size.width - 20, 30)];
        _shortPhoneNumField.placeholder = @"短号";
        _shortPhoneNumField.font = [UIFont systemFontOfSize:15.f];
        _shortPhoneNumField.textAlignment = NSTextAlignmentCenter;
        _shortPhoneNumField.layer.cornerRadius = 5.f;
        _shortPhoneNumField.layer.borderColor = [UIColor blackColor].CGColor;
        _shortPhoneNumField.layer.borderWidth = 0.5f;
        _shortPhoneNumField.keyboardType = UIKeyboardTypePhonePad;
        _shortPhoneNumField.delegate = self;
        [self addSubview:_shortPhoneNumField];
        
        _QQField = [[UITextField alloc] initWithFrame:CGRectMake(10, VIEW_Y(_shortPhoneNumField)+HEIGHT(_shortPhoneNumField)+5, frame.size.width - 20, 30)];
        _QQField.placeholder = @"QQ";
        _QQField.font = [UIFont systemFontOfSize:15.f];
        _QQField.textAlignment = NSTextAlignmentCenter;;
        _QQField.layer.cornerRadius = 5.f;
        _QQField.layer.borderColor = [UIColor blackColor].CGColor;
        _QQField.layer.borderWidth = 0.5f;
        _QQField.keyboardType = UIKeyboardTypeNumberPad;
        _QQField.delegate = self;
        [self addSubview:_QQField];
        
        _emailFiled = [[UITextField alloc] initWithFrame:CGRectMake(10, VIEW_Y(_QQField)+HEIGHT(_QQField)+5, frame.size.width - 20, 30)];
        _emailFiled.placeholder = @"Email";
        _emailFiled.font = [UIFont systemFontOfSize:15.f];
        _emailFiled.textAlignment = NSTextAlignmentCenter;
        _emailFiled.layer.cornerRadius = 5.f;
        _emailFiled.layer.borderColor = [UIColor blackColor].CGColor;
        _emailFiled.layer.borderWidth = 0.5f;
        _emailFiled.keyboardType = UIKeyboardTypeEmailAddress;
        _emailFiled.delegate = self;
        [self addSubview:_emailFiled];
        
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2 - 10 - (frame.size.width - 40)/2, VIEW_Y(_emailFiled) + HEIGHT(_emailFiled) + 10, (frame.size.width - 40)/2, 50)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = 5.f;
        _cancelBtn.backgroundColor = [UIColor grayColor];
        [self addSubview:_cancelBtn];
        
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2 + 10, VIEW_Y(_emailFiled) + HEIGHT(_emailFiled) + 10, (frame.size.width - 40)/2, 50)];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius = 5.f;
        _saveBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_saveBtn];
    }
    return self;
}

- (void)getBirthday:(UIDatePicker *)datePicker{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *text = [formatter stringFromDate:datePicker.date];
    _birthdayLabel.text = text;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = self.frame.size.height - 64 - (textField.frame.origin.y + textField.frame.size.height+216);
    if(offset <= 0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = offset;
            self.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 64.0;
        self.frame = frame;
    }];
    return YES;
}

#pragma mark - UIPickViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == _sexPicker)
        return _sexArray.count;
    else
        return _typeArray.count;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == _sexPicker)
        return _sexArray[row];
    else
        return _typeArray[row];
}
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == _sexPicker) {
        NSString *str = [_sexArray objectAtIndex:row];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        [attStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18.f] range:NSMakeRange(0, attStr.length)];
        if (row == 0)
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, attStr.length)];
        else
            [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attStr.length)];
        return attStr;
    }else{
        return nil;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == _sexPicker)
        _sexLabel.text = _sexArray[row];
    else
        _typeLabel.text = _typeArray[row];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
