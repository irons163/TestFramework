//
//  TabButtom.h
//  EnJet
//
//  Created by Phil on 2019/1/16.
//  Copyright © 2019年 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CustomIconButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabButtom : UIButton

@property (nonatomic) BOOL showTopMask;
@property (nonatomic) CGFloat radiusCorner;

- (void)setRadiusCorner:(CGFloat)radiusCorner forState:(UIControlState)state;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
