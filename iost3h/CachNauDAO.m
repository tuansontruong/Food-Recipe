//
//  CachNauDAO.m
//  iost3h
//
//  Created by Hoang on 9/11/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "CachNauDAO.h"

@implementation CachNauDAO
-(NSMutableArray *)getListCachNau{
    NSMutableArray *listCachNau = [NSMutableArray new];
    NSString *query = @"select * from cachnau";
    super.statement = [super getStatementFromQuery:query];
    if (super.statement) {
        while (sqlite3_step(super.statement) == SQLITE_ROW) {
            // Truy xuat gia tri tai tung column
            int uid = sqlite3_column_int(super.statement, 0);
            char *ten = (char *)sqlite3_column_text(super.statement, 1);
            char *ghichu = (char *)sqlite3_column_text(super.statement, 2);
            // Khoi tao cach nau
            CachNau *cachnau = [CachNau new];
            cachnau._id = uid;
            cachnau._ten = [NSString stringWithUTF8String:ten];
            cachnau._ghichu = ghichu==NULL ? nil : [NSString stringWithUTF8String:ghichu];
            // Them mon an vao danh sach
            [listCachNau addObject:cachnau];
        }
        //Giai phong statement
        sqlite3_finalize(super.statement);
    }
    return listCachNau;
}

+(NSMutableArray *)getListCachNau{
    return [[CachNauDAO new] getListCachNau];
}
@end
