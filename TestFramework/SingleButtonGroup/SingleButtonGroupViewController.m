//
//  SingleButtonGroupViewController.m
//  TestFramework
//
//  Created by Phil on 2019/7/24.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "SingleButtonGroupViewController.h"
#import "SingleButtonTableViewCell.h"

@interface SingleButtonGroupViewController ()<UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SingleButtonGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:SingleButtonTableViewCell.identifier bundle:nil] forCellReuseIdentifier:SingleButtonTableViewCell.identifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    SingleButtonTableViewCell* cell =
    (SingleButtonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:SingleButtonTableViewCell.identifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"Single Button Selection Demo";
            [cell setDefaultIndex:0];
            cell.canMultiSelected = NO;
            cell.disableDeselection = YES;
            break;
        case 1:
            cell.titleLabel.text = @"Single Button Selection Demo: Deselect able";
            cell.canMultiSelected = NO;
            break;
        case 2:
            cell.titleLabel.text = @"Multi Buttons Selection Demo";
            cell.canMultiSelected = YES;
            break;
    }
    return cell;
}

@end
