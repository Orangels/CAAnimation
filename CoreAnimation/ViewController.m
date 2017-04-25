//
//  ViewController.m
//  CoreAnimation
//
//  Created by Orangels on 16/11/22.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "ViewController.h"
#import "animationsViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSArray * animationNames;
@property (nonatomic ,strong) NSDate  * now;
@property (nonatomic ,strong) NSDate  * finishDay;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
}

- (NSArray *)animationNames{
    if (_animationNames == nil ) {
        _animationNames = @[@"CABasicAnimation",@"CAKeyframeAnimation",@"CAAnimationGroup",@"CATransition",@"CAShaperLayer",@"gif",@"CAReplicatorLayer",@"CATransform3D_m34",@"CATransformLayer"];
        
#if 1
        //这里随便写了一个时间比较的方法
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy/MM/dd HH:mm:ss";
        NSString* finishStr = @"2016/11/24 15:00:00";
        _finishDay = [dateFormatter dateFromString:finishStr];
        //获取北京时间
        //_now = [NSDate dateWithTimeIntervalSinceNow:8*60*60];
        
        
        //这里是针对本地时区进行了转换,如果比较时间,不需要转换,直接比较 gmt 时间
        NSTimeZone* timeZone = [NSTimeZone systemTimeZone];
        NSTimeInterval interval = timeZone.secondsFromGMT;
        _now = [[NSDate date] dateByAddingTimeInterval:interval];
        _finishDay = [_finishDay dateByAddingTimeInterval:interval];
        
        
        NSLog(@"now: %@",_now);
        NSLog(@"finish: %@",_finishDay);
        
        
        int i = [_now compare:_finishDay];
        NSLog(@"%d",i);
#endif
        
    }
    return _animationNames;
}

- (void)creatTableView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITableView* tableView    = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
    tableView.rowHeight       = 60;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.dataSource      = self;
    tableView.delegate        = self;
    [self.view addSubview:tableView];
    
}

#pragma mark tableViewDelegate/DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.animationNames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.animationNames[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    animationsViewController* vc = [[animationsViewController alloc] init];
    vc.type = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



































