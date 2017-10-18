//
//  TuyChinhViewController.m
//  iost3h
//
//  Created by Hoang on 9/12/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "TuyChinhViewController.h"


@interface TuyChinhViewController ()

@end

@implementation TuyChinhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

#pragma mark Helpers

-(void)initData{
    // Doi font cho navigation bar
    [Utils changeNavigationBarWithFontName:kFontName1 andTitle:@"Tùy Chỉnh Ứng Dụng" fromContext:self];
    // Add pan gesture cho side menu
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    // Lay value tu user default
    self.userDefault = [NSUserDefaults standardUserDefaults];
    [self.switchHienMonMoi setOn:[self.userDefault boolForKey:kSettingHienMonAnMoi]];
    self.lblSoMonAnMoi.text = [NSString stringWithFormat:@"%zd", [self.userDefault integerForKey:kSettingSoMonAnMoi]];
    self.stepperSoMonMoi.value = [self.userDefault integerForKey:kSettingSoMonAnMoi];
    [self toggleSoMonAnMoi];
}

-(void)toggleSoMonAnMoi{
    self.lblMonAnMoi.enabled = self.switchHienMonMoi.isOn;
    self.lblSoMonAnMoi.enabled = self.switchHienMonMoi.isOn;
    self.stepperSoMonMoi.enabled = self.switchHienMonMoi.isOn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Actions

- (IBAction)hienMonAnMoi:(id)sender {
    [self.userDefault setBool:self.switchHienMonMoi.isOn forKey:kSettingHienMonAnMoi];
    [self toggleSoMonAnMoi];
}

- (IBAction)soMonAnMoi:(id)sender {
    self.lblSoMonAnMoi.text = [NSString stringWithFormat:@"%.0f", self.stepperSoMonMoi.value];
    [self.userDefault setInteger:self.stepperSoMonMoi.value forKey:kSettingSoMonAnMoi];
}

- (IBAction)openMenu:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}
@end
