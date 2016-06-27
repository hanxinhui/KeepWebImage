//
//  ViewController.h
//  KeepWebImage
//
//  Created by 韩新辉 on 16/6/27.
//  Copyright © 2016年 韩新辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong)UIView       *bgView;

@property(strong,nonatomic)NSString           *imgString;//传递的图片路径

@end

