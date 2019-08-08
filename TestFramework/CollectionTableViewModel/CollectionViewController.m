//
//  CollectionViewController.m
//  IR_CollectionTableViewModel
//
//  Created by Phil on 2019/7/1.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "CollectionViewController.h"
#import "MonitorViewModel.h"
#import "MonitorHeaderView.h"
#import "MonitorableFolderClass.h"
#import "MonitorableFileClass.h"
#import "CollectionBrowser.h"

@interface CollectionViewController ()<UITableViewDelegate>
{
    __weak IBOutlet UIActivityIndicatorView *loadingIcon;
}
@property (weak, nonatomic) IBOutlet UIButton *notificationButton;
@property (weak, nonatomic) IBOutlet CollectionBrowser *monitorBrowser;
@property (weak, nonatomic) IBOutlet UIView *recentlyMonitoredView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)menuButtonClick:(id)sender;
- (IBAction)notificationButtonClick:(id)sender;
@end

@implementation CollectionViewController {
    MonitorViewModel* viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.recentlyMonitoredView.hidden = YES;
//    self.recentlyMonitoredViewHeight.constant = 170;
    
    viewModel = [[MonitorViewModel alloc] initWithTableView:self.tableView];
    viewModel.currentFolder = [FolderFactory createFolderWithDetph:3];
    [viewModel update];
    viewModel.owner = self;
    
    self.tableView.dataSource = viewModel;
    [self.tableView registerNib:[UINib nibWithNibName:MonitorHeaderView.identifier bundle:nil] forHeaderFooterViewReuseIdentifier:MonitorHeaderView.identifier];
    self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.tableView.tableFooterView = [UIView new];
    [self reloadData];
    
    [self setupMonitorBrowser];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReloadOrgsNotification:) name:DidReloadOrgsNotificationName object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLoading:YES];
        self->viewModel.currentFolder = [FolderFactory createFolderWithDetph:3];
        [self->viewModel update];
        [self reloadList];
        [self setupMonitorBrowser];
        [self showLoading:NO];
    });
}

- (void)reloadList
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)setupMonitorBrowser {
    // TODO, Here just demo.
    //    dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableArray *monitors = [NSMutableArray array];
    for (Folder *folder in self->viewModel.currentFolder.childFolders) {
        MonitorableFolderClass *monitorableFolder = [[MonitorableFolderClass alloc] init];
        monitorableFolder.name = folder.name;
        monitorableFolder.size = folder.size;
        monitorableFolder.count = folder.childFolders.count + folder.childFiles.count;
        [monitors addObject:monitorableFolder];
    }
    for (File *file in self->viewModel.currentFolder.childFiles) {
        MonitorableFileClass *monitorableFile = [[MonitorableFileClass alloc] init];
        monitorableFile.name = file.name;
        monitorableFile.size = file.size;
        [monitors addObject:monitorableFile];
    }
    self.monitorBrowser.monitors = monitors;
    [self.monitorBrowser reloadDataWithCompletion:nil];
    if([monitors count] > 0) {
        self.recentlyMonitoredView.hidden = NO;
    } else {
        self.recentlyMonitoredView.hidden = YES;
    }
    //    });
}

- (void)showLoading:(BOOL)isShow
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isShow) {
            self.notificationButton.hidden = YES;
            self.tableView.hidden = YES;
            [self->loadingIcon startAnimating];
            self.view.userInteractionEnabled = NO;
        }else{
            self.notificationButton.hidden = NO;
            self.tableView.hidden = NO;
            [self->loadingIcon stopAnimating];
            self.view.userInteractionEnabled = YES;
        }
    });
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(![viewModel getSectionTitleinSection:section]){
        return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MonitorHeaderView* sectionHeaderView = (MonitorHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:MonitorHeaderView.identifier];
    sectionHeaderView.titleLabel.text = [viewModel getSectionTitleinSection:section];
    switch ([viewModel getSectionTypeinSection:section]) {
        case FolderSectionType:
            sectionHeaderView.sortButton.hidden = NO;
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

#pragma mark - IBAction
- (IBAction)menuButtonClick:(id)sender {
    
}

- (IBAction)notificationButtonClick:(id)sender {
}

#pragma mark - NSNotification
- (void)didReloadOrgsNotification:(NSNotification *)notification
{
    [self reloadData];
}

@end

