//
//  CustomCollectionView.m
//
//  Created by Phil on 2016/12/15.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "CustomCollectionView.h"

@interface CustomCollectionView ()

@property (nonatomic, copy) void (^reloadDataCompletionBlock)(void);

@end

@implementation CustomCollectionView

- (void)reloadDataWithCompletion:(void (^)(void))completionBlock
{
    self.reloadDataCompletionBlock = completionBlock;
    [super reloadData];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.reloadDataCompletionBlock) {
        self.reloadDataCompletionBlock();
        self.reloadDataCompletionBlock = nil;
    }
}

@end
