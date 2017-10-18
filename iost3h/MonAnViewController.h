//
//  MonAnViewController.h
//  iost3h
//
//  Created by Hoang on 9/5/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "MonAnTableViewCell.h"
#import "MonMoiTableViewCell.h"
#import "MonAnDAO.h"
#import "DetailsViewController.h"

@interface MonAnViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) MonAnDAO *dao;
@property(nonatomic)id option;
@property(nonatomic)NSUserDefaults *userDefault;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sideMenuButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)openMenu:(id)sender;
- (IBAction)search:(id)sender;
@property(nonatomic)NSMutableArray *listMonAn;

@end
