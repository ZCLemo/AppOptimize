//
//  CPUViewController.m
//  AppOptimize
//
//  Created by chen on 2021/5/8.
//

#import "CPUViewController.h"

@interface CPUViewController ()

@end

@implementation CPUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CPU";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 150, 100, 40);
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"CPU" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cpuClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)cpuClick
{
    for (int i = 0 ; i < 100000; i++) {
        UILabel *label = [[UILabel alloc] init];
    }
}

@end
