//
//  MonAnDAO.m
//  iost3h
//
//  Created by Hoang on 9/7/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "MonAnDAO.h"

@implementation MonAnDAO

-(NSMutableArray *)getListMonAnWithOption:(id)option{
    NSMutableArray *listMonAn = [NSMutableArray new];
    NSMutableString *query = [NSMutableString new];
    [query appendString:@"select * from monan as m "];
    // Neu co option
    if (option) {
        NSString *joinClause = @"";
        NSString *whereClause = @"";
        
        if ([option isKindOfClass:[NguyenLieu class]]) {
            NguyenLieu *item = option;
            joinClause = @"join monan_nguyenlieu as n on m.id=n.monan_id ";
            whereClause = [NSString stringWithFormat:@"where n.nguyenlieu_id=(select id from nguyenlieu where ten='%@')", item._ten];
        } else if ([option isKindOfClass:[CachNau class]]) {
            CachNau *item = option;
            joinClause = @"join monan_cachnau as c on m.id=c.monan_id ";
            whereClause = [NSString stringWithFormat:@"where c.cachnau_id=(select id from cachnau where ten='%@')", item._ten];
        } else if ([option isKindOfClass:[DiaDiem class]]) {
            DiaDiem *item = option;
            joinClause = @"join monan_diadiem as d on m.id=d.monan_id ";
            whereClause = [NSString stringWithFormat:@"where d.diadiem_id=(select id from diadiem where ten='%@')", item._ten];
        } else if ([option isKindOfClass:[ThoiDiem class]]) {
            ThoiDiem *item = option;
            joinClause = @"join monan_thoidiem as t on m.id=t.monan_id ";
            whereClause = [NSString stringWithFormat:@"where t.thoidiem_id=(select id from thoidiem where ten='%@')", item._ten];
        } else if ([option isKindOfClass:[CheDo class]]) {
            CheDo *item = option;
            joinClause = @"join monan_chedo as c2 on m.id=c2.monan_id ";
            whereClause = [NSString stringWithFormat:@"where c2.chedo_id=(select id from chedo where ten='%@')", item._ten];
        } else if ([option isKindOfClass:[NSDictionary class]]) {  // Lay danh sach mon an theo yeu cau
            NSDictionary *dic = option;
            if (dic[kDBOptionMonMoiNhat]) { // Lay N mon an moi nhat
                [query appendString:[NSString stringWithFormat:@"order by id DESC limit %@ ", dic[kDBOptionSoLuongMonMoiNhat]]];
            }
        }
        [query appendString:joinClause];
        [query appendString:whereClause];
        //        NSLog(@"Query: %@", query);
        
    }
    super.statement = [super getStatementFromQuery:query];
    if (super.statement) {
        while (sqlite3_step(super.statement) == SQLITE_ROW) {
            // Truy xuat gia tri tai tung column
            int uid = sqlite3_column_int(super.statement, 0);
            char *ten = (char *)sqlite3_column_text(super.statement, 1);
            char *mota = (char *)sqlite3_column_text(super.statement, 2);
            char *nguyenlieu = (char *)sqlite3_column_text(super.statement, 3);
            char *cachnau = (char *)sqlite3_column_text(super.statement, 4);
            char *image = (char *)sqlite3_column_text(super.statement, 5);
            char *video = (char *)sqlite3_column_text(super.statement, 6);
            char *link = (char *)sqlite3_column_text(super.statement, 7);
            // Khoi tao mon an
            MonAn *monan = [MonAn new];
            monan._id = uid;
            monan._ten = [NSString stringWithUTF8String:ten];
            monan._mota = mota==NULL ? nil : [NSString stringWithUTF8String:mota];
            monan._nguyenlieu = nguyenlieu==NULL ? nil : [NSString stringWithUTF8String:nguyenlieu];
            monan._cachnau = cachnau==NULL ? nil : [NSString stringWithUTF8String:cachnau];
            monan._image = image==NULL ? nil : [NSString stringWithUTF8String:image];
            monan._video = video==NULL ? nil : [NSString stringWithUTF8String:video];
            monan._link = link==NULL ? nil : [NSString stringWithUTF8String:link];
            // Them mon an vao danh sach
            [listMonAn addObject:monan];
        }
        //Giai phong statement
        sqlite3_finalize(super.statement);
    }
    return listMonAn;
}

