//
//  AppDelegate.m
//  iost3h
//
//  Created by Hoang on 9/4/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Change color of caret
    [[UITextField appearance] setTintColor:[UIColor orangeColor]];
    [[UITextView appearance] setTintColor:[UIColor orangeColor]];

    // Change the background color of navigation bar
    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
    // Change image color of navigation bar
    [[UINavigationBar appearance] setTintColor:[UIColor orangeColor]];
    
    // Default settings for toast
    [CRToastManager setDefaultOptions:@{
                                        kCRToastNotificationTypeKey : @(CRToastTypeNavigationBar),
                                        kCRToastImageKey : [UIImage imageNamed:@"alert_icon.png"],
                                        kCRToastFontKey             : [UIFont fontWithName:@"HelveticaNeue-Light" size:16],
                                        kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                                        kCRToastTextColorKey        : [UIColor whiteColor],
                                        kCRToastBackgroundColorKey  : [UIColor orangeColor],
                                        kCRToastTimeIntervalKey : @(2.0),
                                        kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                        kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeSpring),
                                        kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                                        kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                                        kCRToastAutorotateKey       : @(YES),
                                        kCRToastInteractionRespondersKey : @[[CRToastInteractionResponder interactionResponderWithInteractionType:CRToastInteractionTypeTap automaticallyDismiss:YES block:nil]]}];
    
    // Thiet lap default setting
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES forKey:kSettingHienMonAnMoi];
    [userDefault setInteger:5 forKey:kSettingSoMonAnMoi];
    [userDefault synchronize];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
