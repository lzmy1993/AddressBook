//
//  ClassViewController.m
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ClassViewController.h"
#import "ArrowShapeFlowLayout.h"
#import "HeadCollectionViewCell.h"
#import "PersonViewController.h"
#import "AddPersonView.h"
#import "ZYQAssetPickerController.h"
#import "EditImageViewController.h"
#import "AddClassView.h"
#import <objc/runtime.h>

#define HEAD_IMAGEVIEW_WIDTH 60

@interface ClassViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, PersonViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, UINavigationControllerDelegate, EditImageViewControllerDelegate, UITextFieldDelegate, UISearchBarDelegate, UISearchResultsUpdating>{
    //初始化layout的参数
    CGSize itemSize;
    CGFloat HorizontalSapce;
    CGFloat VerticalSapce;
    CGFloat headViewHeight;
    CGFloat headViewSpaceWithTop;
    NSInteger selectedIndex;
    AddPersonView *addPersonView;
    AddClassView *updateClassView;
    UIBarButtonItem *rightBtn;
    UIImagePickerController *imagePicker;
    UISearchController *searchVC;
    BOOL doubleName;
    NSInteger viewIndex;
    BOOL changeImage;
    NSInteger newestIndex;
    
    NSMutableArray *searchArray;
}
@property (nonatomic, strong) ArrowShapeFlowLayout *arrowLayout;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *mynick;
@end

@implementation ClassViewController

- (void)viewWillAppear:(BOOL)animated{
    rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(doMore)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _classModel.classID;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#faebd7"];
    viewIndex = 0;
    
    _dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    searchArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self loadSubView];
    [self QueryData];
}

