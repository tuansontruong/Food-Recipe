//
//  DiaDiemDAO.m
//  iost3h
//
//  Created by Hoang on 9/11/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "DiaDiemDAO.h"

@implementation DiaDiemDAO
-(NSMutableArray *)getListDiaDiem{
    NSMutableArray *listDiaDiem = [NSMutableArray new];
    NSString *query = @"select * from diadiem";
    super.statement = [super getStatementFromQuery:query];
    if (super.statement) {
        while (sqlite3_step(super.statement) == SQLITE_ROW) {
            // Truy xuat gia tri tai tung column
            int uid = sqlite3_column_int(super.statement, 0);
            char *ten = (char *)sqlite3_column_text(super.statement, 1);
            char *ghichu = (char *)sqlite3_column_text(super.statement, 2);
            // Khoi tao dia diem
            DiaDiem *diadiem = [DiaDiem new];
            diadiem._id = uid;
            diadiem._ten = [NSString stringWithUTF8String:ten];
            diadiem._ghichu = ghichu==NULL ? nil : [NSString stringWithUTF8String:ghichu];
            // Them mon an vao danh sach
            [listDiaDiem addObject:diadiem];
        }
        //Giai phong statement
        sqlite3_finalize(super.statement);
    }
    return listDiaDiem;
}

+(NSMutableArray *)getListDiaDiem{
    return [[DiaDiemDAO new] getListDiaDiem];
}
@end
