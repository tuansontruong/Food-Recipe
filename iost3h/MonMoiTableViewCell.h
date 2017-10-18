//
//  MonMoiTableViewCell.h
//  iost3h
//
//  Created by Hoang on 9/12/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "MonAnDAO.h"
#import "DetailsViewController.h"

@interface MonMoiTableViewCell : UITableViewCell<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property(nonatomic)UIViewController *context;
@property(nonatomic)NSArray<MonAn *> *listMonAn;
- (void)setupScrollViewWithParent:(UIView *)parent andNumberOfFood:(NSInteger)number inContext:(UIViewController *)context;
@end
