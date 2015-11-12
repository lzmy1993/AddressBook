//
//  AddClassView.h
//  AddressBook
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddClassView : UIView<UITextViewDelegate>
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UITextField *classIDField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UILabel *label1;
- (void)showWithModel:(classModel *)model;
@end
