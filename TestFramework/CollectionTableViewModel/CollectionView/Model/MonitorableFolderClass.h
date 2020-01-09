//
//  MonitorableFolderClass.h
//  demo
//
//  Created by Phil on 2019/5/20.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorableFolderClass : NSObject

@property (nonatomic,strong) NSString* name;
@property (nonatomic) CGFloat size;
@property (nonatomic) NSInteger count;

@end

NS_ASSUME_NONNULL_END
