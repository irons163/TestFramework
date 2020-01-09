//
//  MonitorNetworkTableViewCell.m
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "MonitorFileTableViewCell.h"

@implementation MonitorFileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (NSString*)identifier{
    return NSStringFromClass([self class]);
}

@end
