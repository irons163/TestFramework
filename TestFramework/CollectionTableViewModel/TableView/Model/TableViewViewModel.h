//
//  ProfileViewModel.h
//  demo
//
//  Created by Phil on 2019/5/8.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <IRCollectionTableViewModel/IRCollectionTableViewModel.h>
#import "TableViewSectionType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ProfileRowType){
    RowType_DemoRow
};

@interface TableViewRowItem : RowBasicModelItem
@property (readonly) ProfileRowType type;
@end

@protocol TableViewViewModelDelegate <NSObject>
- (void)willEdit;
- (void)didEdit;
- (void)needReload;
@end

@interface TableViewViewModel : TableViewBasicViewModel<UITableViewDataSource>
@property (weak) id<TableViewViewModelDelegate> delegate;
@property (strong) NSString *title;
@property BOOL isEditMode;

- (instancetype)initWithTableView:(UITableView*)tableView;
- (void)update;
@end

NS_ASSUME_NONNULL_END
