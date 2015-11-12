//
//  classModel.h
//  AddressBook
//
//  Created by apple on 15/9/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface classModel : NSObject
@property (nonatomic, assign) NSInteger CIndex;
@property (nonatomic, copy) NSString *classID;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSNumber *boyNum;
@property (nonatomic, copy) NSNumber *girlNum;
@property (nonatomic, copy) NSString *imageUrl;
@end
