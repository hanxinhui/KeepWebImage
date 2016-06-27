//
//  ViewController.m
//  KeepWebImage
//
//  Created by 韩新辉 on 16/6/27.
//  Copyright © 2016年 韩新辉. All rights reserved.
//

#import "ViewController.h"
#import "WebPhotoKeep.h"

#define WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define HEIGHT ([[UIScreen mainScreen] bounds].size.height)
@interface ViewController ()

@property (strong, nonatomic) WebPhotoKeep *imageBgView;//背景


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ComesTongzhi:) name:@"hanxinhui" object:nil];
    [self getMyWebView];
    
    
}

-(void)getMyWebView{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _webView.delegate = self;
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    _webView.scalesPageToFit = YES;//自动适应屏幕
    _webView.userInteractionEnabled = YES;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"photo.html" ofType:nil];
    
    NSURL *url = [NSURL URLWithString:path];
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_webView];
}

-(void)ComesTongzhi:(NSNotification*)center{
    
    NSArray *arr = [center object];
    _imgString = arr[0];
    
}



-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    
    _imageBgView = [[WebPhotoKeep alloc] init];
    _imageBgView.frame = CGRectMake(0, 0,WIDTH, HEIGHT);
    [_imageBgView setBackgroundColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1]];
    _imageBgView.userInteractionEnabled = YES;
    _imageBgView.hidden = YES;
    [_imageBgView showImageString];
    [self.view addSubview:_imageBgView];
    
    [self.webView stringByEvaluatingJavaScriptFromString:_imgString];
    NSString *resurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    NSLog(@"-----> %@",resurlt);
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    
}

-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType{
    
    
    NSString *requestString = [[request URL] absoluteString];
    
    
    if ([requestString hasPrefix:@"web:imgClick:"]) {
        
        NSString *imageUrl = [requestString substringFromIndex:@"web:imgClick:".length];
        
        NSLog(@"image url------%@", imageUrl);
        
        if (!_imageBgView) {
            
            _imageBgView.hidden = NO;
            NSURL *url = [NSURL URLWithString:imageUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [UIImage imageWithData:data];
            _imageBgView.imgView.image = img;
            
        }
        else{
            [self showBigImage:imageUrl];
        }
        
        
        return NO;
        
    }
    
    return YES;
}
#pragma mark 显示大图片

-(void)showBigImage:(NSString *)imageUrl{
   
    _imageBgView.hidden = NO;
    [_imageBgView showBigImage:imageUrl andBgview:_imageBgView];
    
    //添加捏合手势
    [_imageBgView.imgView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
    
    //长按
    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressReger.minimumPressDuration = 1.0;//长按1秒
    [_imageBgView.imgView addGestureRecognizer:longPressReger];
    
    //单击
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    singleFingerOne.delegate = self;
    [_imageBgView.imgView addGestureRecognizer:singleFingerOne];
    
    
}

#pragma UIPinchGestureRecognizer
- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer{
    
    //缩放:设置缩放比例
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
    
}

#pragma UILongPressGestureRecognizer
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        [self handleLongTouch];
    }
    
}

#pragma UITapGestureRecognizer
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender{
    
    if (sender.numberOfTapsRequired == 1) {
        //单指单击
        _imageBgView.hidden = YES;
        
    }
}

#pragma 长按事件相应方法
-(void)handleLongTouch{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"  message:@"是否保存图片"   preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UIImageWriteToSavedPhotosAlbum(_imageBgView.imgView.image, nil, nil, nil);
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hanxinhui" object:self];

        
    }]];
    
    [alertController addAction: [UIAlertAction actionWithTitle: @"取消" style: UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        _imageBgView.hidden = YES;

        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hanxinhui" object:self];

        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
