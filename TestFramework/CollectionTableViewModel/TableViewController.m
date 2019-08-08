//
//  TableViewController.m
//  demo
//
//  Created by Phil on 2019/7/30.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewViewModel.h"
#import "TableViewHeaderView.h"

@interface TableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation TableViewController {
    TableViewViewModel *viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:TableViewHeaderView.identifier bundle:nil] forHeaderFooterViewReuseIdentifier:TableViewHeaderView.identifier];
    viewModel = [[TableViewViewModel alloc] initWithTableView:_tableView];
    _tableView.dataSource = viewModel;
    [viewModel update];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableViewHeaderView* sectionHeaderView = (TableViewHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:TableViewHeaderView.identifier];
    sectionHeaderView.titleLabel.text = [viewModel getSectionTitleinSection:section];
    switch ([viewModel getSectionTypeinSection:section]) {
        case DemoSection:
            sectionHeaderView.titleLabel.text = [viewModel getSectionTitleinSection:section];
            break;
        default:
            break;
    }
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
