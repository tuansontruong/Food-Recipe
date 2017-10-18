//
//  UpdateViewController.h
//  iost3h
//
//  Created by Hoang on 9/8/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "MonAnDAO.h"
#import "JVFloatLabeledTextView.h"

@interface UpdateViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic) MonAnDAO *dao;
@property(nonatomic)MonAn *currentMonAn;
@property (weak, nonatomic) IBOutlet UIView *viewTen;
@property (weak, nonatomic) IBOutlet UIView *viewMoTa;
@property (weak, nonatomic) IBOutlet UIView *viewNguyenLieu;
@property (weak, nonatomic) IBOutlet UIView *viewCachNau;
@property (weak, nonatomic) IBOutlet UIImageView *imgHinh;
@property (weak, nonatomic) IBOutlet UIView *viewVideo;
@property (weak, nonatomic) IBOutlet UIView *viewLink;

- (IBAction)chonHinh:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)back:(id)sender;

@end
