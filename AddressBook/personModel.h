//
//  personModel.h
//  AddressBook
//
//  Created by apple on 15/9/6.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personModel : NSObject
@property (nonatomic, assign) NSInteger PIndex;
@property (nonatomic, copy) NSString *classID;
@property (nonatomic, copy) NSString *studentID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *shortPhoneNum;
@property (nonatomic, copy) NSString *QQ;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *imageUrl;

- (NSArray *)getAllProperties;
- (NSDictionary *)properties_aps;
- (void)printMothList;
@end
