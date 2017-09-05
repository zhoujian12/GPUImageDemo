//
//  CameraViewController.m
//  GPUImageDemo
//
//  Created by jianz3 on 2017/8/30.
//  Copyright © 2017年 jianz3. All rights reserved.
//

#import "CameraViewController.h"
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "UIView+position.h"

#define KmainScreenWidth [UIScreen mainScreen].bounds.size.width
#define KmainScreenHeight [UIScreen mainScreen].bounds.size.height
#define KtabBarheight 64.0f


@interface CameraViewController ()

@property (nonatomic, strong) UIButton *effectButton; ///<
@property (nonatomic, strong) UIButton *tempBtn; ///<
@property (nonatomic, strong) UIButton *takePhotoBtn; ///<拍照按钮
@property (nonatomic, strong) GPUImageStillCamera *mCamera; ///<全局变量的相机
@property (nonatomic, strong) GPUImageFilter *mFilter; ///<滤镜
@property (nonatomic, strong) GPUImageView *mGPUImageView; ///<视图
@property (nonatomic, strong) UIView *btnBgView; ///<
@property (nonatomic, readonly) AVCaptureDevicePosition position; ///<摄像头的位置
@end

@implementation CameraViewController
#pragma mark - init
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    [self initData];
    
    
}

- (void)initData{
    
    //摄像头方向
    _position = AVCaptureDevicePositionBack;
    _mCamera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:_position];
    //手机横竖屏方向
    _mCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //创建滤镜
    _mFilter = [[GPUImageVignetteFilter alloc]init];
    //
    _mGPUImageView = [[GPUImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //添加滤镜到相机上
    [_mCamera addTarget:_mFilter];
    [_mFilter addTarget:_mGPUImageView];
    [self.view addSubview:_mGPUImageView];
    //启动相机
    [_mCamera startCameraCapture];
    
    [self.view bringSubviewToFront:self.effectButton];
    self.btnBgView.hidden = YES;
    
    [self createSelectBtn];
    [self.view addSubview:self.btnBgView];
    [self.view addSubview:self.takePhotoBtn];
//    [self.view addSubview:self.effectButton];
    
    _tempBtn = nil;
}

#pragma mark - setter && getter
- (UIView *)btnBgView{
    if (!_btnBgView) {
        _btnBgView = [[UIView alloc]initWithFrame:CGRectMake(80, KmainScreenHeight - 250, KmainScreenWidth - 80, 80)];
        _btnBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
    }
    return _btnBgView;
}


- (UIButton *)takePhotoBtn{
    if (!_takePhotoBtn) {
        _takePhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _takePhotoBtn.frame = CGRectMake((KmainScreenWidth - 80)/2, KmainScreenHeight - 100, 80, 80);
        [_takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
        [_takePhotoBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoBtn;
}

- (UIButton *)effectButton{
    if (!_effectButton) {
        _effectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _effectButton.frame = CGRectMake(KmainScreenWidth - 80, KmainScreenHeight - 250, 80, 80);
        [_effectButton setTitle:@"滤镜" forState:UIControlStateNormal];
        [_effectButton addTarget:self action:@selector(effectAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _effectButton;
}


#pragma mark - private method
- (void)takePhoto:(UIButton *)btn{
    __weak CameraViewController *weakSelf = self;
    [_mCamera capturePhotoAsJPEGProcessedUpToFilter:_mFilter
                              withCompletionHandler:^(NSData *processedJPEG, NSError *error) {
        //可用PhotoKit 替换
        UIImage *image = [UIImage imageWithData:processedJPEG];
        [weakSelf loadImageFinished:image];
        
         }
    ];
}

//拍照保存到相册
- (void)loadImageFinished:(UIImage *)image
{
    NSMutableArray *imageIds = [NSMutableArray array];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        //写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        //记录本地标识，等待完成后取到相册中的图片对象
        [imageIds addObject:req.placeholderForCreatedAsset.localIdentifier];
        
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
        NSLog(@"success = %d, error = %@", success, error);
        
        if (success)
        {
            //成功后取相册中的图片对象
            __block PHAsset *imageAsset = nil;
            PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:imageIds options:nil];
            [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                imageAsset = obj;
                *stop = YES;
                
            }];
            
            if (imageAsset)
            {
                //加载图片数据
                [[PHImageManager defaultManager] requestImageDataForAsset:imageAsset
                                                                  options:nil
                                                            resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                                
                                                                NSLog(@"imageData = %@", imageData);
                                                                
                                                            }];
            }
            
            UILabel *label = [UILabel new];
            label.text = @"照片已保存至相册～～";
            label.font = [UIFont systemFontOfSize:14];
            label.backgroundColor = [UIColor redColor];
            label.textColor = [UIColor blueColor];
            CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName:label.font}];
            label.frame = CGRectMake((KmainScreenWidth - (size.width + 10))/2, (KmainScreenHeight - (size.height + 10))/2, size.width + 10, size.height + 10);
            
            [self.view addSubview:label];
            
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [label removeFromSuperview];
//            });
            
        }
        
    }];
}


