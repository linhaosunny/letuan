//
//  LTDealTool.m
//  乐团
//
//  Created by 李莎鑫 on 2017/2/25.
//  Copyright © 2017年 李莎鑫. All rights reserved.
//

#import "LTDealTool.h"
#import "LTDealModel.h"
#import "FMDB.h"

static FMDatabase *_db;

@implementation LTDealTool

+ (void)initialize{
    // > 创建数据库文件路径
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"deal.sqlite"];
    
    NSLog(@"%@",filePath);
    // > 创建数据库
    _db = [FMDatabase databaseWithPath:filePath];
    
    // > 打开数据库
    if(![_db open]) return;
    
    // > 创建表(CREATE TABLE IF NOT EXISTS - 不存在创建表)
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

// > (ORDER BY id DESC - 按id字段降序（DESC - 降序，ASC - 升序）查询)
+ (NSArray *)collectDealsWithNumofPage:(int)NumOfPage withPage:(int)page{
    
    int size = NumOfPage;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;",pos,size];
    NSMutableArray *deals = [NSMutableArray array];
    
    while (set.next) {
       LTDealModel *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]]
        ;
        [deals addObject:deal];
    }
    
    
    return deals;
}

+ (BOOL)isCollectDeal:(LTDealModel *) deal{
    
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;",deal.deal_id];
    
    [set next];
   return [set intForColumn:@"deal_count"] == 1;
}

+ (int)collectDealsCount{
    
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    
    [set next];
    return [set intForColumn:@"deal_count"];
}

+ (void)addCollectDeal:(LTDealModel *)deal{
    // > 模型转换成NSData (模型要压缩成NSData类型必须遵循NSCoding 协议,模型中使用MJCodingImplementation实现协议方法)
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal,deal_id) VALUES(%@,%@);",data,deal.deal_id];
}

+ (void)removeCollectDeal:(LTDealModel *)deal{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;",deal.deal_id];
}



// > (ORDER BY id DESC - 按id字段降序（DESC - 降序，ASC - 升序）查询)
+ (NSArray *)recentDealsWithNumofPage:(int)NumOfPage withPage:(int)page{
    
    int size = NumOfPage;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_recent_deal ORDER BY id DESC LIMIT %d,%d;",pos,size];
    NSMutableArray *deals = [NSMutableArray array];
    
    while (set.next) {
        LTDealModel *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]]
        ;
        [deals addObject:deal];
    }
    
    
    return deals;
}

+ (void)addRecentDeal:(LTDealModel *) deal{
    // > 模型转换成NSData (模型要压缩成NSData类型必须遵循NSCoding 协议,模型中使用MJCodingImplementation实现协议方法)
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_recent_deal(deal,deal_id) VALUES(%@,%@);",data,deal.deal_id];
}

+ (void)removeRecentDeal:(LTDealModel *) deal{
    [_db executeUpdateWithFormat:@"DELETE FROM t_recent_deal WHERE deal_id = %@;",deal.deal_id];
}

+ (BOOL)isRecentDeal:(LTDealModel *) deal{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_recent_deal WHERE deal_id = %@;",deal.deal_id];
    
    [set next];
    return [set intForColumn:@"deal_count"] == 1;
}

+ (int)recentDealsCount{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_recent_deal;"];
    
    [set next];
    return [set intForColumn:@"deal_count"];
}

@end
