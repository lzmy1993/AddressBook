//
//  EditImageViewController.h
//  testApp
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditImageViewControllerDelegate<NSObject>
- (void) finishedEdittingImages:(NSMutableArray *)array;
@end
@interface EditImageViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<EditImageViewControllerDelegate> delegate;
@end
