//
//  XLTolls.m
//  Voucher
//
//  Created by xie liang on 12-7-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "XLTools.h"

@implementation XLTools

+ (NSString *)getInterfaceByKey:(NSString *)key
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"interface" 
                                                                                                   ofType:@"plist"]];
    return [NSString stringWithFormat:@"%@/%@",baseUrl,[dic objectForKey:key]];
}

+ (void)saveUserInfo:(NSDictionary *)userInfo
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:userInfo forKey:@"userInfo"];
    [def synchronize];
}

+ (NSDictionary *)getUserInfo
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"userInfo"];
}

+ (void)deleteUserInfo
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"userInfo"];
    [def synchronize];
}

+ (BOOL)isLogin
{
    NSDictionary *dic = [XLTools getUserInfo];
    if (dic) {
        return YES;
    }else {
        return NO;
    }
}

+ (void)saveCityInfo:(NSDictionary *)dic
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:dic forKey:@"cityInfo"];
    [def synchronize];
}

+ (NSDictionary *)getCityInfo
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"cityInfo"];
}

@end
