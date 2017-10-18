//
//  SideMenuViewController.m
//  iost3h
//
//  Created by Hoang on 9/10/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "SideMenuViewController.h"
#define kMenuItemAll @"Tất cả món ăn"
#define kMenuItemMonAnMoiNhat @"Các món mới nhất"
#define kMenuItemNguyenLieu @"Nguyên liệu"
#define kMenuItemCachNau @"Cách nấu"
#define kMenuItemDiaDiem @"Địa điểm"
#define kMenuItemThoiDiem @"Thời điểm"
#define kMenuItemCheDo @"Chế độ"
#define kMenuItemSetting @"Tùy chỉnh"

@interface SideMenuViewController ()<RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSArray *data;
@property (weak, nonatomic) RATreeView *treeView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.scrollView.bounds];
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.treeFooterView = [UIView new];
    treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    [treeView setBackgroundColor:[UIColor clearColor]];
    self.treeView = treeView;
    self.treeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [self.scrollView addSubview:treeView];
    [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([RATableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([RATableViewCell class])];

    self.treeView.treeHeaderView = [self createHeaderView];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.treeView reloadData];
}

#pragma mark RATreeViewDataSource

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item{
    RADataObject *dataItem = item;
    NSInteger level = [self.treeView levelForCellForItem:item];

    RATableViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([RATableViewCell class])];
    [cell setupWithTitle:dataItem.name andLevel:level];
    return cell;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item{
    if (item == nil) {
        return [self.data count];
    }
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    
    return data.children[index];
}

#pragma mark RATreeViewDelegate

- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item{
    NSInteger level = [self.treeView levelForCellForItem:item];
    if (level==0) {
        return 38;
    }
    return 32;
}

-(void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item{
    NSInteger level = [self.treeView levelForCellForItem:item];
    RADataObject *dataItem = item;
    if (level==0) {
        // Neu click vo tat ca mon an
        if ([dataItem.name isEqualToString:kMenuItemAll]) {
            NSDictionary *data = @{@"parent":dataItem, @"item":dataItem};
            [self performSegueWithIdentifier:@"MenuClick" sender:data];
            
        } else if([dataItem.name isEqualToString:kMenuItemMonAnMoiNhat]) {   // Neu click vo cac mon an moi nhat
            NSDictionary *data = @{@"parent":dataItem, @"item":dataItem};
            [self performSegueWithIdentifier:@"MenuClick" sender:data];
            
        } else if ([dataItem.name isEqualToString:kMenuItemSetting]) { // Neu click vo tuy chinh
            [self performSegueWithIdentifier:@"TuyChinhClick" sender:self];
        }
    } else if (level==1) {     // Neu click vo thanh phan con cua 1 phan loai mon an
        // Push to MonAnViewController with option
        NSDictionary *data = @{@"parent":[self.treeView parentForItem:item], @"item":item};
        [self performSegueWithIdentifier:@"MenuClick" sender:data];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"MenuClick"]){
        UINavigationController *navigate = (UINavigationController *) segue.destinationViewController;
        MonAnViewController *monan = (MonAnViewController *) navigate.viewControllers[0];
        monan.option = [self getOptionFromSender:(NSDictionary *)sender];
    }
}

#pragma mark Helpers

-(id)getOptionFromSender:(NSDictionary *)sender{
    id result = nil;
    RADataObject *parent = sender[@"parent"];
    RADataObject *item = sender[@"item"];
    if ([parent.name isEqualToString:kMenuItemNguyenLieu]) {
        NguyenLieu *tmp = [NguyenLieu new];
        tmp._ten = item.name;
        result = tmp;
    } else if ([parent.name isEqualToString:kMenuItemCachNau]) {
        CachNau *tmp = [CachNau new];
        tmp._ten = item.name;
        result = tmp;
    } else if ([parent.name isEqualToString:kMenuItemDiaDiem]) {
        DiaDiem *tmp = [DiaDiem new];
        tmp._ten = item.name;
        result = tmp;
    } else if ([parent.name isEqualToString:kMenuItemThoiDiem]) {
        ThoiDiem *tmp = [ThoiDiem new];
        tmp._ten = item.name;
        result = tmp;
    } else if ([parent.name isEqualToString:kMenuItemCheDo]) {
        CheDo *tmp = [CheDo new];
        tmp._ten = item.name;
        result = tmp;
    } else if ([parent.name isEqualToString:kMenuItemMonAnMoiNhat]) {
        NSDictionary *tmp = @{kDBOptionMonMoiNhat: @(1), kDBOptionSoLuongMonMoiNhat: @(20)};
        result = tmp;
    }
    return  result;
}

