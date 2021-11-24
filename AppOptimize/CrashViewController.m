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
    btn.frame = CGRectMake(50, 100, 100, 40);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"模拟崩溃" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(crashClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(50, 150, 100, 40);
    [btn1 setBackgroundColor:[UIColor redColor]];
    [btn1 setTitle:@"未知方法" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(unrecognizedSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

- (void)crashClick
{
    [self presentViewController:self animated:YES completion:nil];
    return;
//    id obj = nil;
//    NSMutableArray *array = [NSMutableArray array];
//    [array addObject:obj];
}

// 未知方法崩溃拦截
- (void)unrecognizedSelector {
    
    id test = [self performSelector:@selector(testMethod)];
    NSLog(@"%@",test);
    
//        id test = [ViewController performSelector:@selector(testMethod)];
//        NSLog(@"%@",test);
}

@end