- (void)createSelectBtn{

    for (NSInteger i = 0; i < 5; i++) {
        CGFloat x = (KmainScreenWidth - 8)/5 * i + 2 * i;
        NSArray *arr = @[@"伽马线",@"褐色",@"卡通",@"浮雕",@"晕影"];
        UIButton *btn =  [self addSetBtn:[NSString stringWithFormat:@"%@效果",arr[i]] withBtnTag:i withBtnX:x];
        [self.view addSubview:btn];
    }
}

- (UIButton *)addSetBtn:(NSString *)btnTitle withBtnTag:(NSInteger)btnTag withBtnX:(CGFloat)btnX{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, KtabBarheight , (KmainScreenWidth - 8)/5, 80);
    btn.tag = btnTag + 100;
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    [btn addTarget:self action:@selector(bnAction:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)bnAction:(UIButton *)btn{
 
    switch (btn.tag) {
        case (100):{
            GPUImageGammaFilter *mfilter = [[GPUImageGammaFilter alloc]init];
            [self changeEffect:mfilter  withBtn:btn];
        }
            break;
            
        case (101):{
            GPUImageSepiaFilter *mfilter = [[GPUImageSepiaFilter alloc]init];
            [self changeEffect:mfilter  withBtn:btn];
        }
            break;
            
        case (102):{
            GPUImageToonFilter *mfilter = [[GPUImageToonFilter alloc]init];
            [self changeEffect:mfilter  withBtn:btn];
        }
            break;
            
        case (103):{
            GPUImageEmbossFilter *mfilter = [[GPUImageEmbossFilter alloc]init];
            [self changeEffect:mfilter  withBtn:btn];
        }
            break;
            
        case (104):{
            GPUImageVignetteFilter *mfilter = [[GPUImageVignetteFilter alloc]init];
            [self changeEffect:mfilter  withBtn:btn];
        }
            break;
            
        default:
            break;
    }
}

- (void)changeEffect:(GPUImageFilter *)mFilter withBtn:(UIButton *)btn{
    
    for (int i = 100; i < 105; i++) {
        if (i == btn.tag) {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }else{
            UIButton *button =  (UIButton *)[self.view viewWithTag:i];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    [_mCamera removeTarget:_mFilter];
    _mFilter = mFilter;
    [_mCamera addTarget:_mFilter];
    [_mFilter addTarget:_mGPUImageView];
    [self resumeState];
}

- (void)effectAction{
    if (self.btnBgView.hidden) {
        [UIView animateWithDuration:1 animations:^{
            self.btnBgView.transform = CGAffineTransformMakeTranslation(- KmainScreenWidth, 0);
        }];
        
        self.btnBgView.hidden = NO;
    }else{
        
        [self resumeState];
    }
}

- (void)resumeState{
    [UIView animateWithDuration:1.0
                     animations:^{
                         
                         self.btnBgView.transform = CGAffineTransformMakeTranslation(KmainScreenWidth, 0);
                     }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                   ^{
                       self.btnBgView.hidden = YES;
                   });
    
}
@end
