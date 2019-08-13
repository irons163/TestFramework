//
//  TabButtom.m
//  EnJet
//
//  Created by Phil on 2019/1/16.
//  Copyright © 2019年 Phil. All rights reserved.
//

#import "TabButtom.h"
//#import "UIColor+Helper.h"
//#import "ColorDefine.h"
//#import "Masonry.h"

@implementation TabButtom {
    CAGradientLayer *gradientLayer;
    NSMutableDictionary *bgColorForStates;
    NSMutableDictionary *radiusCornerForStates;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initButton];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initButton];
    }
    return self;
}

- (void)initButton {
    if (UIEdgeInsetsEqualToEdgeInsets(self.contentEdgeInsets, UIEdgeInsetsZero)) {
        [self setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    bgColorForStates = [NSMutableDictionary dictionary];
    radiusCornerForStates = [NSMutableDictionary dictionary];
    UIColor *bgColorForStateNormal = [UIColor blueColor];
    UIColor *bgColorForStateSelected = [UIColor yellowColor];
    UIColor *bgColorForStateHighlighted = [UIColor yellowColor];
    [bgColorForStates setObject:bgColorForStateNormal forKey:@(UIControlStateNormal)];
    [bgColorForStates setObject:bgColorForStateSelected forKey:@(UIControlStateSelected)];
    [bgColorForStates setObject:bgColorForStateHighlighted forKey:@(UIControlStateHighlighted)];
    self.radiusCorner = 0;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//    self.imageViewContentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.layer.borderColor = [UIColor.lightGrayColor CGColor];
    self.clipsToBounds = YES;
    self.tintColor = [UIColor clearColor];
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    
    gradientLayer = [CAGradientLayer layer];
    [self setGradientLayerFrame];
    gradientLayer.colors = @[(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor];
    gradientLayer.locations = @[@(0), @(1)];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.opacity = 0.3;
    
    [self setShowTopMask:YES];
    
//    UIView *v = [UIView new];
//    v.alpha = 0.5;
//    v.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    v.layer.shadowColor = [UIColor blackColor].CGColor;
//    v.layer.shadowOffset = CGSizeMake(0,3);
//    v.layer.shadowOpacity = 0.5;
//    v.layer.shadowRadius = 4;
//    v.layer.masksToBounds = NO;
//    [self addSubview:v];
//    [v mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self);
//        make.height.mas_equalTo(10);
//    }];
}

- (void)setGradientLayerFrame {
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, 7);
}

- (void)setShowTopMask:(BOOL)showTopMask {
    _showTopMask = showTopMask;
    
    if (_showTopMask) {
        if(![[self.layer sublayers] containsObject:gradientLayer])
            [self.layer addSublayer:gradientLayer];
    } else {
        if([[self.layer sublayers] containsObject:gradientLayer])
            [gradientLayer removeFromSuperlayer];
    }
}

- (void)setRadiusCorner:(CGFloat)radiusCorner {
    _radiusCorner = radiusCorner;
    
    for (NSNumber *state in bgColorForStates.allKeys) {
        UIColor *bgColor = bgColorForStates[state];
        if(bgColor) {
            if(!radiusCornerForStates[state])
                [self setBackgroundImage:[self imageFromColor:bgColor cornerRound:self.radiusCorner] forState:[state integerValue]];
        }
    }
}

- (void)setRadiusCorner:(CGFloat)radiusCorner forState:(UIControlState)state {
    [radiusCornerForStates setObject:@(radiusCorner) forKey:@(state)];
    UIColor *bgColor = bgColorForStates[@(state)];
    if(bgColor) {
        [self setBackgroundImage:[self imageFromColor:bgColor cornerRound:radiusCorner] forState:state];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setGradientLayerFrame];
    
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0,3);
//    self.layer.shadowOpacity = 0.5;
//    self.layer.shadowRadius = 4;
//    self.layer.masksToBounds = NO;
}

- (UIImage *)imageFromColor:(UIColor *)color cornerRound:(CGFloat)cornerRound {
    CGRect rect = CGRectMake(0, 0, 30, 30);
//    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft |
      UIRectCornerTopRight cornerRadii:CGSizeMake(cornerRound, cornerRound)] addClip];
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
//    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeTile];
    image = [image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    return image;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [bgColorForStates setObject:backgroundColor forKey:@(state)];
    [self setBackgroundImage:[self imageFromColor:backgroundColor cornerRound:radiusCornerForStates[@(state)] ? [radiusCornerForStates[@(state)] floatValue] : self.radiusCorner] forState:state];
}

@end
