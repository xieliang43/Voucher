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

+ (NSString *)getUserDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (void)writeMerchantTypeToFile:(NSArray *)arr
{
    NSString *merchantTypeFile = [NSString stringWithFormat:@"%@/merchantTypeArray.plist",[XLTools getUserDocumentPath]];
    [arr writeToFile:merchantTypeFile atomically:YES];
}

+ (NSArray *)readMerchantType
{
    NSString *merchantTypeFile = [NSString stringWithFormat:@"%@/merchantTypeArray.plist",[XLTools getUserDocumentPath]];
    return [NSArray arrayWithContentsOfFile:merchantTypeFile];
}

+ (void)writeDistanceTypeToFile:(NSArray *)arr
{
    NSString *distanceTypeFile = [NSString stringWithFormat:@"%@/distanceTypeArray.plist",[XLTools getUserDocumentPath]];
    [arr writeToFile:distanceTypeFile atomically:YES];
}

+ (NSArray *)readDistanceType
{
    NSString *distanceTypeFile = [NSString stringWithFormat:@"%@/distanceTypeArray.plist",[XLTools getUserDocumentPath]];
    return [NSArray arrayWithContentsOfFile:distanceTypeFile];
}

+ (void)writeAreaTypeToFile:(NSArray *)arr
{
    NSString *areaTypeFile = [NSString stringWithFormat:@"%@/areaTypeArray.plist",[XLTools getUserDocumentPath]];
    [arr writeToFile:areaTypeFile atomically:YES];
}

+ (NSArray *)readAreaType
{
    NSString *areaTypeFile = [NSString stringWithFormat:@"%@/areaTypeArray.plist",[XLTools getUserDocumentPath]];
    return [NSArray arrayWithContentsOfFile:areaTypeFile];
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
