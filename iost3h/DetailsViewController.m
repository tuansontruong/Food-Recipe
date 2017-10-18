//
//  DetailsViewController.m
//  iost3h
//
//  Created by Hoang on 9/5/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![Utils checkNetworkConnection]) {
        [self performSelector:@selector(showToast) withObject:nil afterDelay:1];

    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Beware, viewWillDisappear: is called when the player view enters full screen on iOS 6+
    if ([self isMovingFromParentViewController])
        [self.videoPlayerViewController.moviePlayer stop];
}

#pragma mark - Helpers

-(void)showToast{
    [CRToastManager showNotificationWithMessage:@"Không kết nối internet để xem video được!" completionBlock:nil];
}

-(void)initData{
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    if (self.currentMonAn) {
        // Doi font cho navigation bar
        [Utils changeNavigationBarWithFontName:kFontName1 andTitle:[self.currentMonAn._ten capitalizedString] fromContext:self];
        self.imgHinh.image = self.currentMonAn._image==nil ? [UIImage imageNamed:@"placeholder"] : [Utils getImageWithFileName:self.currentMonAn._image];
        self.txtMota.text = self.currentMonAn._mota;
        self.txtNguyenLieu.text = self.currentMonAn._nguyenlieu;
        self.txtCachNau.text = self.currentMonAn._cachnau;
        self.txtLink.text = self.currentMonAn._link;
        if (![[self.currentMonAn._video stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] && [Utils checkNetworkConnection]) {
            NSString *videoIdentifier = [[self.currentMonAn._video componentsSeparatedByString:@"/"] lastObject];
            [self loadVideoThumbnailWithVideoIdentifier:videoIdentifier];
        }
    }
}

-(void)loadVideoThumbnailWithVideoIdentifier:(NSString *)videoIdentifier{
    self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoIdentifier];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveVideo:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:self.videoPlayerViewController];
    [defaultCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayerViewController.moviePlayer];
}

-(void)loadVideo{
    [self.video.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.videoPlayerViewController presentInView:self.video];
    [self.videoPlayerViewController.moviePlayer play];
}

#pragma mark - Notifications

- (void) videoPlayerViewControllerDidReceiveVideo:(NSNotification *)notification{
    XCDYouTubeVideo *video = notification.userInfo[XCDYouTubeVideoUserInfoKey];
    
    NSURL *thumbnailURL = video.mediumThumbnailURL ?: video.smallThumbnailURL;
    
    // Cai session task load cham nhu con rua (why ???)
//    NSURLSessionTask *task = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithRequest:[NSURLRequest requestWithURL:thumbnailURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
////        NSLog(@"data: %@", data);
//        if (!error) {
//            self.videoThumbnail.image = [UIImage imageWithData:data];
//        }
//    }];
//    [task resume];
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (!error) {
            self.videoThumbnail.image = [UIImage imageWithData:data];
            CGFloat x = self.videoThumbnail.frame.origin.x + self.videoThumbnail.frame.size.width/2 - 45;
            CGFloat y = self.videoThumbnail.frame.origin.y + self.videoThumbnail.frame.size.height/2 - 45;
            UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 90, 90)];
            bg.image = [UIImage imageNamed:@"video_wait"];
            bg.alpha = 1;
            bg.contentMode = UIViewContentModeScaleAspectFit;
            [self.videoThumbnail addSubview:bg];
            [self.videoThumbnail bringSubviewToFront:bg];
        }
     }];
}

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification{
    NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
    if (error){
        [CRToastManager showNotificationWithMessage:error.localizedDescription completionBlock:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UpdateViewController *update = (UpdateViewController *) segue.destinationViewController;
    update.currentMonAn = self.currentMonAn;
}

#pragma mark - Actions

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tapVideo:(id)sender {
    [self loadVideo];
}

@end
