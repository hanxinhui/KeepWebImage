//
//  WebPhotoKeep.h
//  keepWebPhoto
//
//  Created by 韩新辉 on 16/6/23.
//  Copyright © 2016年 韩新辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPhotoKeep : UIView
@property(strong,nonatomic)UIImageView         *imgView;/**显示当前点击的图片*/
-(void)showImageString;
-(void)showBigImage:(NSString *)imageUrl andBgview:(UIView*)bgVIew;
@end
