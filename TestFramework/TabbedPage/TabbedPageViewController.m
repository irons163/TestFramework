//
//  TabbedPageViewController.m
//  TestFramework
//
//  Created by Phil on 2019/8/5.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "TabbedPageViewController.h"
#import "TabViewController.h"

@interface TabbedPageViewController ()

@end

@implementation TabbedPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)demoButtonClick:(id)sender {
    TabViewController *vc = [TabViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
