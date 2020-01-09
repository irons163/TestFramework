//
//  Folder.m
//  demo
//
//  Created by Phil on 2019/8/2.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "Folder.h"

@implementation Folder

- (CGFloat)size {
    CGFloat size = 0;
    for (Folder *folder in self.childFiles) {
        size += folder.size;
    }
    for (File *file in self.childFiles) {
        size += file.size;
    }
    
    return size;
}

@end
