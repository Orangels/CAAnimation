//
//  animationsViewController.m
//  CoreAnimation
//
//  Created by Orangels on 16/11/22.
//  Copyright © 2016年 ls. All rights reserved.
//

#import "animationsViewController.h"
#import "animationsViewController+shaperLayer.h"
#import "UIImageView+GifTool.h"
@interface animationsViewController ()
@property (nonatomic ,strong)UIImageView* imageView;
@end

@implementation animationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self creatUI];
}

- (void)creatUI{
    switch (_type) {
        case basicAnimation: {
            [self creatUIByBasicAnimation];
            break;
        }
        case keyframeAnimation: {
            [self creatUIByKeyAnimation];
            break;
        }
        case AnimationGroup: {
            [self creatUIByAnimationGroup];
            break;
        }
        case Transition: {
            [self creatUIByTransition];
            break;
        }
        case DisplayLink: {
            [self creatUIByShaperLayer];
            break;
        }
        case gif: {
            [self creatByWithGif];
            break;
        }
        case replicatorLayer: {
            [self creatReplicatorLayer];
            break;
        }
        case transform3D_m34: {
            [self creatCATransform3D_m34];
            break;
        }
        case transformLayer: {
            [self creatTransformLayer];
        }
    }
}

- (void)creatUIByBasicAnimation {
    UIView* redView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    //keyPath 是 layer 的属性,属性支持Animatable,作为 keypath 才有效果
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.duration = 2;
    animation.repeatCount = HUGE_VALF;
    //anchorPoint 的位置
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 300)];
    //调用 addAnimation forKey 时,系统对传入的 animation 进行了 copy,然后 copy 的这份添加
    //到了 layer 上,这时再更改 animation 是没有效果的
    [redView.layer addAnimation:animation forKey:nil];
}

- (void)creatUIByKeyAnimation {
    UIView* redView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[[NSValue valueWithCGPoint:CGPointMake(50, 64+100/2)],[NSValue valueWithCGPoint:CGPointMake(200, 64+300/2)],[NSValue valueWithCGPoint:CGPointMake(50, 64+500/2)]];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBackwards;
    animation.duration = 3;
    animation.repeatCount = HUGE_VALF;
    animation.calculationMode = kCAAnimationCubicPaced;
//    animation.keyTimes = @[@0,@0.8,@1];
    //设置 path,path 会取代 values
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100, 100)];
    //四个路径,要设置5个值得 keytimes
    animation.keyTimes = @[@0,@0.1,@0.2,@0.9,@1];
    animation.path = path.CGPath;
    
    [redView.layer addAnimation:animation forKey:nil];
}

- (void)creatUIByAnimationGroup{
    UIView* redView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 100, 100)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    //位置动画 keyanimation
    CAKeyframeAnimation* keyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyAnimation.duration = 2;
    keyAnimation.removedOnCompletion = NO;
    keyAnimation.fillMode = kCAFillModeForwards;
    keyAnimation.repeatCount = HUGE_VALF;
    keyAnimation.calculationMode = kCAAnimationCubicPaced;
    keyAnimation.keyTimes = @[@0,@0.25,@0.5,@0.75,@1];
    UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100, 100, 100, 100)];
    keyAnimation.path = path.CGPath;
    
    //cornerRadius动画 basic 动画
    CABasicAnimation* basicAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    basicAnimation.toValue = @50;
    basicAnimation.duration = 2;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.repeatCount = HUGE_VALF;
    
    //animationGroup
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[keyAnimation,basicAnimation];
    group.duration = 2;
    group.fillMode = kCAFillModeForwards;
    group.repeatCount = HUGE_VALF;
    
    [redView.layer addAnimation:group forKey:nil];
}

- (void)creatUIByTransition{
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 200, 200)];
    imageView.image = [UIImage imageNamed:@"Image1"];
    [self.view addSubview:imageView];
    imageView.tag = 100;
    
    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor cyanColor];
    [btn addTarget:self action:@selector(transitionClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)transitionClick:(UIButton*)btn {
    
    btn.selected ^= 1;
    
    CATransition* transition = [CATransition animation];
    transition.duration = 3;
    transition.fillMode = kCAFillModeForwards;
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromBottom;
    
    UIImageView* imageView = [self.view viewWithTag:100];
    [imageView.layer addAnimation:transition forKey:nil];
    imageView.image = btn.selected ? [UIImage imageNamed:@"Image2"] : [UIImage imageNamed:@"Image1"];
}

- (void)creatByWithGif{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"vvv" ofType:@"gif"];
    UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 300, 200) gifPathString:path repeatCount:HUGE_VALF];
    iv.tag = 200;
    [self.view addSubview:iv];
    
    UIButton* playBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 50, 50)];
    [playBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [playBtn setTitle:@"播放" forState: UIControlStateSelected];
    playBtn.backgroundColor = [UIColor grayColor];
    playBtn.layer.cornerRadius = 5;
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    
    UIButton* invalidBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 400, 50, 50)];
    [invalidBtn setTitle:@"销毁" forState: UIControlStateNormal];
    invalidBtn.backgroundColor = [UIColor grayColor];
    invalidBtn.layer.cornerRadius = 5;
    [invalidBtn addTarget:self action:@selector(invalidBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:invalidBtn];
    
    
}

