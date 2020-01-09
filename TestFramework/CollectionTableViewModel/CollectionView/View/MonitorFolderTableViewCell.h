//
//  MonitorFolderTableViewCell.h
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorFolderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbael;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

+ (NSString*)identifier;
@end

NS_ASSUME_NONNULL_END
