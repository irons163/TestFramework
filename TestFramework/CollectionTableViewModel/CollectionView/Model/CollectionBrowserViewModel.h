//
//  MonitorBrowserViewModel.h
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <IRCollectionTableViewModel/IRCollectionTableViewModel.h>
#import "Monitorable.h"
#import "CollectionBrowserSectionType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MonitorBrowserRowType){
    RowType_Folder,
    RowType_File
};

@interface CollectionBrowserRowItem : RowBasicModelItem
@property (readonly) MonitorBrowserRowType type;
@end

@interface CollectionBrowserViewModel : TableViewBasicViewModel<UICollectionViewDataSource>
@property (weak) NSArray<id<Monitorable>> *monitors;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;
- (void)update;
@end

NS_ASSUME_NONNULL_END
