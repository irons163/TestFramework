//
//  ProfileViewModel.m
//  demo
//
//  Created by Phil on 2019/5/8.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "TableViewViewModel.h"
#import "TableViewCell.h"

@implementation TableViewRowItem
@dynamic type;
@end

@interface TableViewSectionItem : SectionBasicModelItem
@property (nonatomic) NSString* sectionTitle;
@property (nonatomic) SectionType type;
@end

@implementation TableViewSectionItem
@end

@interface TableViewViewModel()<UITextFieldDelegate>
@end

@implementation TableViewViewModel {
    NSMutableArray<NSString *> *editedTexts;
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    if (self = [super init]) {
        items = [[NSMutableArray<id<SectionModelItem>> alloc] init];
        
        [tableView registerNib:[UINib nibWithNibName:TableViewCell.identifier bundle:nil] forCellReuseIdentifier:TableViewCell.identifier];
    }
    return self;
}

- (void)update {
    [items removeAllObjects];
    [self setupRows];
}

- (void)setupRows {
    NSMutableArray *rowItems = [NSMutableArray array];
    [rowItems addObject:[[TableViewRowItem alloc] initWithType:RowType_DemoRow withTitle:@"Demo Row"]];
    [rowItems addObject:[[TableViewRowItem alloc] initWithType:RowType_DemoRow withTitle:@"Demo Row"]];
    NSArray *demoRowItems = [NSArray arrayWithArray:rowItems];
    editedTexts = [NSMutableArray array];
    for (int i = 0; i < demoRowItems.count; i++) {
        [editedTexts addObject:@""];
    }
    
    TableViewSectionItem *item = [[TableViewSectionItem alloc] initWithRowCount:[demoRowItems count]];
    item.type = DemoSection;
    item.sectionTitle = @"Demo Section";
    item.rows = demoRowItems;
    [items addObject:item];
    
    [self setupRowTag];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return items.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items[section] rowCount];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    id<SectionModelItem> item = [items objectAtIndex:indexPath.section];
    TableViewRowItem *row = (TableViewRowItem *)[item.rows objectAtIndex:[indexPath row]];
    
    switch (item.type) {
        case DemoSection:
        {
            switch (row.type) {
                case RowType_DemoRow:
                {
                    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableViewCell.identifier forIndexPath:indexPath];
                    cell.titleLabel.text = [NSString stringWithFormat:@"%@%ld", row.title, row.tagRange.location];
                    cell.editTextField.text = [editedTexts objectAtIndex:indexPath.row];
                    cell.editTextField.tag = row.tagRange.location;
                    cell.editTextField.delegate = self;
                    return cell;
                }
            }
            break;
        }
        default:
            break;
    }
    return [[UITableViewCell alloc] init];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    _isEditMode = NO;
//    [self.delegate didEdit];
    return [textField resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSString* newString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    
    NSIndexPath *indexPath = [self getIndexPathFromRowTag:textField.tag];
    id<SectionModelItem> item = [items objectAtIndex:indexPath.section];
    
    switch (item.type) {
        case DemoSection:
        {
            TableViewRowItem *row = (TableViewRowItem *)[item.rows objectAtIndex:[indexPath row]];
            
            switch (row.type) {
                case RowType_DemoRow:
                {
                    editedTexts[indexPath.row] = newString;
                }
            }
            break;
        }
        default:
            break;
    }
    
    return YES;
}

@end
