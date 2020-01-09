//
//  TableViewHeaderView.h
//  demo
//
//  Created by Phil on 2019/8/5.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *editTextField;

+ (NSString*)identifier;

@end

NS_ASSUME_NONNULL_END
