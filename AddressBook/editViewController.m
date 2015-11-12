//
//  editViewController.m
//  AddressBook
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "editViewController.h"
#import "ZYQAssetPickerController.h"
#import "EditImageViewController.h"
@interface editViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, UINavigationControllerDelegate, EditImageViewControllerDelegate>{
    NSString *changeData;
    UITextField *textField;
    UIImageView *imageV;
    UIImagePickerController *imagePicker;
}

@end

@implementation editViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#faebd7"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _sexArray = @[@"男",@"女"];
    _typeArray = @[@"班长",@"团支书",@"普通成员"];
    
    [self loadSubView];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(updateData)];
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)loadSubView{
    if (![_dbCode isEqualToString:@"imageUrl"]) {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, WIDTH(self.view) - 40, 40)];
        textField.text = _originData;
        textField.textColor = [UIColor blackColor];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.layer.borderWidth = 0.5f;
        textField.layer.borderColor = [UIColor blackColor].CGColor;
        textField.font = [UIFont systemFontOfSize:20.f];
        [self.view addSubview:textField];
        
        if ([_dbCode isEqualToString:@"sex"]) {
            _sexPicker = [[UIPickerView alloc] init];
            _sexPicker.delegate = self;
            _sexPicker.dataSource = self;
            textField.inputView = _sexPicker;
        }else if ([_dbCode isEqualToString:@"birthday"]){
            _birthdayPicker = [[UIDatePicker alloc]init];
            _birthdayPicker.datePickerMode = UIDatePickerModeDate;
            _birthdayPicker.maximumDate = [NSDate date];
            [_birthdayPicker addTarget:self action:@selector(getBirthday:) forControlEvents:UIControlEventValueChanged];
            textField.inputView = _birthdayPicker;
        }else if([_dbCode isEqualToString:@"type"]) {
            _typePicker = [[UIPickerView alloc] init];
            _typePicker.delegate = self;
            _typePicker.dataSource = self;
            textField.inputView = _typePicker;
        }else if([_dbCode isEqualToString:@"phoneNum"] || [_dbCode isEqualToString:@"shortPhoneNum"]) {
            textField.keyboardType = UIKeyboardTypePhonePad;
        }else if([_dbCode isEqualToString:@"email"]) {
            textField.keyboardType = UIKeyboardTypeEmailAddress;
        }else if([_dbCode isEqualToString:@"QQ"] || [_dbCode isEqualToString:@"ClassID"] || [_dbCode isEqualToString:@"studentID"]) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }else{
        imageV = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH(self.view)-200)/2, 50, 200, 200)];
        imageV.userInteractionEnabled = YES;
        imageV.backgroundColor = [UIColor blueColor];
        [self.view addSubview:imageV];
        
        NSString *path_sandox = NSHomeDirectory();
        //设置一个图片的存储路径
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",_originData]];
        imageV.image = [UIImage imageWithContentsOfFile:imagePath];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
        [imageV addGestureRecognizer:tap];
    }
}

