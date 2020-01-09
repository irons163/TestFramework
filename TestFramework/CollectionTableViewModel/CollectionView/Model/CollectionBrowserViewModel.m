//
//  MonitorBrowserViewModel.m
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "CollectionBrowserViewModel.h"
#import "MonitorFolderCollectionViewCell.h"
#import "MonitorFileCollectionViewCell.h"
#import "MonitorableFolderClass.h"
#import "MonitorableFileClass.h"
#import "Utility.h"

@implementation CollectionBrowserRowItem
@dynamic type;
@end

@interface CollectionBrowserSectionItem : SectionBasicModelItem
@property (nonatomic) NSString* sectionTitle;
@property (nonatomic) SectionType type;
@end

@implementation CollectionBrowserSectionItem
@end

@interface CollectionBrowserViewModel()
@end

@implementation CollectionBrowserViewModel

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    if (self = [super init]) {
        items = [[NSMutableArray<id<SectionModelItem>> alloc] init];
        
        [collectionView registerNib:[UINib nibWithNibName:MonitorFolderCollectionViewCell.identifier bundle:nil] forCellWithReuseIdentifier:MonitorFolderCollectionViewCell.identifier];
        [collectionView registerNib:[UINib nibWithNibName:MonitorFileCollectionViewCell.identifier bundle:nil] forCellWithReuseIdentifier:MonitorFileCollectionViewCell.identifier];
    }
    return self;
}

- (void)update {
    [items removeAllObjects];
    [self setupRows];
}

- (void)setupRows {
    NSMutableArray *rowItems = [NSMutableArray array];
    for (id<Monitorable> monitorable in self.monitors) {
        if ([monitorable isKindOfClass:[MonitorableFolderClass class]]) {
            [rowItems addObject:[[CollectionBrowserRowItem alloc] initWithType:RowType_Folder withTitle:@""]];
        } else if([monitorable isKindOfClass:[MonitorableFileClass class]]) {
            [rowItems addObject:[[CollectionBrowserRowItem alloc] initWithType:RowType_File withTitle:@""]];
        }
    }
    NSArray *inventoryRowItems = [NSArray arrayWithArray:rowItems];
    
    CollectionBrowserSectionItem *item = [[CollectionBrowserSectionItem alloc] initWithRowCount:[inventoryRowItems count]];
    item.type = Monitorable;
    item.rows = inventoryRowItems;
    [items addObject:item];
    
    [self setupRowTag];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return items.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [items[section] rowCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<SectionModelItem> item = [items objectAtIndex:indexPath.section];
    switch (item.type) {
        case Monitorable:
        {
            CollectionBrowserRowItem *row = (CollectionBrowserRowItem *)[item.rows objectAtIndex:[indexPath row]];
            switch (row.type) {
                case RowType_Folder:
                {
                    MonitorFolderCollectionViewCell *cell = (MonitorFolderCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MonitorFolderCollectionViewCell.identifier forIndexPath:indexPath];
                    
                    MonitorableFolderClass *folder = [self.monitors objectAtIndex:indexPath.row];
                    cell.titleLabel.text = folder.name;
                    cell.itemsCountLabel.text = [NSString stringWithFormat:@"%ld", (long)folder.count];
                    cell.sizeLabel.text = [Utility formatStringWithSize:folder.size];
//                    cell.networksCountLabel.text = [NSString stringWithFormat:@"%ld", hv.networksCounts];
//                    cell.apsCountLabel.text = [NSString stringWithFormat:@"%ld", hv.apCounts];
//                    cell.switchesCountLabel.text = [NSString stringWithFormat:@"%ld", hv.switchCounts];
                    return cell;
                }
                case RowType_File:
                {
                    MonitorFileCollectionViewCell *cell = (MonitorFileCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MonitorFileCollectionViewCell.identifier forIndexPath:indexPath];
                    
                    MonitorableFileClass *file = [self.monitors objectAtIndex:indexPath.row];
                    cell.titleLabel.text = file.name;
                    cell.sizeLabel.text = [Utility formatStringWithSize:file.size];
                    return cell;
                }
            }
            break;
        }
        default:
            break;
    }
    return [[UICollectionViewCell alloc] init];
}

@end
