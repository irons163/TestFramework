//
//  MonitorableNetworkClass.h
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Monitorable.h"

NS_ASSUME_NONNULL_BEGIN

@interface MonitorableFileClass : NSObject<Monitorable>

@property (nonatomic,strong) NSString* name;
@property (nonatomic) CGFloat size;

@end

NS_ASSUME_NONNULL_END
