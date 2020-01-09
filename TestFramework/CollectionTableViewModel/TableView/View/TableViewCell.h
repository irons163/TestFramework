//
//  ProfileTableViewCell.h
//  demo
//
//  Created by Phil on 2019/5/8.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *editTextField;

+ (NSString*)identifier;
@end

NS_ASSUME_NONNULL_END
