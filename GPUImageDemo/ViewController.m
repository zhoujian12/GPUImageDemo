//
//  ViewController.m
//  GPUImageDemo
//
//  Created by jianz3 on 2017/8/29.
//  Copyright © 2017年 jianz3. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"
#import "CameraViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *iconImageView; ///<
@property (nonatomic, strong) UIImageView *disFilterImageView; ///<
@property (nonatomic, assign) NSInteger clickNumber; ///<
@property (nonatomic, strong) UIButton *toCameraBtn; ///<

@end

@implementation ViewController
#pragma mark - Circle Life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViews];
    self.clickNumber = 0;
}

- (void)dealloc{
    
}

#pragma mark - Private Method
- (void)addSubViews{
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.toCameraBtn];
}

- (void)btnAction:(UIButton *)btn{
    CameraViewController *vc = [CameraViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - System Method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了 clickNumber : %ld, clickNumber-- : %ld ",(long)self.clickNumber,(long)self.clickNumber%2);
    if (!self.disFilterImageView) {
        //设置要渲染的区域
        GPUImageSketchFilter *disFilter = [[GPUImageSketchFilter alloc]init];
        [disFilter forceProcessingAtSize:self.iconImageView.frame.size];
        [disFilter useNextFrameForImageCapture];
        
        //获取数据源
        GPUImagePicture * stillImageSource = [[GPUImagePicture alloc]initWithImage:self.iconImageView.image];
        [stillImageSource addTarget:disFilter];
        //开始渲染
        [stillImageSource processImage];
        
        UIImage *newImage = [disFilter imageFromCurrentFramebuffer];
        self.disFilterImageView = [[UIImageView alloc]initWithImage:newImage];
        self.disFilterImageView .frame = self.iconImageView.frame;
    }
    
    if (((long)self.clickNumber % 2) == 0) {
        self.iconImageView.hidden = YES;
        [self.view addSubview:self.disFilterImageView];
    }else{
        [self.disFilterImageView  removeFromSuperview];
        self.iconImageView.hidden = NO;
    }
    
    self.clickNumber ++;
}

#pragma mark - Setter && Getter
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
        _iconImageView.image = [UIImage imageNamed:@"Test1.jpg"];
    }
    return _iconImageView;
}

- (UIButton *)toCameraBtn{
    if (!_toCameraBtn) {
        _toCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _toCameraBtn.backgroundColor = [UIColor redColor];
        _toCameraBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_toCameraBtn setTitle:@"按钮点击" forState:UIControlStateNormal];
        [_toCameraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_toCameraBtn setFrame:CGRectMake(100, 400 , 100, 25)];
        [_toCameraBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toCameraBtn;
}
@end
