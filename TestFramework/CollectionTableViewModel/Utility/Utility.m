//
//  Utility.m
//  demo
//
//  Created by Phil on 2019/8/5.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSString *) formatStringWithSize:(CGFloat)size {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    [numberFormatter setMinimumIntegerDigits:1];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundUp];
    
    NSString *roundedString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:size]];
    return roundedString;
}

@end
