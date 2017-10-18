//
//  NguyenLieuDAO.m
//  iost3h
//
//  Created by Hoang on 9/11/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "NguyenLieuDAO.h"

@implementation NguyenLieuDAO
-(NSMutableArray *)getListNguyenLieu{
    NSMutableArray *listNguyenLieu = [NSMutableArray new];
    NSString *query = @"select * from nguyenlieu";
    super.statement = [super getStatementFromQuery:query];
    if (super.statement) {
        while (sqlite3_step(super.statement) == SQLITE_ROW) {
            // Truy xuat gia tri tai tung column
            int uid = sqlite3_column_int(super.statement, 0);
            char *ten = (char *)sqlite3_column_text(super.statement, 1);
            char *ghichu = (char *)sqlite3_column_text(super.statement, 2);
            int gia = sqlite3_column_int(super.statement, 3);
            char *donvi = (char *)sqlite3_column_text(super.statement, 4);
            // Khoi tao nguyen lieu
            NguyenLieu *nguyenlieu = [NguyenLieu new];
            nguyenlieu._id = uid;
            nguyenlieu._ten = [NSString stringWithUTF8String:ten];
            nguyenlieu._ghichu = ghichu==NULL ? nil : [NSString stringWithUTF8String:ghichu];
            nguyenlieu._gia = gia;
            nguyenlieu._donvi = donvi==NULL ? nil : [NSString stringWithUTF8String:donvi];
            // Them mon an vao danh sach
            [listNguyenLieu addObject:nguyenlieu];
        }
        //Giai phong statement
        sqlite3_finalize(super.statement);
    }
    return listNguyenLieu;
}

+(NSMutableArray *)getListNguyenLieu{
    return [[NguyenLieuDAO new] getListNguyenLieu];
}
@end
