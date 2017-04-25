//
//  UIImageView+GifTool.h
//  CoreAnimation
//
//  Created by Orangels on 16/11/28.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kImageViewGifFinish = @"kImageViewGifFinish";
static NSString * const kImageViewGifStart = @"kImageViewGifStart";
static NSString * const kImageViewGifCancel = @"kImageViewGifCancel";

@interface UIImageView (GifTool)
//保存动图每帧的数组
@property (nonatomic ,strong)NSMutableArray* gifArray;
//单次循环动图的持续时间
@property (nonatomic ,assign)CGFloat gifDuration;

//以frame,地址,循环次数生成imageView
- (instancetype)initWithFrame:(CGRect)frame gifPathString:(NSString *)path repeatCount:(CGFloat)repeatCount;
//以图片地址,循环次数生成 imageView
-(instancetype)initWithGifPathString:(NSString *)path repeatCount:(CGFloat)repeatCount;

//以图片地址及是否循环按图片大小穿件imageView
-(instancetype)initWithGifPathString:(NSString *)path repeat:(BOOL)repeat;

///恢复动图
-(void)resumeGif;

///暂停动图
-(void)suspendGif;

///销毁动图
-(void)invalidGif;

@end
