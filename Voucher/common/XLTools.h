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

+ (NSString *)getUserDocumentPath;

+ (void)writeMerchantTypeToFile:(NSArray *)arr;
+ (NSArray *)readMerchantType;
+ (void)writeDistanceTypeToFile:(NSArray *)arr;
+ (NSArray *)readDistanceType;
+ (void)writeAreaTypeToFile:(NSArray *)arr;
+ (NSArray *)readAreaType;

+ (void)saveUserInfo:(NSDictionary *)userInfo;
+ (NSDictionary *)getUserInfo;
+ (void)deleteUserInfo;
+ (BOOL)isLogin;

+ (void)saveCityInfo:(NSDictionary *)dic;
+ (NSDictionary *)getCityInfo;
+ (void)deleteCityInfo;

@end
