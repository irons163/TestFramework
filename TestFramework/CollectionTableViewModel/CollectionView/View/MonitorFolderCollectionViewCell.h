//
//  MonitorFolderCollectionViewCell.h
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorFolderCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *switchesCountLabel;

+ (NSString*)identifier;
@end

NS_ASSUME_NONNULL_END
