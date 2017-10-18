//
//  SearchViewController.h
//  iost3h
//
//  Created by Hoang on 9/12/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "MonAnTableViewCell.h"
#import "MonAnDAO.h"
#import "DetailsViewController.h"
#import "UpdateViewController.h"

@interface SearchViewController : UIViewController<UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) MonAnDAO *dao;
@property(nonatomic)NSMutableArray *listMonAn;
@property(nonatomic)UISearchController *searchController;
@property(nonatomic)NSMutableArray *searchResult;
@property BOOL isSearching;
- (IBAction)back:(id)sender;
@end
