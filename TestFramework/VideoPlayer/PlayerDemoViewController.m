//
//  PlayerDemoViewController.m
//  TestFramework
//
//  Created by Phil on 2019/10/14.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "PlayerDemoViewController.h"
#import "PlayerViewController.h"

@interface PlayerDemoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PlayerDemoViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = [PlayerViewController displayNameForDemoType:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PlayerViewController * obj = [[PlayerViewController alloc] init];
    obj.demoType = indexPath.row;
    [self.navigationController pushViewController:obj animated:YES];
}

@end
