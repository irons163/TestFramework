//
//  FolderFactory.h
//  demo
//
//  Created by Phil on 2019/8/2.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Folder.h"

NS_ASSUME_NONNULL_BEGIN

@interface FolderFactory : NSObject

+ (Folder *)createFolderWithDetph:(int)detph;

@end

NS_ASSUME_NONNULL_END
