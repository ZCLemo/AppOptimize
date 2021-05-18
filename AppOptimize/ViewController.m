//
//  ViewController.m
//  AppOptimize
//
//  Created by chen on 2021/5/7.
//

#import "ViewController.h"
#import "CrashViewController.h"
#import "KartunViewController.h"
#import "CPUViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *types = @[@"崩溃",@"卡顿监控",@"CPU"];
    
    for (int i = 0; i < types.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50, 100+i*40+i*10, 100, 40);
        btn.tag = i + 100;
        [btn setBackgroundColor:[UIColor redColor]];
        [btn setTitle:types[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 100) {
        CrashViewController *crashVC = [[CrashViewController alloc] init];
        [self.navigationController pushViewController:crashVC animated:YES];
    }else if (sender.tag == 101){
        KartunViewController *kartunVC = [[KartunViewController alloc] init];
        [self.navigationController pushViewController:kartunVC animated:YES];
    }else if(sender.tag == 102){
        CPUViewController *cpuVC = [[CPUViewController alloc] init];
        [self.navigationController pushViewController:cpuVC animated:YES];
    }
    
}

@end
