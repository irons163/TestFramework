//
//  MonitorFolderTableViewCell.m
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "MonitorFolderTableViewCell.h"

@implementation MonitorFolderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)arrowButtonClick:(id)sender {
//    if (self.arrowButtonClick) {
//        self.arrowButtonClick(sender);
//    }
}


+ (NSString*)identifier{
    return NSStringFromClass([self class]);
}

@end
