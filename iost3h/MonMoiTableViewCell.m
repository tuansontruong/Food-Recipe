//
//  MonMoiTableViewCell.m
//  iost3h
//
//  Created by Hoang on 9/12/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "MonMoiTableViewCell.h"

dispatch_source_t CreateDispatchTimer(double interval, dispatch_queue_t queue, dispatch_block_t block){
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer){
        dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, (1ull * NSEC_PER_SEC) / 10);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    return timer;
}

@implementation MonMoiTableViewCell {
    dispatch_source_t _timer;
    float x1;
}

- (void)startTimer{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    double secondsToFire = 2.000f;
    
    _timer = CreateDispatchTimer(secondsToFire, queue, ^{
        // Do something
        dispatch_async(dispatch_get_main_queue(), ^{
            [self onTimer];
        });
    });
}

- (void)stopTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse{
    [self stopTimer];
    x1 = 0;
}

#pragma mark - Helpers

- (void)setupScrollViewWithParent:(UIView *)parent andNumberOfFood:(NSInteger)number inContext:(UIViewController *)context{
    // Tao du lieu
    NSDictionary *option = @{kDBOptionMonMoiNhat:@(1), kDBOptionSoLuongMonMoiNhat:@(number)};
    self.listMonAn = [MonAnDAO getListMonAnWithOption:option];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadDetailsPage)];
    [self.scrollView addGestureRecognizer:tap];
    self.context = context;
    
    // Vong lap tao ra cac imageView va them vao scrollView
    int x = 0;
    for (int i=0; i<self.listMonAn.count; i++) {
        // Khoi tao imageView de chua hinh voi kich thuoc cua scrollView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, parent.frame.size.width, _scrollView.frame.size.height)];
        // Thiet lap image cho imageView
        imageView.image = [Utils getImageWithFileName:self.listMonAn[i]._image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [_scrollView addSubview:imageView];
        x += imageView.frame.size.width;
    }
    
    // Thiet lap kich thuoc noi dung cho scrollView
    [_scrollView setContentSize:CGSizeMake(x, self.scrollView.frame.size.height)];
    
    // Thiet lap phan trang
    _scrollView.pagingEnabled = true;
    
    // Thiet lap so luong trang cho pageControl
    [_pageControl setNumberOfPages:self.listMonAn.count];
    
    // Thiet lap delegate
    _scrollView.delegate = self;
    
    // Thiet lap timer tu dong scroll
    if (self.listMonAn.count>1) {
        [self startTimer];
    }
}

-(void)loadDetailsPage{
    DetailsViewController *detail = [self.context.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([DetailsViewController class])];
    detail.currentMonAn = self.listMonAn[self.pageControl.currentPage];
    [self.context.navigationController pushViewController:detail animated:YES];
}

- (void)onTimer{
    x1 += _scrollView.frame.size.width;
    if(x1 == _scrollView.contentSize.width){
        x1 = 0;
    }
    [_scrollView setContentOffset:CGPointMake(x1, 0) animated:YES];
    
    // Cap nhat pageControl
    [self updatePageControl:x1];
}

- (void)updatePageControl:(int)x{
    int page = x/_scrollView.frame.size.width;
    _pageControl.currentPage = page;
}

#pragma mark Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{ //Chay sau khi scroll va tha tay ra
    // Tinh toan page hien tai
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // Thiet lap page hien tai cho page control
    _pageControl.currentPage = page;
}

@end
