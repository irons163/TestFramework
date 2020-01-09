//
//  MonitorViewModel.h
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <IRCollectionTableViewModel/IRCollectionTableViewModel.h>
#import "MonitorSectionType.h"
#import "FolderFactory.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MonitorRowType){
    RowType_Folder,
    RowType_File
};

@interface MonitorRowItem : RowBasicModelItem
@property (readonly) MonitorRowType type;
@end

@interface MonitorViewModel : TableViewBasicViewModel<UITableViewDataSource>

- (instancetype)initWithTableView:(UITableView*)tableView;
- (void)update;

@property (nonatomic) Folder* currentFolder;

@end

NS_ASSUME_NONNULL_END
