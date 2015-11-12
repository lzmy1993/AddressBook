//
//  PersonViewController.m
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PersonViewController.h"
#import <MessageUI/MessageUI.h>
#import "editViewController.h"
@interface PersonViewController ()<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,editViewControllerDelegate>{
    NSArray *titleArray;
    UIImageView *headImageV;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"个人信息";
    
    titleArray = @[@"姓名",@"手机",@"短号",@"QQ",@"邮箱",@"班级",@"学号",@"性别",@"地址",@"生日",@"类型",@"分享",@"删除联系人"];
    
    [self loadSubView];
    // Do any additional setup after loading the view.
}

- (void)loadSubView{
    UIScrollView *bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(self.view), HEIGHT(self.view))];
    bgScrollView.contentSize = CGSizeMake(WIDTH(bgScrollView), 1.2*HEIGHT(bgScrollView));
    [self.view addSubview:bgScrollView];
    
    headImageV = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH(self.view) - 80)/2, 5, 80, 80)];
    headImageV.backgroundColor = [UIColor redColor];
    headImageV.layer.cornerRadius = WIDTH(headImageV)/2.f;
    headImageV.layer.masksToBounds = YES;
    headImageV.userInteractionEnabled = YES;
    [bgScrollView addSubview:headImageV];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
    [headImageV addGestureRecognizer:tap];
    
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",_model.imageUrl]];
    headImageV.image = [UIImage imageWithContentsOfFile:imagePath];
    
    
    UIImageView *sex = [[UIImageView alloc]initWithFrame:CGRectMake((WIDTH(self.view) - 12)/2, VIEW_Y(headImageV)+HEIGHT(headImageV) + 5, 12, 12)];
    if ([_model.sex isEqualToString:@"1"]) {
        sex.image = [UIImage imageNamed:@"iconfont-nan"];
    }else{
        sex.image = [UIImage imageNamed:@"iconfont-nv"];
    }
    [bgScrollView addSubview:sex];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, WIDTH(self.view), HEIGHT(bgScrollView))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [bgScrollView addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [titleArray count] - 2;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    
    [cell.contentView removeAllSubviews];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 6 && [_model.type isEqualToString:@"0"])
            cell.textLabel.text =@"工号";
        else
            cell.textLabel.text = titleArray[indexPath.row];
    }else{
        cell.textLabel.text = titleArray[indexPath.row + 11];
    }

    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(65, (cellHeight - 20)/2, WIDTH(tableView)-100, 20)];
    [cell.contentView addSubview:detail];
    
    detail.textColor = [UIColor grayColor];
    detail.font = [UIFont systemFontOfSize:15.f];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        if (indexPath.row == 0) {
            detail.text = _model.name;
        }else if (indexPath.row == 1) {
            detail.text = _model.phoneNum;
        }else if (indexPath.row == 2){
            detail.text = _model.shortPhoneNum;
        }else if (indexPath.row == 3){
            detail.text = _model.QQ;
        }else if (indexPath.row == 4){
            detail.text = _model.email;
        }else if (indexPath.row == 5){
            detail.text = _model.classID;
            if ([_model.type isEqualToString:@"0"]) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else if (indexPath.row == 6){
            detail.text = _model.studentID;
        }else if (indexPath.row == 7){
            detail.text = [_model.sex isEqualToString:@"0"]? @"女":@"男";
        }else if (indexPath.row == 8){
            detail.text = _model.address;
        }else if (indexPath.row == 9){
            detail.text = _model.birthday;
        }else{
            detail.text = [self typeNameFromDBName:_model.type];
            if ([_model.type isEqualToString:@"0"]) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }else{
        if (indexPath.row == 0){
            cell.textLabel.textColor = [UIColor blueColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }else{
            cell.textLabel.textColor = [UIColor redColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UIAlertController *callAC = [UIAlertController alertControllerWithTitle:@"请选择联系方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *phone = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self callPhone:_model.phoneNum];
            }];
            UIAlertAction *message = [UIAlertAction actionWithTitle:@"发短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (_model.phoneNum.length == 0) {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"该成员未填写号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    return;
                }
                [self sendMessage:[NSArray arrayWithObject:_model.phoneNum]];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [callAC addAction:phone];
            [callAC addAction:message];
            [callAC addAction:cancel];

            [self presentViewController:callAC animated:YES completion:nil];
        }
        if (indexPath.row == 2) {
            UIAlertController *callAC = [UIAlertController alertControllerWithTitle:@"请选择联系方式" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *phone = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self callPhone:_model.shortPhoneNum];
            }];
            UIAlertAction *message = [UIAlertAction actionWithTitle:@"发短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (_model.shortPhoneNum.length == 0) {
                    [[[UIAlertView alloc] initWithTitle:nil message:@"该成员未填写号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                    return;
                }
                [self sendMessage:[NSArray arrayWithObject:_model.shortPhoneNum]];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

            [callAC addAction:phone];
            [callAC addAction:message];
            [callAC addAction:cancel];
            [self presentViewController:callAC animated:YES completion:nil];
        }
        if (indexPath.row == 4) {
            if (_model.email.length == 0) {
                [[[UIAlertView alloc] initWithTitle:nil message:@"该成员未填写邮箱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            [self sendEmail:[NSArray arrayWithObject:_model.email]];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UIAlertController *shareAC = [UIAlertController alertControllerWithTitle:@"分享" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *messageAction = [UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self sendMessage:nil];
            }];
            UIAlertAction *emailAction = [UIAlertAction actionWithTitle:@"邮箱" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self sendEmail:nil];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [shareAC addAction:messageAction];
            [shareAC addAction:emailAction];
            [shareAC addAction:cancel];
            [self presentViewController:shareAC animated:YES completion:nil];
        }else if (indexPath.row == 1) {
            if ([_model.type isEqualToString:@"0"]) {
                [[[UIAlertView alloc] initWithTitle:nil message:@"班主任不能删除" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
                return;
            }
            UIAlertController  *deleteAC = [UIAlertController alertControllerWithTitle:nil message:@"确认删除该联系人吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (_delegate && [_delegate respondsToSelector:@selector(updateView:withReason:isTeacher:)])
                    [_delegate updateView:_model withReason:1 isTeacher:NO];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [deleteAC addAction:ok];
            [deleteAC addAction:cancel];
            [self presentViewController:deleteAC animated:YES completion:nil];
        }
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        editViewController *editVC = [[editViewController alloc] init];
        if (indexPath.row == 0) {
            editVC.originData = _model.name;
            editVC.dbCode = @"name";
        }
        else if (indexPath.row == 1) {
            editVC.originData = _model.phoneNum;
            editVC.dbCode = @"phoneNum";
        }else if (indexPath.row == 2){
            editVC.originData = _model.shortPhoneNum;
            editVC.dbCode = @"shortPhoneNum";
        }else if (indexPath.row == 3){
            editVC.originData = _model.QQ;
            editVC.dbCode = @"QQ";
        }else if (indexPath.row == 4){
            editVC.originData = _model.email;
            editVC.dbCode = @"email";
        }else if (indexPath.row == 5){
            editVC.originData = _model.classID;
            editVC.dbCode = @"classID";
        }else if (indexPath.row == 6){
            editVC.originData= _model.studentID;
            editVC.dbCode = @"studentID";
        }else if (indexPath.row == 7){
            editVC.originData = [_model.sex isEqualToString:@"0"]? @"女":@"男";
            editVC.dbCode = @"sex";
        }else if (indexPath.row == 8){
            editVC.originData = _model.address;
            editVC.dbCode = @"address";
        }else if (indexPath.row == 9){
            editVC.originData = _model.birthday;
            editVC.dbCode = @"birthday";
        }else if (indexPath.row == 10){
            editVC.originData = [self typeNameFromDBName:_model.type];
            editVC.dbCode = @"type";
        }
        editVC.studentID = _model.studentID;
        editVC.classID = _model.classID;
        editVC.delegate = self;
        editVC.PIndex = _model.PIndex;
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

- (void)choosePhoto{
    editViewController *editVC = [[editViewController alloc] init];
    editVC.originData = _model.imageUrl;
    editVC.dbCode = @"imageUrl";
    editVC.studentID = _model.studentID;
    editVC.classID = _model.classID;
    editVC.delegate = self;
    editVC.PIndex = _model.PIndex;
    [self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - editViewControllerDelegate
- (void)updateView:(personModel *)model{
    NSInteger reason;
    if (![_model.classID isEqualToString:model.classID]) {
        reason = 2;
    }else
        reason = 0;
    
    _model = model;
    if (model.imageUrl.length != 0) {
        NSString *path_sandox = NSHomeDirectory();
        //设置一个图片的存储路径
        NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.png",model.imageUrl]];
        headImageV.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    [_tableView reloadData];
    
    if (_delegate && [_delegate respondsToSelector:@selector(updateView:withReason:isTeacher:)])
        [_delegate updateView:model withReason:reason isTeacher:[model.type isEqualToString:@"0"]];
}

- (void)callPhone:(NSString *)phoneNum{
    if (phoneNum.length == 0) {
        [[[UIAlertView alloc] initWithTitle:nil message:@"该成员未填写号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        return;
    }
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@",phoneNum];
    UIWebView *callWebView = [[UIWebView alloc]init];
    [callWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phoneStr]]];
    [self.view addSubview:callWebView];
}

- (void)sendMessage:(NSArray *)phoneNums{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc]init];
        if (phoneNums == nil) {
            messageVC.body = [NSString stringWithFormat:@"姓名:%@  性别:%@  长号:%@  短号:%@",_model.name,[_model.sex isEqualToString:@"0"]? @"女":@"男",_model.phoneNum,_model.shortPhoneNum];
        }else
            messageVC.recipients = phoneNums;
        messageVC.messageComposeDelegate = self;
        
        [self presentViewController:messageVC animated:YES completion:nil];
        
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"短信功能不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    NSLog(@"%d",result);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MessageComposeResultCancelled:
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送取消" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            break;
        case MessageComposeResultFailed:
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            break;
        case MessageComposeResultSent:
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            break;
        default:
            break;
    }
}

- (void)sendEmail:(NSArray *)emails{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        [mailVC setSubject:@"分享"];
        [mailVC setToRecipients:emails];
        [mailVC setMessageBody:[NSString stringWithFormat:@"姓名:%@  性别:%@  长号:%@  短号:%@",_model.name,[_model.sex isEqualToString:@"0"]? @"女":@"男",_model.phoneNum,_model.shortPhoneNum] isHTML:YES];
        
//        UIImage *image = [UIImage imageNamed:@"头像1.png"];
//        NSData *imageData = UIImagePNGRepresentation(image);
//        // 1> 附件的二进制数据
//        // 2> MIMEType 使用什么应用程序打开附件
//        // 3> 收件人接收时看到的文件名称
//        // 可以添加多个附件
//        [mailVC addAttachmentData:imageData mimeType:@"image/png" fileName:@"头像.png"];
        
        // 7) 设置代理
        [mailVC setMailComposeDelegate:self];
        
        // 显示控制器
        [self presentViewController:mailVC animated:YES completion:nil];
    }else{
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"请前往手机邮箱设置自己的邮箱地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    NSLog(@"%d",result);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    switch (result) {
        case MFMailComposeResultCancelled:
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送取消" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            break;
        case MFMailComposeResultFailed:
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            break;
        case MFMailComposeResultSaved:
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            break;
        case MFMailComposeResultSent:
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
            break;
        default:
            break;
    }
}

- (NSString *)typeNameFromDBName:(NSString *)dbName{
    if ([dbName isEqualToString:@"0"])
        return @"班主任";
    else  if ([dbName isEqualToString:@"1"])
        return @"班长";
    else  if ([dbName isEqualToString:@"2"])
        return @"团支书";
    else
        return @"普通成员";
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
