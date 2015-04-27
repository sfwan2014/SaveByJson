//
//  JsonDataManager.h
//  YDYWBusiness
//
//  Created by wanshaofa on 15/4/27.
//  Copyright (c) 2015年 ydyw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonDataManager : NSObject
+(NSData *)readJsonDataWithName:(NSString *)name;
+(BOOL)writeDataToJsonData:(NSData *)data jsonName:(NSString *)jsonName;
+(BOOL)deleteGoodsWithId:(NSString *)idstr;
+(NSMutableArray *)getGoodsList;
+(BOOL)saveGoods:(NSDictionary *)dict;
@end
