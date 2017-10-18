//
//  DBProvider.h
//  iost3h
//
//  Created by Hoang on 9/5/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "sqlite3.h"

@interface DBProvider : NSObject
@property(nonatomic)sqlite3 *DB;
@property(nonatomic)sqlite3_stmt *statement;
-(NSString *)getDBPath;
-(sqlite3_stmt *)getStatementFromQuery:(NSString *)query;
@end
