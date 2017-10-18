//
//  UpdateViewController.m
//  iost3h
//
//  Created by Hoang on 9/8/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "UpdateViewController.h"

@interface UpdateViewController ()

@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    
}

#pragma mark - Helpers

-(void)initData{
    if (self.revealViewController) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    // Doi font cho navigation bar
    [Utils changeNavigationBarWithFontName:kFontName1 andTitle:self.currentMonAn ? @"Cập Nhật Món Ăn" : @"Thêm Món Ăn" fromContext:self];
    if (!self.currentMonAn) {
        self.currentMonAn = [MonAn new];
    }
    
    [Utils loadFloatLabelTextViewInView:self.viewTen withPlaceholder:@"  Tên món ăn" andContent:self.currentMonAn._ten];
    [Utils loadFloatLabelTextViewInView:self.viewMoTa withPlaceholder:@"  Mô tả" andContent:self.currentMonAn._mota];
    [Utils loadFloatLabelTextViewInView:self.viewNguyenLieu withPlaceholder:@"  Nguyên liệu" andContent:self.currentMonAn._nguyenlieu];
    [Utils loadFloatLabelTextViewInView:self.viewCachNau withPlaceholder:@"  Cách nấu" andContent:self.currentMonAn._cachnau];
    self.imgHinh.image = self.currentMonAn._image ? [Utils getImageWithFileName:self.currentMonAn._image] : [UIImage imageNamed:@"placeholder"];
    [Utils decorateImageView:self.imgHinh];
    [Utils loadFloatLabelTextViewInView:self.viewVideo withPlaceholder:@"  Video" andContent:self.currentMonAn._video];
    [Utils loadFloatLabelTextViewInView:self.viewLink withPlaceholder:@"  Link" andContent:self.currentMonAn._link];
}

// Check du lieu dau vao
-(BOOL)validateInput{
    BOOL result = YES;
    // Ten khong duoc bo trong
    UITextView *ten = (UITextView *)self.viewTen.subviews[0];
    if ([[ten.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [CRToastManager showNotificationWithMessage:@"Tên món ăn không bỏ trống!" completionBlock:^{
            [ten becomeFirstResponder];
        }];
        result = NO;
    }
    return result;
}

// Hien thi image picker
-(void)showImagePicker{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// Cap nhat hinh mon an
-(void)updateImage{
    //        [userDefault setObject:[NSData dataWithData:UIImageJPEGRepresentation(self.imageView.image, 1.0)] forKey:@"image"];
    if (self.currentMonAn._image) {
        
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSLog(@"%@", info);
    self.imgHinh.image = info[UIImagePickerControllerEditedImage];
    // Dong image picker view lai khi user da chon xong hinh
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)chonHinh:(id)sender {
    [self showImagePicker];
}

- (IBAction)save:(id)sender {
    // Validate du lieu nhap vao
    if (![self validateInput]) {
        return;
    }
    
    UITextView *ten = (UITextView *) self.viewTen.subviews[0];
    UITextView *mota = (UITextView *) self.viewMoTa.subviews[0];
    UITextView *nguyenlieu = (UITextView *) self.viewNguyenLieu.subviews[0];
    UITextView *cachnau = (UITextView *) self.viewCachNau.subviews[0];
    UITextView *video = (UITextView *) self.viewVideo.subviews[0];
    UITextView *link = (UITextView *) self.viewLink.subviews[0];
    self.currentMonAn._ten = [ten.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.currentMonAn._mota = [mota.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.currentMonAn._nguyenlieu = [nguyenlieu.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.currentMonAn._cachnau = [cachnau.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // Luu ten hinh
    if (self.imgHinh.image != [UIImage imageNamed:@"placeholder"]) {
        if (!self.currentMonAn._image) {
            self.currentMonAn._image = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            NSLog(@"imagename: %@", self.currentMonAn._image);
        }
    }
    self.currentMonAn._video = [video.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.currentMonAn._link = [link.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Cap nhat vao db
    if (self.currentMonAn._id) {
        if ([MonAnDAO updateMonAn:self.currentMonAn]) {
            // Copy hinh vao device
            [Utils copyImageToDeviceWithImageName:self.currentMonAn._image fromUIImage:self.imgHinh.image];
            // Thong bao luu thanh cong xong quay ve man hinh chinh
            [CRToastManager showNotificationWithMessage:@"Đã lưu thông tin!" completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            // Thong bao luu khong thanh cong
            [CRToastManager showNotificationWithMessage:@"Lỗi! Không thể lưu thông tin!" completionBlock:nil];
        }
    } else { // Insert moi mon an
        NSInteger monAnId = [MonAnDAO insertMonAn:self.currentMonAn];
        if (monAnId) {
            if (!self.currentMonAn._image) {
                // Copy hinh vao device
                [Utils copyImageToDeviceWithImageName:[Utils imageNameFromNumber:monAnId] fromUIImage:self.imgHinh.image];
            }
            // Thong bao luu thanh cong xong quay ve man hinh chinh
            [CRToastManager showNotificationWithMessage:@"Đã lưu thông tin!" completionBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            // Thong bao luu khong thanh cong
            [CRToastManager showNotificationWithMessage:@"Lỗi! Không thể lưu thông tin!" completionBlock:nil];
        }
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
