//
//  DetailsViewController.h
//  iost3h
//
//  Created by Hoang on 9/5/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import <XCDYouTubeKit/XCDYouTubeKit.h>
#import "UpdateViewController.h"

@interface DetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgHinh;
@property (weak, nonatomic) IBOutlet UILabel *txtMota;
@property (weak, nonatomic) IBOutlet UILabel *txtNguyenLieu;
@property (weak, nonatomic) IBOutlet UILabel *txtCachNau;
@property (weak, nonatomic) IBOutlet UIView *video;
@property (weak, nonatomic) IBOutlet UIImageView *videoThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *txtLink;
@property(nonatomic)MonAn *currentMonAn;
@property (nonatomic) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
- (IBAction)back:(id)sender;
- (IBAction)tapVideo:(id)sender;


@end
