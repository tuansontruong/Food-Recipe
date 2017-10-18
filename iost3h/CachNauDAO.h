//
//  CachNauDAO.h
//  iost3h
//
//  Created by Hoang on 9/11/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "DBProvider.h"

@interface CachNauDAO : DBProvider
-(NSMutableArray *)getListCachNau;
+(NSMutableArray *)getListCachNau;
@end
