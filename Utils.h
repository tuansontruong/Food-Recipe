//
//  Utils.h
//  iost3h
//
//  Created by Hoang on 9/9/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

// Define some constants
#define kDBFileName @"cookbookgo"
#define kFontName1 @"Ariston"
#define kFontName2 @"UVN Sang Song Nang"
#define kFontName3 @"UVN Nguyen Du"

#define kDBOptionMonMoiNhat @"monMoiNhat"
#define kDBOptionSoLuongMonMoiNhat @"soLuongMonMoiNhat"

#define kSettingHienMonAnMoi @"hienMonAnMoi"
#define kSettingSoMonAnMoi @"soMonAnMoi"

@interface Utils : NSObject
+(UIImage *)getImageWithFileName:(NSString *)filename;
+(NSString *)imageNameFromNumber:(NSInteger)number;
+(void)copyImageToDeviceWithImageName:(NSString *)imageName fromUIImage:(UIImage *)image;
+(void)showInfoMessage:(NSString *)message fromContext:(UIViewController *)context withOKHandler:(void (^)(UIAlertAction * action))handler;
+(void)decorateTextView:(UITextView *)textView;
+(void)decorateImageView:(UIImageView *)imageView;
+(void)loadFloatLabelTextViewInView:(UIView *)view withPlaceholder:(NSString *)text andContent:(NSString *)content;
+(void)changeNavigationBarWithFontName:(NSString *)fontName andTitle:(NSString *)title fromContext:(UIViewController *)context;
+(BOOL)checkNetworkConnection;
@end
