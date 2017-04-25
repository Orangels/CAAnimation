//
//  animationsViewController.h
//  CoreAnimation
//
//  Created by Orangels on 16/11/22.
//  Copyright © 2016年 ls. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,animationType) {
    basicAnimation = 0,
    keyframeAnimation,
    AnimationGroup,
    Transition,
    DisplayLink,
    gif,
    replicatorLayer,
    transform3D_m34,
    transformLayer
};

@interface animationsViewController : UIViewController

@property (nonatomic ,assign)animationType type;
@property (nonatomic ,strong)CAShapeLayer* animationLayer;

@end
