//
//  MonAn.h
//  iost3h
//
//  Created by Hoang on 9/5/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonAn : NSObject
@property(nonatomic)NSInteger _id;
@property(nonatomic)NSString *_ten;
@property(nonatomic)NSString *_mota;
@property(nonatomic)NSString *_nguyenlieu;
@property(nonatomic)NSString *_cachnau;
@property(nonatomic)NSString *_image;
@property(nonatomic)NSString *_video;
@property(nonatomic)NSString *_link;
@property(nonatomic)NSMutableArray *nguyenlieu;
@property(nonatomic)NSMutableArray *cachnau;
@property(nonatomic)NSMutableArray *diadiem;
@property(nonatomic)NSMutableArray *thoidiem;
@property(nonatomic)NSMutableArray *chedo;
@end
