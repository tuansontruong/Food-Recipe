//
//  SearchViewController.m
//  iost3h
//
//  Created by Hoang on 9/12/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    // Load tat ca mon an len truoc
    self.listMonAn = [self.dao getListMonAnWithOption:nil];
//    self.searchResult = [NSMutableArray new];
    [UIView transitionWithView: self.tableView duration: 0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations: ^(void){
        [self.tableView reloadData];
    } completion: nil];
    //    NSLog(@"Option passed: %@", self.listMonAn);
//    [self.searchController.searchBar becomeFirstResponder];
}

#pragma mark UISearchControllerDelegate

-(void)didPresentSearchController:(UISearchController *)searchController{
    searchController.searchBar.showsCancelButton = NO;
}

#pragma mark Helpers

-(void)initData{
    self.dao = [MonAnDAO new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Doi font cho navigation bar
    [Utils changeNavigationBarWithFontName:kFontName1 andTitle:@"Tìm Kiếm Món Ăn" fromContext:self];
    // Cau hinh search controller
    [self configSearchController];
    // Them gesture cho side menu
    if (self.revealViewController) {
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

-(void)configSearchController{
    // Khoi tao search controller
    if (!self.searchController) {
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];        
    }

    // Thiet lap delegate
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    
    // Config search controller
    self.searchController.hidesNavigationBarDuringPresentation = NO; //mac dinh la YES
    self.searchController.dimsBackgroundDuringPresentation = NO; //mac dinh la YES
    self.searchController.searchBar.placeholder = @"Tìm kiếm ở đây...";
    self.searchController.searchBar.showsCancelButton = NO;
    // Thiet lap title view la searchbar
    self.navigationItem.titleView = self.searchController.searchBar;
//    self.searchController.active = YES;
//    [self presentSearchController:self.searchController];

}

#pragma mark UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonAnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell1"];
    MonAn *monan = self.searchResult[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lbTen.text = [monan._ten capitalizedString];
    cell.ivHinh.image = monan._image==nil ? [UIImage imageNamed:@"placeholder"] : [Utils getImageWithFileName:monan._image];
    return cell;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
    detail.currentMonAn = self.searchResult[indexPath.row];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    // Khoi tao mang chua ket qua tim kiem
    self.searchResult = [NSMutableArray new];
    NSString *searchString = searchController.searchBar.text;
    // Thuc hien filter tren searchstring
    if (![searchString isEqualToString:@""]) {
        self.isSearching = YES;
        for (MonAn *item in self.listMonAn) {
            if ([[item._ten lowercaseString] containsString:[searchString lowercaseString]]) {
                [self.searchResult addObject:item];
            }
        }
    }
    // Tai lai table view
    [UIView transitionWithView: self.tableView duration: 0.35f options:UIViewAnimationOptionTransitionCrossDissolve animations: ^(void){
         [self.tableView reloadData];
     } completion: nil];
}

#pragma mark UISearchBarDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
