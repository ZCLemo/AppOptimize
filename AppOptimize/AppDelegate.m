//
//  AppDelegate.m
//  AppOptimize
//
//  Created by chen on 2021/5/7.
//

#import "AppDelegate.h"
#import "UncaughtExceptionHandler.h"
#import "ViewController.h"
#import "KartunMonitor.h"
#import "CPUMonitor.h"
#import "MemoryMonitor.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch
    
    [UncaughtExceptionHandler installUncaughtExceptionHandler];
    [[KartunMonitor shareInstance] beginMintor];
    [[CPUMonitor sharedIntance] beginMonitor];
    [[MemoryMonitor shareInstance] beginMonitor];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
