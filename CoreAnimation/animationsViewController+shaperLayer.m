//
//  animationsViewController+DisplayLink.m
//  CoreAnimation
//
//  Created by Orangels on 16/11/24.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "animationsViewController+shaperLayer.h"

@implementation animationsViewController (shaperLayer)

- (void)creatUIByShaperLayer{
    [self creatImageCirle];
//    [self creatSystemCirle];
}

- (void)creatUIByDisplayLink {
    [self creatSystemCirle];
//    [self creatImageCirle];
}

- (void)creatImageCirle{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.center = self.view.center;
    UIImage* image = [UIImage imageNamed:@"Image1"];
    view.layer.contents = (__bridge id)image.CGImage;
    view.layer.contentsGravity = kCAGravityCenter;
    view.layer.contentsScale = [UIScreen mainScreen].scale;
    [self.view addSubview:view];
    
    CAShapeLayer* shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = view.bounds;
    shapeLayer.position = CGPointMake(50, 50);
    shapeLayer.strokeEnd = 0.;
    shapeLayer.strokeStart = 0.;
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:view.bounds];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    //画笔宽度是左右增加, 要增加整个半径那么大,就要设置直径的长度
    shapeLayer.lineWidth = 100;
    view.layer.mask = shapeLayer;
    
    CABasicAnimation* basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.duration = 2;
    basicAnimation.repeatCount = HUGE_VAL;
    basicAnimation.toValue = @1.0;
    [shapeLayer addAnimation:basicAnimation forKey:nil];
    
    
}

- (void)creatSystemCirle{
    CGRect rect = CGRectMake(0, 0, 100, 100);
    UIBezierPath* rectP   = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.];
    UIBezierPath* circleP = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(10, 10, 80, 80)];
    //这里圆的计算, 要考虑到最后线的宽,当线宽为35时,画出的圆时间直径是70
    //画一个直径是35的圆(为了起点正确),线宽应该是实际先要的圆的半径,这样实际画出的圆 直径是70
    UIBezierPath* AnimationP = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(65/2, 65/2, 35, 35)];
    
    [rectP appendPath:circleP];

    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.bounds = rect;
    layer.position = self.view.center;
    layer.path = rectP.CGPath;
    layer.fillColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    layer.fillRule = kCAFillRuleEvenOdd;
    [self.view.layer addSublayer:layer];
    
    self.animationLayer = [CAShapeLayer layer];
    self.animationLayer.frame = CGRectMake(0, 0, 100, 100);
    self.animationLayer.position = self.view.center;
    self.animationLayer.path = AnimationP.CGPath;
    self.animationLayer.fillColor = [UIColor clearColor].CGColor;
    self.animationLayer.strokeColor = [UIColor redColor].CGColor;
    self.animationLayer.strokeEnd = 1.;
    self.animationLayer.strokeStart = 0.;
    self.animationLayer.lineWidth = 35;
//    layer.mask = self.animationLayer;
    [self.view.layer addSublayer:self.animationLayer];
    
    
    CABasicAnimation* basicAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.duration = 2;
    basicAnimation.repeatCount = HUGE_VAL;
    basicAnimation.toValue = @0.0;
    [self.animationLayer addAnimation:basicAnimation forKey:nil];
    
    
    self.animationLayer = [CAShapeLayer layer];
    self.animationLayer.frame = CGRectMake(0, 0, 200, 200);//设置shapeLayer的尺寸和位置
    self.animationLayer.position = self.view.center;
    self.animationLayer.fillColor = [UIColor clearColor].CGColor;//填充颜色为ClearColor
    
    
    //    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(add) userInfo:nil repeats:YES];
}

- (void)add{
    if (self.animationLayer.strokeEnd <= 0) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        self.animationLayer.strokeEnd = 1.0;
        [CATransaction setDisableActions:NO];
        [CATransaction commit];
    }else{
        self.animationLayer.strokeEnd -= 0.1;
    }
}


@end
