//
//  RootViewController
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "RootViewController.h"
#import "AcademyCollectionViewCell.h"
#import "LineLayout.h"
#import "ClassViewController.h"
#import "AddClassView.h"
#import "ZYQAssetPickerController.h"
#import "EditImageViewController.h"

@interface RootViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, UINavigationControllerDelegate, EditImageViewControllerDelegate, UITextFieldDelegate, ClassViewControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>{
    NSMutableArray *dataSourceArray;
    NSMutableArray *classIDArray;
    NSMutableArray *searchArray;
    
    UIBarButtonItem *rightBtn;
    AddClassView *addView;
    UIImagePickerController *imagePicker;
    BOOL doubleName;
    UISearchController *searchVC;
    
    NSInteger newestIndex;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated{
    rightBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doMore)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"通讯录"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImageView *bgImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    [bgImageV setImage:[UIImage imageNamed:@"bg4.jpg"]];
    [self.view addSubview:bgImageV];
    
    dataSourceArray = [[NSMutableArray alloc]initWithCapacity:0];
    classIDArray = [[NSMutableArray alloc] initWithCapacity:0];
    searchArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self QueryData];
    [self loadSubView];
}

- (void)loadSubView{
    LineLayout *flowLayout = [[LineLayout alloc]init];
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view)) collectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.contentInset = UIEdgeInsetsMake(0, 80, 0, 80);
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[AcademyCollectionViewCell class] forCellWithReuseIdentifier:@"cellID"];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteClass:)];
    lpgr.minimumPressDuration = 1.0;
    [_collectionView addGestureRecognizer:lpgr];
    
    searchVC = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchVC.dimsBackgroundDuringPresentation = NO;
    searchVC.hidesNavigationBarDuringPresentation = YES;
    searchVC.searchBar.frame = CGRectMake(0, 0, WIDTH(self.view), 44);
    searchVC.searchResultsUpdater =self;
    searchVC.searchBar.delegate = self;
    searchVC.searchBar.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:searchVC.searchBar];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (searchVC.active) {
        return searchArray.count;
    }
    return dataSourceArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AcademyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellID" forIndexPath:indexPath];
    if (searchVC.active)
        [cell showWithModel:searchArray[indexPath.row]];
    else
        [cell showWithModel:dataSourceArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ClassViewController *classVC = [[ClassViewController alloc]init];
    if (searchVC.active)
        classVC.classModel = ((classModel *)searchArray[indexPath.row]);
    else
        classVC.classModel = ((classModel *)dataSourceArray[indexPath.row]);
    classVC.delegate = self;
    [self.navigationController pushViewController:classVC animated:YES];
    searchVC.active = NO;
}

- (void)deleteClass:(UILongPressGestureRecognizer *)press{
    if (searchVC.active) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"查找条件下无法进行删除操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    CGPoint p = [press locationInView:_collectionView];
    NSIndexPath *indexPath = [_collectionView indexPathForItemAtPoint:p];
    if (indexPath != nil) {
        UIAlertController *deleteAC = [UIAlertController alertControllerWithTitle:nil message:@"确认删除该班级所有信息？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self deleteData:((classModel *)dataSourceArray[indexPath.row]).classID];
            [dataSourceArray removeObjectAtIndex:indexPath.row];
            [_collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        }];
        
        [deleteAC addAction:cancel];
        [deleteAC addAction:ok];
        [self presentViewController:deleteAC animated:YES completion:nil];
    }
}

- (void)deleteData:(NSString *)classID {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];
    [db executeUpdate:@"DELETE FROM Class WHERE classID = ?",classID];
    BOOL res = [db executeUpdate:@"DELETE FROM Person WHERE classID = ?",classID];
    if (res == NO) {
        NSLog(@"数据删除失败");
    }else{
        NSLog(@"数据删除成功");
    }
    [db close];
}

