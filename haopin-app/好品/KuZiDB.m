//
//  NewKTDB.m
//  haopin
//
//  Created by 朱明科 on 16/3/14.
//  Copyright © 2016年 zhumingke. All rights reserved.
//

#import "KuZiDB.h"
#import "FMDatabase.h"

@implementation KuZiDB{
    FMDatabase *_dataBase;
}
+(instancetype)sharedInstance{
    static KuZiDB *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[KuZiDB alloc]init];
    });
    return shareInstance;
}
-(instancetype)init{
    if (self = [super init]) {
        [self createDataBase];
    }
    return self;
}
-(void)createDataBase{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"NewKTDB.db"];
    NSLog(@"新KT数据--%@", dbPath);
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSString *sql = @"create table if not exists kuZiList (image blob,currentYear varchar(1024),currentDate varchar(1024),detailTag varchar(1024))";
    if ([_dataBase open]) {
        [_dataBase executeUpdate:sql];
        NSLog(@"创建NewKT数据库成功");
    }else{
        NSLog(@"创建NewKT数据库失败");
    }
}
-(void)deleteBySession:(NSString *)session andDate:(NSString *)date{
    NSString *sql = @"delete from kuZiList where currentYear = ? and currentDate = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,session,date];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
- (void)addDetailModel:(KuZiModel *)ktModel{
    NSString *sql = @"insert into kuZiList(image,currentYear,currentDate,detailTag)values(?,?,?,?)";
    NSData *data = UIImagePNGRepresentation(ktModel.image);
    BOOL isSuccess = [_dataBase executeUpdate:sql,data,ktModel.currentYear,ktModel.currentDate,ktModel.detailTag];
    if (!isSuccess) {
        NSLog(@"添加数据失败--%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"添加数据成功");
    }
}
-(NSMutableArray *)fetchKTBySession:(NSString *)session andDate:(NSString *)date{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from kuZiList where currentYear = ? and currentDate = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session,date];
    while (set.next) {
        KuZiModel *ktModel = [[KuZiModel alloc] init];
        ktModel.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        ktModel.currentYear = [set stringForColumn:@"currentYear"];
        ktModel.currentDate = [set stringForColumn:@"currentDate"];
        ktModel.detailTag = [set stringForColumn:@"detailTag"];
        [mutArray addObject:ktModel];
    }
    [set close];
    return mutArray;
}
-(NSInteger)allNum{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from kuZiList";
    FMResultSet *set = [_dataBase executeQuery:sql];
    while (set.next) {
        KuZiModel *ktModel = [[KuZiModel alloc] init];
        ktModel.currentYear = [set stringForColumn:@"currentYear"];
        ktModel.currentDate  = [set stringForColumn:@"currentDate"];
        ktModel.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        [mutArray addObject:ktModel];
    }
    [set close];
    return mutArray.count;
}
-(NSInteger)numBySession:(NSString *)session andDate:(NSString *)date{
    NSMutableArray *mutArray = [NSMutableArray array];
    NSString *sql = @"select * from kuZiList where currentYear = ? and currentDate = ?";
    FMResultSet *set = [_dataBase executeQuery:sql,session,date];
    while (set.next) {
        KuZiModel *ktModel = [[KuZiModel alloc] init];
        ktModel.image = [UIImage imageWithData:[set dataForColumn:@"image"]];
        ktModel.currentYear = [set stringForColumn:@"currentYear"];
        ktModel.currentDate = [set stringForColumn:@"currentDate"];
        [mutArray addObject:ktModel];
    }
    [set close];
    return mutArray.count;
}
-(void)deleteBySession:(NSString *)tag{
    NSString *sql = @"delete from kuZiList where detailTag = ?";
    BOOL isSuccess = [_dataBase executeUpdate:sql,tag];
    if (!isSuccess) {
        NSLog(@"数据库删除错误error:%@",_dataBase.lastErrorMessage);
    }else{
        NSLog(@"删除成功");
    }
}
-(NSMutableArray *)fetchKTBySession:(NSString *)session {
    return nil;
}
@end
