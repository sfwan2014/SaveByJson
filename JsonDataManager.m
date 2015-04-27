//
//  JsonDataManager.m
//  YDYWBusiness
//
//  Created by wanshaofa on 15/4/27.
//  Copyright (c) 2015年 ydyw. All rights reserved.
//

#import "JsonDataManager.h"
#import "JSONKit.h"

@implementation JsonDataManager
// 获取沙盒路径
+(NSString *)homePath{
    //    NSString *path = NSHomeDirectory();//主目录
    //    NSLog(@"NSHomeDirectory:%@",path);
    //    NSString *userName = NSUserName();//与上面相同
    //    NSString *rootPath = NSHomeDirectoryForUser(userName);
    //    NSLog(@"NSHomeDirectoryForUser:%@",rootPath);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    //    NSLog(@"NSDocumentDirectory:%@",documentsDirectory);
    return documentsDirectory;
}
// 获取/创建 tmp 文件夹
+(NSString *)cachePath{
    NSString *cachePath = [NSString stringWithFormat:@"%@/%@", [self homePath], @"tmp"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:cachePath]) {
        NSError *createError = nil;
        [fm createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&createError];
        if (createError) {
            NSLog(@"create failed:  %@", createError);
        }
    }
    
    return cachePath;
}
// 获取/创建 json 存储的文件路径
+(NSString *)jsonPathWithName:(NSString *)name{
    NSString *jsonPath = @"";
    NSString *cachePath = self.cachePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    jsonPath = [NSString stringWithFormat:@"%@/%@", cachePath, name];
    if (![fm fileExistsAtPath:jsonPath]) {
        [fm createFileAtPath:jsonPath contents:nil attributes:nil];
    }
    
    return jsonPath;
}
// 读取 沙河路径的json文件数据 返回 NSData 类型
+(NSData *)readJsonDataWithName:(NSString *)name{
    NSString *jsonPath = [self jsonPathWithName:name];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    return data;
}
// 读取 沙河路径的json文件数据 返回NSString
+(NSString *)readJsonStringWithName:(NSString *)name{
    NSData *data = [self readJsonDataWithName:name];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}
// 写入数据 到json文件中
+(BOOL)writeDataToJsonData:(NSData *)data jsonName:(NSString *)jsonName{
    NSString *jsonPath = [self jsonPathWithName:jsonName];
    BOOL success = [data writeToFile:jsonPath atomically:YES];
    return success;
}
// 获取 购物车列表数据
+(NSMutableArray *)getGoodsList{
    
    NSString *name = @"model";
    
    NSData *data = [self readJsonDataWithName:name];
    NSArray *dataArray = nil;
    if (data.bytes != 0) {
        dataArray = [data objectFromJSONData];
    }
    
    if (dataArray == nil) {
        dataArray = [[NSArray alloc] init];
    }
    return [dataArray mutableCopy];
}
// 存储二进制商品数据
+(BOOL)saveGoodsData:(NSData *)data{
    NSString *name = @"model";
    return [self writeDataToJsonData:data jsonName:name];
}
// 存储商品数据
+(BOOL)saveGoods:(NSDictionary *)dict{
    
    NSMutableArray *dataArray = [self getGoodsList];
    NSString *spec_sn = dict[@"specSn"];
    int i = 0;
    for (; i < dataArray.count; i++) {
        NSDictionary *info = dataArray[i];
        NSString *s_sn = info[@"specSn"];
        if ([s_sn isEqual:spec_sn]) {
            break;
        }
    }
    if (dataArray.count > i) {
        [dataArray replaceObjectAtIndex:i withObject:dict];
    } else {
        [dataArray addObject:dict];
    }
    NSData *data = [dataArray JSONData];
    return [self saveGoodsData:data];
}
// 根据 商品号, 删除对应的商品
+(BOOL)deleteGoodsWithId:(NSString *)idstr{
    
    NSMutableArray *dataArray = [self getGoodsList];
    int i = 0;
    for (; i < dataArray.count; i++) {
        NSDictionary *info = dataArray[i];
        NSString *s_sn = info[@"specSn"];
        if ([s_sn isEqual:idstr]) {
            break;
        }
    }
    [dataArray removeObjectAtIndex:i];
    
    NSData *data = [dataArray JSONData];
    return [self saveGoodsData:data];
}

@end
