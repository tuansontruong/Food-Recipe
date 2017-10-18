//
//  ThoiDiemDAO.m
//  iost3h
//
//  Created by Hoang on 9/11/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "ThoiDiemDAO.h"

@implementation ThoiDiemDAO
-(NSMutableArray *)getListThoiDiem{
    NSMutableArray *listThoiDiem = [NSMutableArray new];
    NSString *query = @"select * from thoidiem";
    super.statement = [super getStatementFromQuery:query];
    if (super.statement) {
        while (sqlite3_step(super.statement) == SQLITE_ROW) {
            // Truy xuat gia tri tai tung column
            int uid = sqlite3_column_int(super.statement, 0);
            char *ten = (char *)sqlite3_column_text(super.statement, 1);
            char *ghichu = (char *)sqlite3_column_text(super.statement, 2);
            // Khoi tao thoi diem
            ThoiDiem *thoidiem = [ThoiDiem new];
            thoidiem._id = uid;
            thoidiem._ten = [NSString stringWithUTF8String:ten];
            thoidiem._ghichu = ghichu==NULL ? nil : [NSString stringWithUTF8String:ghichu];
            // Them mon an vao danh sach
            [listThoiDiem addObject:thoidiem];
        }
        //Giai phong statement
        sqlite3_finalize(super.statement);
    }
    return listThoiDiem;
}

+(NSMutableArray *)getListThoiDiem{
    return [[ThoiDiemDAO new] getListThoiDiem];
}
@end