- (void)updateData {
    if ([_dbCode isEqualToString:@"classID"]) {
        if (![[self QueryClassIDs] containsObject:textField.text]) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"该班级未添加" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
        return;
    }
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];
    [db beginTransaction];
    
    if ([_dbCode isEqualToString:@"imageUrl"]) {
        [self saveImage:imageV.image];
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE Person SET %@ = '%@' WHERE studentID = %@", _dbCode, [NSString stringWithFormat:@"P%@",@(_PIndex)], _studentID]];
    }else{
        if ([_originData isEqualToString:textField.text]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        NSString *dbValue = [NSString string];
        if ([_dbCode isEqualToString:@"sex"]) {
            dbValue = [textField.text isEqualToString:@"男"]?@"1":@"0";
            
            //修改班级男女人数
            NSString *dbNumNameOp = [NSString string];
            NSString *dbNumName = [NSString string];
            if ([dbValue isEqualToString:@"1"]){
                dbNumName = @"boyNum";
                dbNumNameOp = @"girlNum";
            }
            else{
                dbNumName = @"girlNum";
                dbNumNameOp = @"boyNum";
            }
            
            [db executeUpdate:[NSString stringWithFormat:@"UPDATE Class SET %@ = %@+1,%@ = %@-1 WHERE classID = %@",dbNumName,dbNumName, dbNumNameOp, dbNumNameOp, _classID]];
            
        }else if ([_dbCode isEqualToString:@"type"]){
            dbValue = [textField.text isEqualToString:@"班长"]?@"1":[textField.text isEqualToString:@"团支书"]?@"2":@"3";
        }else{
            dbValue = textField.text;
        }
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE Person SET %@ = '%@' WHERE studentID = %@", _dbCode, dbValue, _studentID]];
    }

    [db commit];
    [db close];
    if (_delegate && [_delegate respondsToSelector:@selector(updateView:)]) {
        [_delegate updateView:[self QueryNewPersonData]];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveImage:(UIImage *)image{
    NSString *path_sandox = NSHomeDirectory();
    
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",[NSString stringWithFormat:@"P%@",@(_PIndex)]]];
    if ([UIImage imageWithContentsOfFile:imagePath] != nil) {
        NSFileManager *delete = [NSFileManager defaultManager];
        [delete removeItemAtURL:[NSURL URLWithString:imagePath] error:nil];
    }
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    
}

- (NSArray *)QueryClassIDs{
    NSMutableArray *classIDs = [[NSMutableArray alloc] initWithCapacity:0];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];
    FMResultSet *rs = [db executeQuery:@"select classID from Class"];
    while ([rs next]) {
        [classIDs addObject:[rs stringForColumn:@"classID"]];
    }
    return classIDs;
}

- (personModel *)QueryNewPersonData{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];
    NSString *studentIDStr = [NSString string];
    if ([_dbCode isEqualToString:@"studentID"])
        studentIDStr = textField.text;
    else
        studentIDStr = _studentID;
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM Person where studentID = ? ",studentIDStr];
    personModel *model = [[personModel alloc]init];
    while ([rs next]) {
        model.PIndex = [rs intForColumn:@"PIndex"];
        model.studentID = [rs stringForColumn:@"studentID"];
        model.name = [rs stringForColumn:@"name"];
        model.classID = [rs stringForColumn:@"classID"];
        model.sex = [rs stringForColumn:@"sex"];
        model.address = [rs stringForColumn:@"address"];
        model.birthday = [rs stringForColumn:@"birthday"];
        model.phoneNum = [rs stringForColumn:@"phoneNum"];
        model.shortPhoneNum = [rs stringForColumn:@"shortPhoneNum"];
        model.QQ = [rs stringForColumn:@"QQ"];
        model.email = [rs stringForColumn:@"email"];
        model.type = [rs stringForColumn:@"type"];
        model.imageUrl = [rs stringForColumn:@"imageUrl"];
    }
    
    [rs close];
    [db close];
    
    return model;
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
        textField.text = _sexArray[row];
    else
        textField.text = _typeArray[row];
}
- (void)getBirthday:(UIDatePicker *)datePicker{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *text = [formatter stringFromDate:datePicker.date];
    textField.text = text;
}

- (void)choosePhoto{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册获取", nil];
    [action showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self hidesBottomBarWhenPushed];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"没有照相功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    }else if (buttonIndex == 1){//相册
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"未授权访问相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }else {
            ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
            picker.maximumNumberOfSelection = 1;
            picker.assetsFilter = [ALAssetsFilter allAssets];
            picker.showEmptyGroups = NO;
            picker.delegate = self;
            picker.selectionFilter = [NSPredicate predicateWithBlock: ^BOOL (id evaluatedObject, NSDictionary *bindings) {
                if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                    NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                    return duration >= 1;
                }
                else {
                    return YES;
                }
            }];
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
}
#pragma mark - ZYQAssetPickerControllerDelegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    picker.isFinishDismissViewController = NO;
    
    NSMutableArray *arr = [NSMutableArray array];
    if (assets.count != 0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        for (NSInteger i = 0; i < assets.count; i++) {
            @synchronized(self)
            {
                ALAsset *asset = assets[i];
                UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage
                                                     scale:asset.defaultRepresentation.scale
                                               orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
                
                if (image) {
                    [arr addObject:image];
                }
            }
        }
        EditImageViewController *editVC = [[EditImageViewController alloc]init];
        editVC.imagesArray = arr;
        editVC.delegate = self;
        editVC.hidesBottomBarWhenPushed = YES;
        [picker pushViewController:editVC animated:YES];
    }
    else
        [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - EditImageViewControllerDelegate
- (void)finishedEdittingImages:(NSMutableArray *)array{
    UIImage *image = array[0];
    imageV.image = image;
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *selectImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (selectImage.size.width < 200 || selectImage.size.height < 200) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"所选照片像素过低，请重新选择" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
    else {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:selectImage];
        EditImageViewController *editVC = [[EditImageViewController alloc] init];
        editVC.imagesArray = arr;
        editVC.delegate = self;
        editVC.hidesBottomBarWhenPushed = YES;
        [picker pushViewController:editVC animated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
