//
//  MonitorViewModel.m
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "MonitorViewModel.h"
#import "MonitorFolderTableViewCell.h"
#import "MonitorFileTableViewCell.h"
#import "FolderFactory.h"
#import "Utility.h"

@implementation MonitorRowItem
@dynamic type;
@end

@interface MonitorSectionItem : SectionBasicModelItem
@property (nonatomic) NSString* sectionTitle;
@property (nonatomic) SectionType type;
@end

@implementation MonitorSectionItem
@end

@interface MonitorViewModel()
{
    
}
@end

@implementation MonitorViewModel {
    NSArray *folderRowItems;
    NSArray *fileRowItems;
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        [tableView registerNib:[UINib nibWithNibName:MonitorFolderTableViewCell.identifier bundle:nil] forCellReuseIdentifier:MonitorFolderTableViewCell.identifier];
        [tableView registerNib:[UINib nibWithNibName:MonitorFileTableViewCell.identifier bundle:nil] forCellReuseIdentifier:MonitorFileTableViewCell.identifier];
    }
    return self;
}

- (void)update {
    [self setupRows];
    [items removeAllObjects];
    [self initItemsAddToArray:items];
}

- (void)setupRows {
    items = [[NSMutableArray<id<SectionModelItem>> alloc] init];
    folderRowItems = nil;
    fileRowItems = nil;
    
    NSMutableArray *rowItems = [NSMutableArray array];
    for (NSInteger i = 0; i < _currentFolder.childFolders.count; i++) {
        [rowItems addObject:[[MonitorRowItem alloc] initWithType:RowType_Folder withTitle:@""]];
    }
    folderRowItems = [NSArray arrayWithArray:rowItems];
    
    [rowItems removeAllObjects];
    for (NSInteger i = 0; i < _currentFolder.childFiles.count; i++) {
        [rowItems addObject:[[MonitorRowItem alloc] initWithType:RowType_File withTitle:@""]];
    }
    fileRowItems = [NSArray arrayWithArray:rowItems];
}

- (void)initItemsAddToArray:(NSMutableArray<id<SectionModelItem>>*)items {
    [items removeAllObjects];
    
    MonitorSectionItem *item = [[MonitorSectionItem alloc] initWithRowCount:[folderRowItems count]];
    item.type = FolderSectionType;
    item.sectionTitle = [NSString stringWithFormat:@"Folder (%ld)", item.rowCount];
    [items addObject:item];
    item = [[MonitorSectionItem alloc] initWithRowCount:[fileRowItems count]];
    item.type = FileSectionType;
    item.sectionTitle = [NSString stringWithFormat:@"File (%ld)", item.rowCount];
    [items addObject:item];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return items.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items[section] rowCount];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    id<SectionModelItem> item = [items objectAtIndex:indexPath.section];
    switch (item.type) {
        case FolderSectionType:
        {
            MonitorFolderTableViewCell *cell = (MonitorFolderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MonitorFolderTableViewCell.identifier forIndexPath:indexPath];
            Folder* folder = [FolderFactory createFolderWithDetph:3];
            cell.titleLbael.text = folder.name;
            cell.sizeLabel.text = [Utility formatStringWithSize:folder.size];
            
            MonitorRowType row = ((MonitorRowItem*)[folderRowItems objectAtIndex:[indexPath row]]).type;
            switch (row) {
                case RowType_Folder:
                {
//                    cell.arrowButtonClick = ^(UIButton *button) {
//                        MonitorRootViewController* rootView = [[MonitorRootViewController alloc] init];
//                        rootView.currentHV = hv;
//                        [self.owner presentViewController:rootView animated:YES completion:nil];
//                    };
                }
                    return cell;
                case RowType_File:
                    break;
            }
            break;
        }
        case FileSectionType:
        {
            MonitorFileTableViewCell *cell = (MonitorFileTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MonitorFileTableViewCell.identifier forIndexPath:indexPath];
            File* file = _currentFolder.childFiles[indexPath.row];
            cell.titleLbael.text = file.name;
            cell.sizeLabel.text = [Utility formatStringWithSize:file.size];
//            cell.apsCountLabel.text = [NSString stringWithFormat:@"%ld",network.apCounts];
//            cell.switchesCountLabel.text = [NSString stringWithFormat:@"%ld",network.switchCounts];
//            cell.clientsCountLabel.text = [NSString stringWithFormat:@"%ld",network.clientCounts];
            
            MonitorRowType row = ((MonitorRowItem*)[fileRowItems objectAtIndex:[indexPath row]]).type;
            switch (row) {
                case RowType_Folder:
                    break;
                case RowType_File:
                {
                    //configure right buttons
//                    MGSwipeButton* monitorButton = [[InventorySwipeButton alloc] initWithTitle:@"Monitor" icon:[UIImage imageNamed:@"ic_action_monitor"] ButtonStyle:LeftButtonStyle callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
//                        MonitorRootViewController* monitorRootView = [[MonitorRootViewController alloc] init];
//                        monitorRootView.currentNetwork = network;
//                        [self.owner presentViewController:monitorRootView animated:YES completion:nil];
//                        return YES;
//                    }];
                    
//                    cell.rightButtons = @[monitorButton];
                }
                    return cell;
            }
            break;
        }
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

@end
