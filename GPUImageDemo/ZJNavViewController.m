//
//  ZJNavViewController.m
//  GPUImageDemo
//
//  Created by jianz3 on 2017/8/30.
//  Copyright © 2017年 jianz3. All rights reserved.
//

#import "ZJNavViewController.h"

@interface ZJNavViewController ()

@end

@implementation ZJNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @" 为图片添加滤镜";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
