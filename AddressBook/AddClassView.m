//
//  AddClassView.m
//  AddressBook
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "AddClassView.h"

@implementation AddClassView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#faebd7"];
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-150)/2, 20, 150, 150)];
        _imageV.userInteractionEnabled = YES;
        _imageV.backgroundColor = [UIColor blueColor];
        [self addSubview:_imageV];
        
        _label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, VIEW_Y(_imageV)+HEIGHT(_imageV) + 10, frame.size.width - 40, 20)];
        _label1.text = @"*请填写班级号(保存后无法修改)";
        _label1.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:_label1];
        
        _classIDField = [[UITextField alloc] initWithFrame:CGRectMake(20,VIEW_Y(_label1)+HEIGHT(_label1) + 5, frame.size.width - 40, 30)];
        _classIDField.font = [UIFont systemFontOfSize:15.f];
        _classIDField.layer.cornerRadius = 5.f;
        _classIDField.layer.borderColor = [UIColor blackColor].CGColor;
        _classIDField.layer.borderWidth = 0.5f;
        _classIDField.keyboardType = UIKeyboardTypeNumberPad;
        _classIDField.backgroundColor = [UIColor whiteColor];
        [self addSubview:_classIDField];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, VIEW_Y(_classIDField)+HEIGHT(_classIDField) + 10, frame.size.width - 40, 20)];
        label2.text = @"*请填写班级简介";
        label2.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:label2];
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, VIEW_Y(label2)+HEIGHT(label2) + 5, frame.size.width - 40, 80)];
        _textView.layer.cornerRadius = 5.f;
        _textView.layer.borderColor = [UIColor blackColor].CGColor;
        _textView.layer.borderWidth = 0.5f;
        _textView.delegate = self;
        [self addSubview:_textView];
        
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2 - 10 - 90, VIEW_Y(_textView) + HEIGHT(_textView) + 10, 90, 50)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = 5.f;
        _cancelBtn.backgroundColor = [UIColor grayColor];
        [self addSubview:_cancelBtn];
        
        _saveBtn = [[UIButton alloc]initWithFrame:CGRectMake(frame.size.width/2 + 10, VIEW_Y(_textView) + HEIGHT(_textView) + 10, 90, 50)];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius = 5.f;
        _saveBtn.backgroundColor = [UIColor redColor];
        [self addSubview:_saveBtn];
    }
    return self;
}

- (void)showWithModel:(classModel *)model{
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",model.imageUrl]];
    _imageV.image = [UIImage imageWithContentsOfFile:imagePath];
    _label1.text = @"班级号(不允许修改)";
    _classIDField.text = model.classID;
    _classIDField.enabled = NO;
    _textView.text = model.introduction;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGFloat offset = self.frame.size.height - 64 - (textView.frame.origin.y + textView.frame.size.height+216);
    if(offset <= 0){
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = offset;
            self.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    }];
    return YES;
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
