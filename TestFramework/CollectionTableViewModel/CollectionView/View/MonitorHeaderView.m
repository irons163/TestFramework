//
//  MonitorHeaderView.m
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "MonitorHeaderView.h"

@implementation MonitorHeaderView

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.sortButton.hidden = YES;
}

+ (NSString*)identifier{
    return NSStringFromClass([self class]);
}

- (IBAction)sortButtonClick:(id)sender {
}

@end
