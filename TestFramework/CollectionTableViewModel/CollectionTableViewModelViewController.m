//
//  CollectionTableViewModelViewController.m
//  TestFramework
//
//  Created by Phil on 2019/8/6.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "CollectionTableViewModelViewController.h"
#import "TableViewController.h"
#import "CollectionViewController.h"

@interface CollectionTableViewModelViewController ()

@end

@implementation CollectionTableViewModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)tableviewButtonClick:(id)sender {
    TableViewController *tableViewController = [[TableViewController alloc] init];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (IBAction)collectionViewButtonClick:(id)sender {
    CollectionViewController *collectionViewController = [[CollectionViewController alloc] init];
    [self.navigationController pushViewController:collectionViewController animated:YES];
}

@end
