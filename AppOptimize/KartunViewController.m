//
//  KartunViewController.m
//  AppOptimize
//
//  Created by chen on 2021/5/8.
//

/**
 造成卡顿的一些原因：
 复杂 UI 、图文混排的绘制量过大；
 在主线程上做网络同步请求；
 在主线程做大量的 IO 操作；
 运算量过大，CPU 持续高占用；
 死锁和主子线程抢锁。
 */

#import "KartunViewController.h"

@interface KartunViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation KartunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"卡顿";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //模拟卡顿
    usleep(100*1000);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row+1];
    return cell;
}

@end