- (void)playBtnClick:(UIButton*)btn{
    btn.selected ^= 1;
    UIImageView* iv = [self.view viewWithTag:200];
    if (btn.selected) {
        [iv suspendGif];
    }else{
        [iv resumeGif];
    }
}
- (void)invalidBtnClick:(UIButton*)btn{
    UIImageView* iv = [self.view viewWithTag:200];
    [iv invalidGif];
}


- (void)creatReplicatorLayer{
    CAShapeLayer* layer = [CAShapeLayer layer];
    UIBezierPath* path  = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 30, 30)];
    layer.path          = path.CGPath;
    layer.bounds        = CGRectMake(0, 0, 30, 30);
    layer.strokeColor   = [UIColor redColor].CGColor;
    layer.fillColor     = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
    //正方形点动画
    //[self qurareAnimation:layer];
    //三角形旋转动画
    //这里 要注意 layer 的 position, 注意方法里 position 的写法与正方形动画的区别(正方形动画不涉及位置移动)
    [self triangleAnimation:layer];
    
}
//正方形点动画
- (void)qurareAnimation:(CALayer*)layer {
    layer.opacity  = 0;
    
    CABasicAnimation* animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation1.removedOnCompletion = NO;
    animation1.fillMode     = kCAFillModeForwards;
    animation1.fromValue    = @0;
    animation1.toValue      = @1;
    animation1.duration     = 1.5;
    animation1.repeatCount  = HUGE_VALF;
    animation1.autoreverses = YES;
    
    CABasicAnimation* animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.removedOnCompletion = NO;
    animation2.fillMode = kCAFillModeForwards;
    animation2.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(2, 2, 2)];
    animation2.duration = 1.5;
    animation2.repeatCount = HUGE_VALF;
    animation2.autoreverses  = YES;
    
    CAAnimationGroup* animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[animation1,animation2];
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.duration = 1.5;
    animationGroup.repeatCount = HUGE_VALF;
    animationGroup.autoreverses  = YES;
    
    [layer addAnimation:animationGroup forKey:@"Group"];
    
    CAReplicatorLayer* rec1 = [CAReplicatorLayer layer];
    [rec1 addSublayer:layer];
    rec1.instanceCount = 3;
    rec1.instanceDelay = 0.5;
    rec1.instanceTransform = CATransform3DMakeTranslation(60, 0, 0);
    //    [self.view.layer addSublayer:rec1];
    
    CAReplicatorLayer* rec2 = [CAReplicatorLayer layer];
    [rec2 addSublayer:rec1];
    rec2.instanceDelay = 0.5;
    rec2.instanceCount = 3;
    rec2.instanceTransform = CATransform3DMakeTranslation(0, 60, 0);
    rec2.position = self.view.center;
    [self.view.layer addSublayer:rec2];
}
//三角形旋转动画
- (void)triangleAnimation:(CALayer*)layer {

    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CATransform3D transform = CATransform3DTranslate(CATransform3DIdentity, 90, 0, 0);
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, 0.0, 0.0, 0.0, 0.0)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(transform, M_PI/3*2, 0, 0, 1)];
    animation.autoreverses = NO;
    animation.duration = 1;
    animation.repeatCount = HUGE_VALF;
    
    [layer addAnimation:animation forKey:@"transform"];
    [self.view.layer addSublayer:layer];
    
    CAReplicatorLayer* rec = [CAReplicatorLayer layer];
    [rec addSublayer:layer];
    rec.instanceCount = 3;
    rec.instanceDelay = 0;
    CATransform3D trans3D              = CATransform3DIdentity;
    trans3D                            = CATransform3DTranslate(trans3D, 90, 0, 0);
    trans3D                            = CATransform3DRotate(trans3D, 2*M_PI/3, 0.0, 0.0, 1.0);
    rec.instanceTransform = trans3D;
    rec.position = CGPointMake(self.view.center.x-30, self.view.center.y);
    [self.view.layer addSublayer:rec];
    
}
//CATransform3D_m34 透视投影效果,近大远小效果
- (void)creatCATransform3D_m34 {
    CALayer* staticLayer = [CALayer layer];
    staticLayer.bounds = CGRectMake(0, 0, 100, 100);
    staticLayer.position = CGPointMake(self.view.center.x-75, self.view.center.y-100);
    staticLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:staticLayer];
    
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500;
    staticLayer.transform = transform;
    
    CALayer* testLayer = [CALayer layer];
    testLayer.bounds = CGRectMake(0, 0, 100, 100);
    testLayer.position = CGPointMake(self.view.center.x+75, self.view.center.y-100);
    testLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:testLayer];
    
    CABasicAnimation* animation1 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation1.removedOnCompletion = NO;
    animation1.fillMode = kCAFillModeForwards;
    animation1.duration = 1.5;
    animation1.autoreverses = YES;
    animation1.repeatCount = HUGE_VALF;
    animation1.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(staticLayer.transform, M_PI/3, 1, 0, 0)];
    [staticLayer addAnimation:animation1 forKey:nil];
    
    CABasicAnimation* animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.repeatCount = HUGE_VALF;
    animation2.duration = 1.5;
    animation2.autoreverses = YES;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    animation2.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(testLayer.transform, M_PI/3, 1, 0, 0)];
    [testLayer addAnimation:animation2 forKey:nil];
}

//CATransformLayer
- (void)creatTransformLayer {
    
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


































