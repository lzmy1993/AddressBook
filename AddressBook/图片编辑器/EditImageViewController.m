//
//  EditImageViewController.m
//  testApp
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "EditImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZYQAssetPickerController.h"
#import "UIColor+AddColor.h"
#define THUMBNAILWIDTH   50
#define THUMBNAILHEIGHT  50
#define THUMBNAILSPACE   10
#define MASK_HEIGHT      50
#define CUT_VIEW_WIDTH   (SCREEN_WIDTH - 20)
@interface EditImageViewController (){
    int index;
    UIImageOrientation imageOrientation;
    CGPoint relativeCenter;
    
    NSMutableArray *resultArray;
    NSMutableArray *imageVArray;
    UIScrollView *backScrollView;
    UIScrollView *headScroll;
    UIImageView *imageView;
    
    UIButton *previousBtn;
    UIButton *nextBtn;
    UIButton *rotationBtn;
    
    UIView *topMaskView;
    UIView *topLine;
    UIView *bottomMaskView;
    UIView *bottomLine;
    UIView *leftMaskView;
    UIView *leftLine;
    UIView *rightMaskView;
    UIView *rightLine;
}

@end

@implementation EditImageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //容器为UINavigationController时，使用该句话，解决偏移问题
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 64)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    [backScrollView addSubview:headView];
    
    headScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(40, 0, SCREEN_WIDTH-60, 64)];
    headScroll.contentSize = CGSizeMake(_imagesArray.count * (THUMBNAILHEIGHT + THUMBNAILSPACE) + 20 , 64);
    headScroll.showsHorizontalScrollIndicator = NO;
    headScroll.showsVerticalScrollIndicator = NO;
    headScroll.scrollEnabled = NO;
    [headView addSubview:headScroll];
    
    imageVArray = [NSMutableArray array];
    for (int i = 0; i<_imagesArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithImage:_imagesArray[i]];
        imageV.frame = CGRectMake(10+(THUMBNAILWIDTH+THUMBNAILSPACE)*i, 10, THUMBNAILWIDTH, THUMBNAILHEIGHT);
        imageV.layer.borderColor = [UIColor colorWithHexString:@"#ff5959"].CGColor;
        imageV.userInteractionEnabled = YES;
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [imageVArray addObject:imageV];
        [headScroll addSubview:imageV];
    }
    ((UIImageView *)imageVArray[0]).layer.borderWidth = 1.f;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setFrame:CGRectMake(10, 24, 16, 16)];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cut_back"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelCropping) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:cancelBtn];
    
    topMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH,MASK_HEIGHT)];
    [topMaskView setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
    [backScrollView addSubview:topMaskView];
    
    bottomMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_Y(topMaskView)+HEIGHT(topMaskView)+ CUT_VIEW_WIDTH, SCREEN_WIDTH, MASK_HEIGHT)];
    [bottomMaskView setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
    [backScrollView addSubview:bottomMaskView];
    
    leftMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, VIEW_Y(topMaskView)+HEIGHT(topMaskView), 10, CUT_VIEW_WIDTH)];
    [leftMaskView setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
    [backScrollView addSubview:leftMaskView];
    
    rightMaskView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10, VIEW_Y(topMaskView)+HEIGHT(topMaskView), 10, CUT_VIEW_WIDTH)];
    [rightMaskView setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.5]];
    [backScrollView addSubview:rightMaskView];
    
    topLine = [[UIView alloc]initWithFrame:CGRectMake(10, 84+MASK_HEIGHT, SCREEN_WIDTH-20, 1)];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#ffc028"];
    [backScrollView addSubview:topLine];
    
    bottomLine = [[UIView alloc]initWithFrame:CGRectMake(10, 84+MASK_HEIGHT+CUT_VIEW_WIDTH, SCREEN_WIDTH-20, 1)];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#ffc028"];
    [backScrollView addSubview:bottomLine];
    
    leftLine = [[UIView alloc]initWithFrame:CGRectMake(10, 84+MASK_HEIGHT, 1, CUT_VIEW_WIDTH)];
    leftLine.backgroundColor = [UIColor colorWithHexString:@"#ffc028"];
    [backScrollView addSubview:leftLine];
    
    rightLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10, 84+MASK_HEIGHT, 1, CUT_VIEW_WIDTH)];
    rightLine.backgroundColor = [UIColor colorWithHexString:@"#ffc028"];
    [backScrollView addSubview:rightLine];
    
    
    rotationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rotationBtn setFrame:CGRectMake(CUT_VIEW_WIDTH-20, 10, 30, 30)];
    [rotationBtn setBackgroundImage:[UIImage imageNamed:@"rotation"] forState:UIControlStateNormal];
    [rotationBtn addTarget:self action:@selector(rotation) forControlEvents:UIControlEventTouchUpInside];
    [bottomMaskView addSubview:rotationBtn];
    
    CGFloat width = 252 / 2;
    CGFloat height = 88 / 2;
    CGFloat space = 68 / 2;
    
    previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [previousBtn setFrame:CGRectMake((SCREEN_WIDTH-space)/2-width, VIEW_Y(bottomMaskView)+HEIGHT(bottomMaskView)+20, width, height)];
    [previousBtn setTitle:@"上一张" forState:UIControlStateNormal];
    [previousBtn setBackgroundColor:[UIColor colorWithHexString:@"#ffc028"]];
    [previousBtn addTarget:self action:@selector(previousCropping) forControlEvents:UIControlEventTouchUpInside];
    previousBtn.hidden = YES;
    previousBtn.layer.cornerRadius = 5.f;
    previousBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backScrollView addSubview:previousBtn];

    nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake((SCREEN_WIDTH - width)/2, VIEW_Y(bottomMaskView)+HEIGHT(bottomMaskView)+20, width, height)];
    [nextBtn setTitle:(index == [_imagesArray count]-1?@"下一步":@"下一张") forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:[UIColor colorWithHexString:@"#ff5959"]];
    [nextBtn addTarget:self action:@selector(nextCropping) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 5.f;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [backScrollView addSubview:nextBtn];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backScrollView.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    backScrollView.showsHorizontalScrollIndicator = NO;
    backScrollView.showsVerticalScrollIndicator = NO;
    backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 1.2);
    [self.view addSubview:backScrollView];

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 84, SCREEN_WIDTH, 2 * MASK_HEIGHT + CUT_VIEW_WIDTH);
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setDelegate:self];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setMaximumZoomScale:3.0];
    [backScrollView addSubview:_scrollView];
    
    index = 0;
    [self loadUI];
    resultArray = [[NSMutableArray alloc]initWithCapacity:3];
}
-(void)loadUI{
    //旋转角度，每张图都要重新初始化
    imageOrientation = UIImageOrientationUp;
    //缩略图选中效果
    for (UIImageView *imageV in imageVArray) {
        imageV.layer.borderWidth = 0.0f;
    }
    ((UIImageView *)imageVArray[index]).layer.borderWidth = 1.f;
    
    //上一张和下一张按钮位置变化
    CGFloat width = 252 / 2;
    CGFloat height = 88 / 2;
    CGFloat space = 68 / 2;
    
    if(index == 0){
        previousBtn.hidden = YES;
        nextBtn.frame = CGRectMake((SCREEN_WIDTH - width)/2, VIEW_Y(bottomMaskView)+HEIGHT(bottomMaskView)+20, width, height);
    }else{
        previousBtn.hidden = NO;
        nextBtn.frame = CGRectMake((SCREEN_WIDTH + space) / 2, VIEW_Y(bottomMaskView)+HEIGHT(bottomMaskView)+20, width, height);
    }

    UIImage *image = _imagesArray[index];
    [self setImageViewWithImage:image];
    
    //scrollView重画后，再将蒙版放到最上面
    [backScrollView bringSubviewToFront:topMaskView];
    [backScrollView bringSubviewToFront:bottomMaskView];
    [backScrollView bringSubviewToFront:leftMaskView];
    [backScrollView bringSubviewToFront:rightMaskView];
    [backScrollView bringSubviewToFront:rotationBtn];
    [backScrollView bringSubviewToFront:topLine];
    [backScrollView bringSubviewToFront:bottomLine];
    [backScrollView bringSubviewToFront:leftLine];
    [backScrollView bringSubviewToFront:rightLine];

}
- (void)setImageViewWithImage:(UIImage *)image{
    if (imageView != nil) {
        imageView.image = nil;
        imageView = nil;
    }
    imageView = [[UIImageView alloc] init];
    imageView.image = image;
    
    CGRect rect;
    rect.size.width = image.size.width;
    rect.size.height = image.size.height;
    rect.origin.x    = 0.f;
    rect.origin.y    = 0.f;
    
    relativeCenter = CGPointMake(_scrollView.center.x - _scrollView.frame.origin.x, _scrollView.center.y - _scrollView.frame.origin.y);
    [imageView setFrame:rect];
    [_scrollView setContentSize:[imageView frame].size];
    
    if (image.size.width < image.size.height) {
        float scale = CUT_VIEW_WIDTH / image.size.width;
        [_scrollView setMinimumZoomScale:scale];
    }
    
    if (image.size.width == image.size.height) {
        float scale = CUT_VIEW_WIDTH / image.size.width;
        [_scrollView setMinimumZoomScale:scale];
    }
    
    if (image.size.width > image.size.height) {
        float scale = CUT_VIEW_WIDTH / image.size.height;
        [_scrollView setMinimumZoomScale:scale];
    }
    
    [_scrollView setZoomScale:[_scrollView minimumZoomScale]];
    imageView.center = relativeCenter;
    //居中显示
    _scrollView.contentOffset = CGPointMake(0, 0);
    
    [_scrollView addSubview:imageView];
}
- (void)cancelCropping {
    ZYQAssetPickerController *ZYQAssetPickerVC = (ZYQAssetPickerController *)[self.navigationController popViewControllerAnimated:YES];
    [ZYQAssetPickerVC.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)previousCropping {
    index--;
    [resultArray removeLastObject];
    
    //修改缩略图imagView大小和图片
    for (int i = index; i<_imagesArray.count; i++) {
        if (i == index) {
            ((UIImageView *)imageVArray[i]).frame = CGRectMake(10+(THUMBNAILHEIGHT+THUMBNAILSPACE)*i, 10, THUMBNAILWIDTH, THUMBNAILHEIGHT);
            ((UIImageView *)imageVArray[i]).image = _imagesArray[i];            //自动移动至选中图
            float correct_x = headScroll.contentOffset.x;
            float real_x = (THUMBNAILHEIGHT+THUMBNAILSPACE)*index+(THUMBNAILWIDTH+THUMBNAILSPACE)+10;
            if(correct_x > real_x){
                [headScroll setContentOffset:CGPointMake((THUMBNAILHEIGHT+THUMBNAILSPACE)*index+10, 0) animated:YES];
            }
        }else{
            ((UIImageView *)imageVArray[i]).frame = CGRectMake(10+(THUMBNAILHEIGHT+THUMBNAILSPACE)*index + (THUMBNAILWIDTH + THUMBNAILSPACE)*(i - index), 10, THUMBNAILWIDTH, THUMBNAILHEIGHT);
        }
    }
    //不是最后一张图时改变按钮标题
    [nextBtn setTitle:@"下一张" forState:UIControlStateNormal];
    [self loadUI];
}
- (void)nextCropping {
    //初始化变量
    CGFloat imageV_height = imageView.frame.size.height;
    CGFloat imageV_width = imageView.frame.size.width;
    CGFloat scrollView_off_x = [_scrollView contentOffset].x;
    CGFloat scrollView_off_y = [_scrollView contentOffset].y;
    CGFloat scrollView_width = _scrollView.frame.size.width;
    CGFloat scrollView_heigth = _scrollView.frame.size.height;
    
    //左右旋转时，3种坐标或长度交换: x<-->y、height<-->width
    if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationRight){
        imageV_height = imageV_height + imageV_width;
        imageV_width = imageV_height - imageV_width;
        imageV_height = imageV_height - imageV_width;
        
        scrollView_off_x = scrollView_off_x + scrollView_off_y;
        scrollView_off_y = scrollView_off_x - scrollView_off_y;
        scrollView_off_x = scrollView_off_x - scrollView_off_y;
        
        scrollView_heigth = scrollView_heigth + scrollView_width;
        scrollView_width = scrollView_heigth - scrollView_width;
        scrollView_heigth = scrollView_heigth - scrollView_width;
    }
    
    CGFloat space_height = (imageV_height - scrollView_heigth)/2;
    CGFloat space_width = (imageV_width - scrollView_width)/2;
    
    //定位坐标，类似四个象限
    if (imageOrientation == UIImageOrientationUp) {
        space_height = space_height + scrollView_off_y + MASK_HEIGHT;
        space_width = space_width + scrollView_off_x + 10;
    }
    else if (imageOrientation == UIImageOrientationRight) {
        space_height = space_height - scrollView_off_y + 10;
        space_width = space_width + scrollView_off_x + MASK_HEIGHT;
    }
    else if (imageOrientation == UIImageOrientationDown) {
        space_height = space_height - scrollView_off_y + MASK_HEIGHT;
        space_width = space_width - scrollView_off_x + 10;
    }else{
        space_height = space_height + scrollView_off_y + 10;
        space_width = space_width - scrollView_off_x + MASK_HEIGHT;
    }
    
    //计算截图范围
    CGRect cut_rect;
    float zoomScale_reciprocal = 1.0 / [_scrollView zoomScale];
    cut_rect.origin.x = fabs(space_width) * zoomScale_reciprocal;
    cut_rect.origin.y = fabs(space_height) * zoomScale_reciprocal;
    cut_rect.size.width = CUT_VIEW_WIDTH * zoomScale_reciprocal;
    cut_rect.size.height = CUT_VIEW_WIDTH * zoomScale_reciprocal;
    /*
     用下面的方法截的图还是截没有旋转过的原图（即使之前有旋转过），所以在截图前要做坐标转换，最后再旋转图片
     */
    CGImageRef cr = CGImageCreateWithImageInRect([[imageView image] CGImage], cut_rect);
    UIImage *cropped = [UIImage imageWithCGImage:cr scale:1 orientation:imageOrientation];
    CGImageRelease(cr);
    
    [resultArray addObject:cropped];
    index++;
    if (index == [_imagesArray count]) {
        if (_delegate && [_delegate respondsToSelector:@selector(finishedEdittingImages:)]) {
            [_delegate finishedEdittingImages:resultArray];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        //修改缩略图imagView大小和图片
        for (int i = index-1; i<_imagesArray.count; i++) {
            if (i == index-1) {
                ((UIImageView *)imageVArray[i]).frame = CGRectMake(10+(THUMBNAILHEIGHT+THUMBNAILSPACE)*i, 10, THUMBNAILHEIGHT, THUMBNAILHEIGHT);
                ((UIImageView *)imageVArray[i]).image = resultArray[i];
                //自动移动至选中图
                float correct_x = headScroll.contentOffset.x+headScroll.frame.size.width;
                float real_x = (THUMBNAILHEIGHT+THUMBNAILSPACE)*(index-1)+(THUMBNAILWIDTH+THUMBNAILSPACE)+10;
                if(correct_x < real_x){
                    [headScroll setContentOffset:CGPointMake(real_x-headScroll.frame.size.width+THUMBNAILWIDTH+THUMBNAILSPACE, 0) animated:YES];
                }
            }else{
                ((UIImageView *)imageVArray[i]).frame = CGRectMake(10+(THUMBNAILHEIGHT+THUMBNAILSPACE)*index + (THUMBNAILWIDTH + THUMBNAILSPACE)*(i - index), 10, THUMBNAILWIDTH, THUMBNAILHEIGHT);
            }
        }
        //最后一张图时改变按钮标题
        if (index == [_imagesArray count]-1) {
            [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        }
        [self loadUI];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    imageView.center = relativeCenter;
    scrollView.contentSize = imageView.frame.size;
    
    float space_height = (imageView.frame.size.height - _scrollView.frame.size.height)/2;
    float space_width = (imageView.frame.size.width - _scrollView.frame.size.width)/2;
    scrollView.contentInset = UIEdgeInsetsMake(space_height + MASK_HEIGHT, space_width+10, -space_height + MASK_HEIGHT, -space_width+10);
}
- (void)rotation{
    if (imageOrientation == UIImageOrientationUp) {
        imageOrientation = UIImageOrientationRight;
    }else if(imageOrientation == UIImageOrientationRight){
        imageOrientation = UIImageOrientationDown;
    }else if (imageOrientation == UIImageOrientationDown){
        imageOrientation = UIImageOrientationLeft;
    }else{
        imageOrientation = UIImageOrientationUp;
    }
    UIImage *rotated = [UIImage imageWithCGImage:[[imageView image] CGImage] scale:1 orientation:imageOrientation];
    [self setImageViewWithImage:rotated];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return imageView;
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