+(NSMutableArray *)getListMonAnWithOption:(id)option{
    return [[MonAnDAO new] getListMonAnWithOption:option];
}

-(BOOL)updateMonAn: (MonAn *)monAn{
    BOOL result = NO;
    NSString *query = [NSString stringWithFormat:@"update monan set ten=?, mota=?, nguyenlieu=?, cachnau=?, image=?, video=?, link=? where id=%ld", monAn._id];
    super.statement = [super getStatementFromQuery:query];
    if (super.statement) {
        sqlite3_bind_text(super.statement, 1, [monAn._ten UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 2, [monAn._mota UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 3, [monAn._nguyenlieu UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 4, [monAn._cachnau UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 5, [monAn._image UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 6, [monAn._video UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 7, [monAn._link UTF8String], -1, NULL);
        if (sqlite3_step(super.statement) == SQLITE_DONE) {
            result = YES;
        }
    }
    
    //Giai phong statement
    sqlite3_finalize(super.statement);
    return  result;
}

+(BOOL)updateMonAn: (MonAn *)monAn{
    return [[MonAnDAO new] updateMonAn:monAn];
}

-(NSInteger)insertMonAn: (MonAn *)monAn{
    NSInteger monAnId = 0;
    NSString *query = @"insert into monan(ten, mota, nguyenlieu, cachnau, image, video, link) values(?, ?, ?, ?, NULL, ?, ?)";
    super.statement = [super getStatementFromQuery:query];
    if (super.statement) {
        sqlite3_bind_text(super.statement, 1, [monAn._ten UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 2, [monAn._mota UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 3, [monAn._nguyenlieu UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 4, [monAn._cachnau UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 5, [monAn._video UTF8String], -1, NULL);
        sqlite3_bind_text(super.statement, 6, [monAn._link UTF8String], -1, NULL);
        if (sqlite3_step(super.statement) == SQLITE_DONE) {
            if (monAn._image) {
                monAnId = [self updateImageAfterInsert];
            } else {
                //Giai phong statement
                sqlite3_finalize(super.statement);
            }
        }
    }
    
    return monAnId;
}

+(NSInteger)insertMonAn: (MonAn *)monAn{
    return  [[MonAnDAO new] insertMonAn:monAn];
}

// Update lai ten hinh sau khi insert (do luc insert khong biet truoc duoc id, sau khi insert moi biet id)
-(NSInteger)updateImageAfterInsert{
    // Lay thong tin id cua mon an vua moi insert vao
    NSDictionary *option = @{kDBOptionMonMoiNhat:@(1), kDBOptionSoLuongMonMoiNhat:@(1)};
    MonAn *monMoiNhat = [self getListMonAnWithOption:option][0];
    monMoiNhat._image = [Utils imageNameFromNumber:monMoiNhat._id];
    
    // Update lai image name vao DB
    [self updateMonAn:monMoiNhat];
    
    // Tra ve ten image vua update
    return monMoiNhat._id;
}

-(BOOL)deleteMonAn: (MonAn *) monAn{
    BOOL result = NO;
    NSString *query = [NSString stringWithFormat:@"delete from monan where id=%ld", monAn._id];
    super.statement = [super getStatementFromQuery:query];
    if (super.statement && sqlite3_step(super.statement) == SQLITE_DONE) {
        result = YES;
    }
    
    //Giai phong statement
    sqlite3_finalize(super.statement);
    return result;
}

+(BOOL)deleteMonAn: (MonAn *) monAn{
    return [[MonAnDAO new] deleteMonAn:monAn];
}
@end