- (void)loadSubView{
    itemSize = CGSizeMake(95, 131);
    HorizontalSapce = 15;
    VerticalSapce = 10;
    headViewHeight = 44;
    headViewSpaceWithTop = 30 + headViewHeight;
    
    _arrowLayout = [[ArrowShapeFlowLayout alloc]initWithItemSize:itemSize HorizontalSapce:HorizontalSapce VerticalSapce:VerticalSapce headViewHeight:headViewHeight headViewSpaceWithTop:headViewSpaceWithTop];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:_arrowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[HeadCollectionViewCell class] forCellWithReuseIdentifier:@"headCell"];
    
    _headImageView = [[UIImageView alloc]init];
    _headImageView.frame = CGRectMake((WIDTH(self.view) - HEAD_IMAGEVIEW_WIDTH)/2, 5 + headViewHeight, HEAD_IMAGEVIEW_WIDTH, HEAD_IMAGEVIEW_WIDTH);
    _headImageView.layer.cornerRadius = WIDTH(_headImageView)/2.f;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.backgroundColor = [UIColor redColor];
    _headImageView.userInteractionEnabled = YES;
    [_collectionView addSubview:_headImageView];
    
    UITapGestureRecognizer *tapTeacher = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTeacher:)];
    [_headImageView addGestureRecognizer:tapTeacher];
    
    _mynick = [[UILabel alloc]init];
    _mynick.frame = CGRectMake((WIDTH(self.view) - 36)/2, VIEW_Y(_headImageView)+HEIGHT(_headImageView)+5, 36, 12);
    _mynick.textAlignment = NSTextAlignmentCenter;
    _mynick.font = [UIFont systemFontOfSize:12.f];
    _mynick.textColor = [UIColor colorWithHexString:@"#353535"];
    [_collectionView addSubview:_mynick];
    
    
    searchVC = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchVC.dimsBackgroundDuringPresentation = YES;
    searchVC.hidesNavigationBarDuringPresentation = YES;
    [searchVC.searchBar setFrame:CGRectMake(0, 0, WIDTH(self.view), 44)];
    searchVC.searchResultsUpdater = self;
    searchVC.searchBar.delegate = self;
    [_collectionView addSubview:searchVC.searchBar];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (searchVC.active) 
        return searchArray.count;
    return _dataArray.count - 1;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"headCell";
    HeadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    if (searchVC.active)
        [cell showWithModel:searchArray[indexPath.row]];
    else
        [cell showWithModel:_dataArray[indexPath.row + 1]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex = indexPath.row;
    PersonViewController *personVC = [[PersonViewController alloc]init];
    if (searchVC.active)
        personVC.model = searchArray[indexPath.row];
    else
        personVC.model = _dataArray[indexPath.row + 1];
    personVC.delegate = self;
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)tapTeacher:(UITapGestureRecognizer *)tap{
    PersonViewController *personVC = [[PersonViewController alloc]init];
    personVC.model = _dataArray[0];
    personVC.delegate = self;
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark - PersonViewControllerDelegate
- (void)updateView:(personModel *)model withReason:(NSInteger)reason isTeacher:(BOOL)isTeacher{
    if (reason == 0) {
        if (isTeacher) {
            [_dataArray replaceObjectAtIndex:0 withObject:model];
            
            NSString *path_sandox = NSHomeDirectory();
            //设置一个图片的存储路径
            NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",model.imageUrl]];
            _headImageView.image = [UIImage imageWithContentsOfFile:imagePath];
            
            _mynick.text = model.name;
        }else{
            [_dataArray replaceObjectAtIndex:selectedIndex + 1 withObject:model];
            //重新排序
            NSSortDescriptor *sorter = [[NSSortDescriptor alloc]initWithKey:@"type" ascending:YES];
            NSMutableArray *sortDescriptors = [[NSMutableArray alloc]initWithObjects:&sorter count:1];
            [_dataArray sortUsingDescriptors:sortDescriptors];
            
            [_collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:selectedIndex inSection:0]]];
        }
        
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
        [db open];
        
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM Class where classID = ?",_classModel.classID];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
        while ([rs next]){
            classModel *model = [[classModel alloc]init];
            model.CIndex = [rs intForColumn:@"CIndex"];
            model.classID = [rs stringForColumn:@"classID"];
            model.introduction = [rs stringForColumn:@"introduction"];
            model.boyNum = [NSNumber numberWithInteger:[rs intForColumn:@"boyNum"]];
            model.girlNum = [NSNumber numberWithInteger:[rs intForColumn:@"girlNum"]];
            model.imageUrl = [rs stringForColumn:@"imageUrl"];
            [arr addObject:model];
        }
        [rs close];
        [db close];
        if (_delegate && [_delegate respondsToSelector:@selector(updateClass:)]) {
            [_delegate updateClass:arr[0]];
        }
    }
    else if (reason == 1) {
        [self deleteData:model.studentID];
        
        NSString *newNum = [NSString string];
        NSString *dbNumName = [NSString string];
        if ([model.sex isEqualToString:@"1"]){
            dbNumName = @"boyNum";
            newNum = @([_classModel.boyNum integerValue] - 1).stringValue;
        }
        else{
            dbNumName = @"girlNum";
            newNum = @([_classModel.girlNum integerValue] - 1).stringValue;
        }
        
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
        [db open];
        [db executeUpdate:[NSString stringWithFormat:@"UPDATE Class SET %@ = '%@' WHERE classID = %@",dbNumName,newNum,_classModel.classID]];
        [db close];
        
        [_dataArray removeObjectAtIndex:selectedIndex + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
        [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        
        [_classModel setValue:newNum forKey:dbNumName];
        if (_delegate && [_delegate respondsToSelector:@selector(updateClass:)]) {
            [_delegate updateClass:_classModel];
        }
    }else if (reason == 2) {
        [_dataArray removeObjectAtIndex:selectedIndex + 1];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedIndex inSection:0];
        [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
    }
}

- (void)doMore{
    UIAlertController *doMoreAC = [UIAlertController alertControllerWithTitle:@"请选择操作" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *addPerson = [UIAlertAction actionWithTitle:@"添加成员" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"添加");
        viewIndex = 0;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
        self.title = @"添加新成员";
        
        addPersonView = [[AddPersonView alloc] initWithFrame:CGRectMake(0, 64, WIDTH(self.view), HEIGHT(self.view))];
        [self.view addSubview:addPersonView];
        
        [addPersonView.cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [addPersonView.saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tapChoosePhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
        [addPersonView.imageV addGestureRecognizer:tapChoosePhoto];
        
    }];
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"编辑班级信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        viewIndex = 1;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.hidesBackButton = YES;
        self.title = @"编辑班级信息";
        if (!updateClassView) {
            updateClassView = [[AddClassView alloc]initWithFrame:CGRectMake(0, 64, WIDTH(self.view), HEIGHT(self.view))];
        }
        [self.view addSubview:updateClassView];
        
        [updateClassView showWithModel:_classModel];
        [updateClassView.cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [updateClassView.saveBtn addTarget:self action:@selector(update) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
        [updateClassView.imageV addGestureRecognizer:tap];
        
        
        updateClassView.alpha = 0;
        [UIView animateWithDuration:1 animations:^{
            updateClassView.alpha = 1;
        }];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [doMoreAC addAction:addPerson];
    [doMoreAC addAction:edit];
    [doMoreAC addAction:cancel];
    
    [self presentViewController:doMoreAC animated:YES completion:nil];
}

- (void)back{
    self.title = _classModel.classID;
    self.navigationItem.hidesBackButton = NO;
    self.navigationItem.rightBarButtonItem = rightBtn;
    if (viewIndex == 0)
        [addPersonView removeFromSuperview];
    else
        [updateClassView removeFromSuperview];
}

- (void)save{
    if (addPersonView.nameField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"姓名不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (addPersonView.personIDField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"学号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (addPersonView.imageV.image == nil) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"头像不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (doubleName == YES) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"该学号已存在！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        return;
    }
    
    [self saveImage:addPersonView.imageV.image];
    [self insertData];
    [self back];
}

- (void)update{
    if (changeImage == YES) {
        changeImage = NO;
        [self saveImage:updateClassView.imageV.image];
    }
    [self updateData];
    [self back];
}

- (void)insertData {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];
    [db beginTransaction];
    NSString *dbSex = [NSString string];
    NSString *dbType = [NSString string];
    NSString *dbNumName = [NSString string];
    NSString *newNum = [NSString string];
    if ([addPersonView.sexLabel.text isEqualToString:@"男"]){
        dbSex = @"1";
        dbNumName = @"boyNum";
        newNum = @([_classModel.boyNum integerValue] + 1).stringValue;
    }
    else{
        dbSex = @"0";
        dbNumName = @"girlNum";
        newNum = @([_classModel.girlNum integerValue] + 1).stringValue;
    }
    if ([addPersonView.typeLabel.text isEqualToString:@"班主任"])
        dbType = @"0";
    else if ([addPersonView.typeLabel.text isEqualToString:@"班长"])
        dbType = @"1";
    else if ([addPersonView.typeLabel.text isEqualToString:@"团支书"])
        dbType = @"2";
    else
        dbType = @"3";
    NSString *imageName = [NSString stringWithFormat:@"P%@",@(newestIndex)];
    [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO Person (classID, name, studentID, sex, birthday, address, phoneNum, shortPhoneNum, QQ, email, type, imageUrl) VALUES ('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", _classModel.classID, addPersonView.nameField.text,  addPersonView.personIDField.text, dbSex, addPersonView.birthdayLabel.text, addPersonView.addressField.text, addPersonView.phoneNumField.text, addPersonView.shortPhoneNumField.text, addPersonView.QQField.text, addPersonView.emailFiled.text, dbType, imageName]];
    
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE Class SET %@ = '%@' WHERE classID = %@",dbNumName,newNum,_classModel.classID]];
    
    [db commit];
    [db close];
    
    personModel *newModel = [[personModel alloc] init];
    [newModel setValue:@(newestIndex) forKey:@"PIndex"];
    newModel.classID = _classModel.classID;
    newModel.name = addPersonView.nameField.text;
    newModel.studentID = addPersonView.personIDField.text;
    newModel.sex = [addPersonView.sexLabel.text isEqualToString:@"男"]?@"1":@"0";
    newModel.birthday = addPersonView.birthdayLabel.text;
    newModel.address = addPersonView.addressField.text;
    newModel.phoneNum = addPersonView.phoneNumField.text;
    newModel.shortPhoneNum = addPersonView.shortPhoneNumField.text;
    newModel.QQ = addPersonView.QQField.text;
    newModel.email = addPersonView.emailFiled.text;
    newModel.type = [addPersonView.typeLabel.text isEqualToString:@"班长"]?@"1":[addPersonView.typeLabel.text isEqualToString:@"团支书"]?@"2":@"3";
    newModel.imageUrl = imageName;
    
    NSMutableArray *newIndexPathArr = [[NSMutableArray alloc] initWithCapacity:2];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:_dataArray.count-1 inSection:0];
    [newIndexPathArr addObject:newIndexPath];

    [_dataArray addObject:newModel];
    [_collectionView insertItemsAtIndexPaths:newIndexPathArr];
    
    [_classModel setValue:newNum forKey:dbNumName];
    if (_delegate && [_delegate respondsToSelector:@selector(updateClass:)]) {
        [_delegate updateClass:_classModel];
    }
}

- (void)saveImage:(UIImage *)image{
    NSString *path_sandox = NSHomeDirectory();
    
    if (viewIndex == 0) {
        NSString *imageName = [NSString stringWithFormat:@"P%@",@(++newestIndex)];
        //设置一个图片的存储路径
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",imageName]];
        //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    }else{
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",_classModel.imageUrl]];
        if ([UIImage imageWithContentsOfFile:imagePath] != nil) {
            NSFileManager *delete = [NSFileManager defaultManager];
            [delete removeItemAtURL:[NSURL URLWithString:imagePath] error:nil];
        }
        [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    }
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
    changeImage = YES;
    if (viewIndex == 0)
        addPersonView.imageV.image = image;
    else
        updateClassView.imageV.image = image;
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

- (void)deleteData:(NSString *)studentID {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];
    BOOL res = [db executeUpdate:@"DELETE FROM Person WHERE studentID = ?",studentID];
    if (res == NO) {
        NSLog(@"数据删除失败");
    }else{
        NSLog(@"数据删除成功");
    }
    [db close];
}

- (void)updateData {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];
    [db beginTransaction];
    if (changeImage == YES) {
        [db executeUpdate:@"UPDATE Class SET imageUrl = ? WHERE classID = ?", [NSString stringWithFormat:@"C%@",@(_classModel.CIndex)],_classModel.classID];
    }
    NSLog(@"%@",[NSString stringWithFormat:@"UPDATE Class SET classID = '%@',introduction = '%@' WHERE classID = '%@'", updateClassView.classIDField.text, updateClassView.textView.text, _classModel.classID]);
    [db executeUpdate:[NSString stringWithFormat:@"UPDATE Class SET classID = '%@',introduction = '%@' WHERE classID = '%@'", updateClassView.classIDField.text, updateClassView.textView.text, _classModel.classID]];
    [db commit];
    [db close];
    
    [_classModel setValue:updateClassView.classIDField.text forKey:@"classID"];
    [_classModel setValue:updateClassView.textView.text forKey:@"introduction"];
    if (_delegate && [_delegate respondsToSelector:@selector(updateClass:)]) {
        [_delegate updateClass:_classModel];
    }
}

-(void)QueryData {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];

    FMResultSet *rs = [db executeQuery:@"SELECT * FROM Person where classID = ? order by type",_classModel.classID];
    while ([rs next]){
        personModel *model = [[personModel alloc]init];
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
        [_dataArray addObject: model];
    }
    [rs close];
    FMResultSet *rs1 = [db executeQuery:@"Select MAX(PIndex) from Person"];
    while ([rs1 next])
        newestIndex = [rs1 intForColumnIndex:0];
    
    [rs1 close];
    [db close];

    _mynick.text = ((personModel *)_dataArray[0]).name;
    if (((personModel *)_dataArray[0]).imageUrl != nil) {
        NSString *path_sandox = NSHomeDirectory();
        //设置一个图片的存储路径
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",((personModel *)_dataArray[0]).imageUrl]];
        _headImageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    [_collectionView reloadData];
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if (searchController.active == NO) {
        [_collectionView reloadData];
    }
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchArray removeAllObjects];
    NSString *string = [searchBar text];
    for (personModel *model in _dataArray) {
        if ([model.type isEqualToString:@"0"]) {//班主任不在搜索范围内
            continue;
        }
        unsigned int outCount, i;
        objc_property_t *properties = class_copyPropertyList([model class], &outCount);
        for (i = 0; i<outCount; i++)
        {
            objc_property_t property = properties[i];
            const char* char_f = property_getName(property);
            NSString *propertyName = [NSString stringWithUTF8String:char_f];
            if ([propertyName isEqualToString:@"PIndex"]) //PIndex不在搜索范围
                continue;
            id propertyValue = [model valueForKey:(NSString *)propertyName];
            if ([propertyValue rangeOfString:string].location != NSNotFound) {
                [searchArray addObject:model];
                break;
            }
        }
        free(properties);
    }
    [_collectionView reloadData];
}

//- (void)searchBar{
//    [_collectionView reloadData];
//}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == addPersonView.personIDField) {
        for (personModel *model in _dataArray) {
            if ([model.studentID isEqualToString:textField.text]) {
                [[[UIAlertView alloc] initWithTitle:nil message:@"该学号已存在！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
                doubleName = YES;
            }
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