-(UIView *)createHeaderView{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.treeView.bounds.size.width, 110)];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 50, 50)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(76, 0, self.treeView.bounds.size.width-76, 38)];
    UILabel *author = [[UILabel alloc] initWithFrame:CGRectMake(77, 40, self.treeView.bounds.size.width-77, 16)];
//    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.treeView.bounds.size.width, 1.5)];
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(-60, 60, self.treeView.bounds.size.width, 50)];
    line2.contentMode = UIViewContentModeScaleAspectFit;
    line2.image = [UIImage imageNamed:@"horizontal_line2"];
    
    header.backgroundColor = [UIColor clearColor];
    logo.image = [UIImage imageNamed:@"me"];
    [[logo layer] setMasksToBounds:YES];
    [[logo layer] setBorderColor:[[UIColor cyanColor] CGColor]];
    [[logo layer] setBorderWidth:2];
    [[logo layer] setCornerRadius:25];
    logo.contentMode = UIViewContentModeScaleToFill;
    title.text = @"Cook Book Go";
    title.textColor = [UIColor cyanColor];
    title.backgroundColor = [UIColor clearColor];
    [title setFont:[UIFont fontWithName:kFontName3 size:22]];
    author.text = @"HoangNLM";
    author.textColor = [UIColor cyanColor];
    author.backgroundColor = [UIColor clearColor];
    [author setFont:[author.font fontWithSize:13]];
//    line1.backgroundColor = [UIColor cyanColor];

    [header addSubview:logo];
    [header addSubview:title];
    [header addSubview:author];
//    [header addSubview:line1];
    [header addSubview:line2];
    return  header;
}

-(void)loadData{
    RADataObject *tatca = [RADataObject dataObjectWithName:kMenuItemAll children:nil];
    RADataObject *moinhat = [RADataObject dataObjectWithName:kMenuItemMonAnMoiNhat children:nil];
    
    NSMutableArray *children = [NSMutableArray new];
    for (NguyenLieu *item in [NguyenLieuDAO getListNguyenLieu]) {
        RADataObject *dataItem = [RADataObject dataObjectWithName:item._ten children:nil];
        [children addObject:dataItem];
    }
    RADataObject *nguyenlieu = [RADataObject dataObjectWithName:kMenuItemNguyenLieu children:children];
    
    [children removeAllObjects];
    for (CachNau *item in [CachNauDAO getListCachNau]) {
        RADataObject *dataItem = [RADataObject dataObjectWithName:item._ten children:nil];
        [children addObject:dataItem];
    }
    RADataObject *cachnau = [RADataObject dataObjectWithName:kMenuItemCachNau children:children];
    
    [children removeAllObjects];
    for (DiaDiem *item in [DiaDiemDAO getListDiaDiem]) {
        RADataObject *dataItem = [RADataObject dataObjectWithName:item._ten children:nil];
        [children addObject:dataItem];
    }
    RADataObject *diadiem = [RADataObject dataObjectWithName:kMenuItemDiaDiem children:children];
    
    [children removeAllObjects];
    for (ThoiDiem *item in [ThoiDiemDAO getListThoiDiem]) {
        RADataObject *dataItem = [RADataObject dataObjectWithName:item._ten children:nil];
        [children addObject:dataItem];
    }
    RADataObject *thoidiem = [RADataObject dataObjectWithName:kMenuItemThoiDiem children:children];
    
    [children removeAllObjects];
    for (CheDo *item in [CheDoDAO getListCheDo]) {
        RADataObject *dataItem = [RADataObject dataObjectWithName:item._ten children:nil];
        [children addObject:dataItem];
    }
    RADataObject *chedo = [RADataObject dataObjectWithName:kMenuItemCheDo children:children];

    RADataObject *cauhinh = [RADataObject dataObjectWithName:kMenuItemSetting children:nil];
    self.data = [NSArray arrayWithObjects:tatca, moinhat, nguyenlieu, cachnau, diadiem, thoidiem, chedo, cauhinh, nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
