//
//  XLTolls.h
//  Voucher
//
//  Created by xie liang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLTools : NSObject

+ (NSString *)getInterfaceByKey:(NSString *)key;

+ (void)saveUserInfo:(NSDictionary *)userInfo;
+ (NSDictionary *)getUserInfo;
+ (void)deleteUserInfo;
+ (BOOL)isLogin;

+ (void)saveCityInfo:(NSDictionary *)dic;
+ (NSDictionary *)getCityInfo;

@end
