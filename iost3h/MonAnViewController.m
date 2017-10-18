//
//  MonAnViewController.m
//  iost3h
//
//  Created by Hoang on 9/5/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "MonAnViewController.h"
#import "SWRevealViewController.h"
@interface MonAnViewController ()

@end

@implementation MonAnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.listMonAn = [self.dao getListMonAnWithOption:self.option];
    [self.tableView reloadData];
//    NSLog(@"Option passed: %@", self.listMonAn);
}

#pragma mark Helpers

-(void)initData{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dao = [MonAnDAO new];
    // Doi font cho navigation bar
    [Utils changeNavigationBarWithFontName:kFontName1 andTitle:@"Danh Sách Món Ăn" fromContext:self];
    // Add pan gesture cho side menu
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Doc setting tu user default
    self.userDefault = [NSUserDefaults standardUserDefaults];
}

#pragma mark UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.userDefault boolForKey:kSettingHienMonAnMoi]) {
        return 2;
    } else {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.userDefault boolForKey:kSettingHienMonAnMoi] && section==0) {
        return 1;
    } else {
        return self.listMonAn.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.userDefault boolForKey:kSettingHienMonAnMoi] && indexPath.section==0) {
        return 220;
    } else {
        return 180;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.userDefault boolForKey:kSettingHienMonAnMoi] && indexPath.section==0) {
        MonMoiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSInteger soluong = [[self.userDefault objectForKey:kSettingSoMonAnMoi] integerValue];
        [cell setupScrollViewWithParent:self.view andNumberOfFood:soluong inContext:self];
        return cell;
    } else {
        MonAnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        MonAn *monan = self.listMonAn[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lbTen.text = [monan._ten capitalizedString];
        cell.ivHinh.image = monan._image==nil ? [UIImage imageNamed:@"placeholder"] : [Utils getImageWithFileName:monan._image];
        return cell;
    }
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        DetailsViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        detail.currentMonAn = self.listMonAn[indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return NO;
    } else {
        return  YES;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1 && editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete mon an khoi db
        [self.dao deleteMonAn:self.listMonAn[indexPath.row]];
        [self.listMonAn removeObjectAtIndex:indexPath.row];
        // Delete khoi UI
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"Xóa";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
}
 */

#pragma mark - Actions

- (IBAction)openMenu:(id)sender {
    [self.revealViewController revealToggleAnimated:YES];
}

- (IBAction)search:(id)sender {
}

@end