- (void)QueryData {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM Class"];
    while ([rs next]){
        classModel *model = [[classModel alloc]init];
        model.CIndex = [rs intForColumn:@"CIndex"];
        model.classID = [rs stringForColumn:@"classID"];
        model.introduction = [rs stringForColumn:@"introduction"];
        model.boyNum = [NSNumber numberWithInteger:[rs intForColumn:@"boyNum"]];
        model.girlNum = [NSNumber numberWithInteger:[rs intForColumn:@"girlNum"]];
        model.imageUrl = [rs stringForColumn:@"imageUrl"];
        [dataSourceArray addObject: model];
        [classIDArray addObject:model.classID];
    }
    newestIndex = ((classModel *)[dataSourceArray lastObject]).CIndex;
    [rs close];
    [db close];
    [_collectionView reloadData];
}

- (void)insertData {
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    FMDatabase *db = [FMDatabase databaseWithPath:myDelegate.dbPath];
    [db open];
    [db beginTransaction];
    
    [db executeUpdate:@"INSERT INTO Class (classID, introduction, boyNum, girlNum, imageUrl) VALUES (?, ?, ?, ?, ?)", addView.classIDField.text, addView.textView.text, @"1", @"0", [NSString stringWithFormat:@"C%@",@(newestIndex)]];
    [db executeUpdate:@"INSERT INTO Person (classID, studentID, name, sex, type) VALUES (?, ?, ?, ?, ?)",addView.classIDField.text, addView.classIDField.text, @"班主任", @"1", @"0"];
    
    [db commit];
    [db close];
    
    classModel *newModel = [[classModel alloc] init];
    [newModel setValue:@(newestIndex) forKey:@"CIndex"];
    newModel.classID = addView.classIDField.text;
    newModel.introduction = addView.textView.text;
    newModel.boyNum = @(1);
    newModel.girlNum = @(0);
    newModel.imageUrl = [NSString stringWithFormat:@"C%@",@(newestIndex)];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:dataSourceArray.count inSection:0];
    [dataSourceArray addObject:newModel];
    [classIDArray addObject:newModel.classID];
    [_collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
}

- (void)doMore{
    self.navigationItem.rightBarButtonItem = nil;
    self.title = @"添加新班级";
    
    addView = [[AddClassView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    [self.view addSubview:addView];
    
    addView.classIDField.delegate = self;
    [addView.cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [addView.saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
    [addView.imageV addGestureRecognizer:tap];
    
    addView.alpha = 0;
    [UIView animateWithDuration:1 animations:^{
        addView.alpha = 1;
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    doubleName = NO;
    for (classModel *model in dataSourceArray) {
        if ([model.classID isEqualToString:textField.text]) {
            [[[UIAlertView alloc] initWithTitle:nil message:@"该班级号已存在！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
            doubleName = YES;
        }
    }
}

- (void)back {
    self.title = @"通讯录";
    self.navigationItem.rightBarButtonItem = rightBtn;
    [addView removeFromSuperview];
}

- (void)save {
    if (addView.classIDField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"班级号不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (addView.textView.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"班级简介不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (addView.imageV.image == nil) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"班级头像不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    if (doubleName == YES) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"该班级号已存在！" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil] show];
        return;
    }
    
    [self saveImage:addView.imageV.image];
    [self insertData];
    [self back];
}

- (void)saveImage:(UIImage *)image{
    //拿到班级号
    NSString *imageName = [NSString stringWithFormat:@"C%@",@(++newestIndex)];
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",imageName]];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
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
    addView.imageV.image = image;
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

#pragma mark - ClassViewControllerDelegate
- (void)updateClass:(classModel *)model {
    for(int i = 0; i < dataSourceArray.count; i++){
        classModel *originModel = [dataSourceArray objectAtIndex:i];
        if ([originModel.classID isEqualToString:model.classID]) {
            [dataSourceArray replaceObjectAtIndex:i withObject:model];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [_collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        }
    }
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [searchArray removeAllObjects];
    
    NSString *filterString = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[classIDArray filteredArrayUsingPredicate:predicate]];
    
    for (NSString *classID in array) {
        for (classModel *model in dataSourceArray) {
            if ([classID isEqualToString:model.classID]) {
                [searchArray addObject:model];
            }
        }
    }
    [_collectionView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"ss");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
