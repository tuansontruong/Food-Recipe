//
//  CheDoDAO.m
//  iost3h
//
//  Created by Hoang on 9/11/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "CheDoDAO.h"

@implementation CheDoDAO
-(NSMutableArray *)getListCheDo{
    NSMutableArray *listCheDo = [NSMutableArray new];
    NSString *query = @"select * from chedo";
    super.statement = [super getStatementFromQuery:query];
    if (super.statement) {
        while (sqlite3_step(super.statement) == SQLITE_ROW) {
            // Truy xuat gia tri tai tung column
            int uid = sqlite3_column_int(super.statement, 0);
            char *ten = (char *)sqlite3_column_text(super.statement, 1);
            char *ghichu = (char *)sqlite3_column_text(super.statement, 2);
            // Khoi tao che do
            CheDo *chedo = [CheDo new];
            chedo._id = uid;
            chedo._ten = [NSString stringWithUTF8String:ten];
            chedo._ghichu = ghichu==NULL ? nil : [NSString stringWithUTF8String:ghichu];
            // Them mon an vao danh sach
            [listCheDo addObject:chedo];
        }
        //Giai phong statement
        sqlite3_finalize(super.statement);
    }
    return listCheDo;
}

+(NSMutableArray *)getListCheDo{
    return [[CheDoDAO new] getListCheDo];
}
@end
