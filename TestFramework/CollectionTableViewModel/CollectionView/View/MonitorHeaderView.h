//
//  MonitorHeaderView.h
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;

- (IBAction)sortButtonClick:(id)sender;

+ (NSString*)identifier;
@end

NS_ASSUME_NONNULL_END
