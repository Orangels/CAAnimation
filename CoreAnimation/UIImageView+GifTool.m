//
//  UIImageView+GifTool.m
//  CoreAnimation
//
//  Created by Orangels on 16/11/28.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "UIImageView+GifTool.h"
#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
@implementation UIImageView (GifTool)

#pragma mark property
// cmd在Objective-C的方法中表示当前方法的selector，正如同self表示当前方法调用的对象实例。
-(NSMutableArray*)gifArray{
    NSMutableArray * arr = objc_getAssociatedObject(self, _cmd);
    if (!arr) {
        //array 初始化
        arr = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arr;
}
-(void)setGifArray:(NSMutableArray *)gifArray{
    objc_setAssociatedObject(self, @selector(gifArray), gifArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(CGFloat)gifDuration{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}
-(void)setGifDuration:(CGFloat)gifDuration{
    objc_setAssociatedObject(self, @selector(gifDuration), @(gifDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//这里地址都用本地 file 地址
- (instancetype)initWithFrame:(CGRect)frame gifPathString:(NSString *)path repeatCount:(CGFloat)repeatCount{
    if (self = [super initWithFrame:frame]) {
        NSURL* url = [NSURL fileURLWithPath:path];
        NSMutableArray* delayArr = [NSMutableArray arrayWithCapacity:10];
        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
        size_t count = CGImageSourceGetCount(imageSource);
        
        for (size_t i = 0; i<count; i++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            //core Foundition 和 Foundition 的转换,见 __Bridge几个关键字
            [self.gifArray addObject:CFBridgingRelease(image)];
            
            NSDictionary* dic = (NSDictionary*)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imageSource, i, NULL));
            [delayArr addObject:[[dic valueForKey:(NSString *)kCGImagePropertyGIFDictionary] valueForKey:@"DelayTime"]];
        }
        CGFloat totleTime = 0.;
        for (NSNumber* num in delayArr) {
            totleTime += num.floatValue;
        }
        self.gifDuration = totleTime;
        NSMutableArray* keyTimes = [NSMutableArray arrayWithCapacity:10];
        [keyTimes addObject:@0];
        CGFloat current = 0.;
        for (NSNumber* num in delayArr) {
            current += num.floatValue;
            [keyTimes addObject:@(current/totleTime)];
        }
        
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        animation.duration = self.gifDuration;
        animation.values = self.gifArray;
        animation.keyTimes = keyTimes;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = NO;
        animation.repeatCount = repeatCount;
        animation.delegate = self;
        self.clipsToBounds = YES;
        [self.layer addAnimation:animation forKey:@"gifAnimation"];

    }
    return self;
}

///恢复动图
-(void)resumeGif{
//    CFTimeInterval time = CACurrentMediaTime();
    CFTimeInterval startTime = self.layer.timeOffset;
    self.layer.beginTime = CACurrentMediaTime() - startTime;
    NSLog(@"begintime -- %f",self.layer.beginTime);
    self.layer.timeOffset = 0.;
    self.layer.speed = 1;
}

///暂停动图
-(void)suspendGif{
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.timeOffset = pauseTime;
    NSLog(@"timeOffset -- %f",pauseTime);
    self.layer.speed = 0.0;
}

///销毁动图
-(void)invalidGif{
    [self.layer removeAnimationForKey:@"gifAnimation"];
    self.layer.contents = self.gifArray[0];
}

#pragma mark animation delegate
-(void)animationDidStart:(CAAnimation *)anim{
    NSLog(@"动画开始");
}




@end



















