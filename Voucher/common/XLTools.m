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
        return YES;
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

+ (void)deleteCityInfo
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"cityInfo"];
    [def synchronize];
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String]; 
    unsigned char result[32]; 
    
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); 
    
    return [NSString stringWithFormat: 
            
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            
            result[0], result[1], result[2], result[3], 
            
            result[4], result[5], result[6], result[7], 
            
            result[8], result[9], result[10], result[11], 
            
            result[12], result[13], result[14], result[15] 
            
            ];
}

+ (NSString *)cachePath
{
    return [NSString stringWithFormat:@"%@/cacheDir",[XLTools getUserDocumentPath]];
}

+ (void)createCacheDir
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:[XLTools cachePath]]) {
        [manager createDirectoryAtPath:[XLTools cachePath] 
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
}

+ (void)deleteCacheDir
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:[XLTools cachePath]]) {
        [manager removeItemAtPath:[XLTools cachePath] error:nil];
    }
}

+ (void)saveFileToCache:(NSData *)data withName:(NSString *)name
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[XLTools cachePath],name];
    [data writeToFile:path atomically:YES];
}

+ (NSData *)readFileToCache:(NSString *)name
{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[XLTools cachePath],name];
    return [NSData dataWithContentsOfFile:path];
}

+ (void)saveUserLocation:(NSDictionary *)location
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setValue:location forKey:@"location"];
    [def synchronize];
}

+ (NSDictionary *)userLocation
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *loc = [def objectForKey:@"location"];
    return loc;
}

@end
