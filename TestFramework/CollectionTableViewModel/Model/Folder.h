//
//  Folder.h
//  demo
//
//  Created by Phil on 2019/8/2.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "File.h"

NS_ASSUME_NONNULL_BEGIN

@interface Folder : NSObject

@property NSArray<Folder *> *childFolders;
@property NSArray<File *> *childFiles;

@property NSString *name;
@property (nonatomic) CGFloat size;

@end

NS_ASSUME_NONNULL_END
