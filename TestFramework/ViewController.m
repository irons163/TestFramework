//
//  ViewController.m
//  TestFramework
//
//  Created by Phil on 2019/7/24.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "ViewController.h"
#import "SingleButtonGroupViewController.h"
#import "PopupMenuViewController.h"
#import "DataPickerViewController.h"
#import "TabbedPageViewController.h"
#import "CollectionTableViewModelViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)singleButtonGroupButtonClick:(id)sender {
    SingleButtonGroupViewController *vc = [SingleButtonGroupViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)PopupMenuViewButtonClick:(id)sender {
    PopupMenuViewController *vc = [PopupMenuViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)dataPickerButtonClick:(id)sender {
    DataPickerViewController *vc = [DataPickerViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tabbedPageButtonClick:(id)sender {
    TabbedPageViewController *vc = [TabbedPageViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)collectionTableViewModelButtonClick:(id)sender {
    CollectionTableViewModelViewController *vc = [CollectionTableViewModelViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
