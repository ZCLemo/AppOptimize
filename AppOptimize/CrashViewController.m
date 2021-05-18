//
//  CrashViewController.m
//  AppOptimize
//
//  Created by chen on 2021/5/8.
//

#import "CrashViewController.h"

@interface CrashViewController ()

@end

@implementation CrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"崩溃";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 150, 100, 40);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"模拟崩溃" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(crashClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)crashClick
{
    [self presentViewController:self animated:YES completion:nil];
    return;
//    id obj = nil;
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:obj];
}

@end
