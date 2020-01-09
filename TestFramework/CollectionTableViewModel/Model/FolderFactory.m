//
//  FolderFactory.m
//  demo
//
//  Created by Phil on 2019/8/2.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "FolderFactory.h"

@implementation FolderFactory

+ (Folder *)createFolder {
    Folder *folder = [[Folder alloc] init];
    folder.childFolders = @[[FolderFactory createFolder], [FolderFactory createFolder]];
    folder.childFiles = @[[[File alloc] init], [[File alloc] init]];
    return folder;
}

+ (Folder *)createFolderWithDetph:(int)detph {
    if(detph < 0)
        return [[Folder alloc] init];
    Folder *folder = [[Folder alloc] init];
    folder.childFolders = @[[FolderFactory createFolderWithDetph:detph - 1], [FolderFactory createFolderWithDetph:detph - 1]];
    folder.childFiles = @[[[File alloc] init], [[File alloc] init]];
    return folder;
}

@end
