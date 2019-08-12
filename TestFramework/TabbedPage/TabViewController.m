//
//  TabViewController.m
//  demo
//
//  Created by Phil on 2019/7/23.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "TabViewController.h"
#import "Page1ViewController.h"
#import "Page2ViewController.h"
#import "Page3ViewController.h"
#import <IRSingleButtonGroup/IRSingleButtonGroup.h>
#import "TabButtom.h"
#import <Masonry/Masonry.h>

@interface TabViewController ()<IRSingleButtonGroupDelegate, IRTabbedPageViewControllerDelegate> {
    IRTabBarView* tabBarView;
    IRSingleButtonGroup* singleButtonGroup;
    NSInteger checkCounter;
    NSTimer* checkTimer;
    NSURL* currentFilePath;
}

@property (nonatomic, strong) IRTabControllerStyle *style;

@end

@implementation TabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    self.tabbedDelegate = self;
    
    if(!self.tabBarView){
        tabBarView = [[IRTabBarView alloc] init];
        [self.view addSubview:tabBarView];
        [tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.mas_topLayoutGuideBottom).mas_offset(44);
        }];
        self.tabBarView = tabBarView;
        self.tabBarView.dataSource = self;
        self.tabBarView.delegate = self;
        self.tabBarView.hidden = NO;
    }
    
    _style = [IRTabControllerStyle styleWithName:@"Default"
                                        tabStyle:IRTabStyleCustomView
                                     sizingStyle:IRTabSizingStyleSizeToFit
                                  numberOfTabs:3];
    
    [self.style setSizingStyle:IRTabSizingStyleDistributed];
    
    [self.tabBarView setTransitionStyle:self.style.transitionStyle];
    self.tabBarView.tabStyle = self.style.tabStyle;
    self.tabBarView.sizingStyle = self.style.sizingStyle;
    self.tabBarView.tabPadding = 0;
    self.tabBarView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tabBarView.allowsSelection = NO;
    self.tabBarView.sizeToFitAlginStyle = IRSizeToFitAlginCenterWithCells;
    
    self.tabBarView.tabAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f],
                                      NSForegroundColorAttributeName : [UIColor whiteColor],
                                      IRTabTransitionAlphaEffectEnabled : @NO,
                                      IRTabTextOffset : [NSValue valueWithUIOffset:UIOffsetMake(0, 5)]
                                      };
    self.tabBarView.selectedTabAttributes = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18.0f],
                                              NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    NSInteger lineWidth = 0;
    self.tabBarView.indicatorAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor], IRTabIndicatorLineHeight : [NSNumber numberWithInteger:lineWidth]};
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor blueColor];
    [self.tabBarView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.tabBarView);
        make.height.mas_equalTo(5);
    }];
    
    singleButtonGroup = [[IRSingleButtonGroup alloc] init];
    TabButtom* page1Button = [TabButtom buttonWithType:UIButtonTypeSystem];
    [page1Button setTitle:@"Page1" forState:UIControlStateNormal];
    [page1Button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [page1Button addTarget:self action:@selector(page1ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    TabButtom* page2Button = [TabButtom buttonWithType:UIButtonTypeSystem];
    [page2Button setTitle:@"Page2" forState:UIControlStateNormal];
    [page2Button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [page2Button addTarget:self action:@selector(page2ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    TabButtom* page3Button = [TabButtom buttonWithType:UIButtonTypeSystem];
    [page3Button setTitle:@"Page3" forState:UIControlStateNormal];
    [page3Button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [page3Button addTarget:self action:@selector(page3ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    singleButtonGroup.buttons = @[page1Button, page2Button, page3Button];
    singleButtonGroup.delegate = self;
    
    [singleButtonGroup selected:singleButtonGroup.buttons[self.currentPage]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (BOOL)checkHasInvalidCharacters:(NSString*)string{
    NSMutableCharacterSet *specialCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@""];
    [specialCharacterSet addCharactersInString:@"\\"];
    [specialCharacterSet addCharactersInString:@"/"];
    [specialCharacterSet addCharactersInString:@":"];
    [specialCharacterSet addCharactersInString:@"*"];
    [specialCharacterSet addCharactersInString:@"?"];
    [specialCharacterSet addCharactersInString:@"\""];
    [specialCharacterSet addCharactersInString:@"<"];
    [specialCharacterSet addCharactersInString:@">"];
    [specialCharacterSet addCharactersInString:@"|"];
    if ([string rangeOfCharacterFromSet:specialCharacterSet].location != NSNotFound) {
        return YES;
    }
    return NO;
}

#pragma mark - MSSPageViewControllerDataSource

- (NSArray *)viewControllersForPageViewController:(IRPageViewController *)pageViewController {
    Page1ViewController *page1ViewController = [[Page1ViewController alloc] init];
    UINavigationController* navigationPage1ViewController = [[UINavigationController alloc] initWithRootViewController:page1ViewController];
    Page2ViewController *page2ViewController = [[Page2ViewController alloc] init];
    UINavigationController* navigationPage2ViewController = [[UINavigationController alloc] initWithRootViewController:page2ViewController];
    Page3ViewController *page3ViewController = [[Page3ViewController alloc] init];
    UINavigationController* navigationPage3ViewController = [[UINavigationController alloc] initWithRootViewController:page3ViewController];
    
    NSArray *childViewControllers = [[NSArray alloc]initWithObjects:navigationPage1ViewController, navigationPage2ViewController, navigationPage3ViewController, nil];
    return childViewControllers;
}

#pragma mark - MSSTabBarViewDataSource
- (void)tabBarView:(IRTabBarView *)tabBarView populateTab:(IRTabBarCollectionViewCell *)tab atIndex:(NSInteger)index {
    tab.customView = singleButtonGroup.buttons[index];
}

#pragma mark - MSSTabBarViewDelegate
- (void)tabBarView:(nonnull IRTabBarView *)tabBarView tabSelectedAtIndex:(NSInteger)index {
    [super tabBarView:tabBarView tabSelectedAtIndex:index];
    
    if ([[self viewControllers][index] isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController *)[self viewControllers][index] popToRootViewControllerAnimated:NO];
    }
}

- (void)tabBarView:(IRTabBarView *)tabBarView populateTab:(IRTabBarCollectionViewCell *)tab tabWillSelectAtIndex:(NSInteger)index {
    UIButton *willSelectTabButton = singleButtonGroup.buttons[index];
    [singleButtonGroup setInitSelected:willSelectTabButton];
}

- (void)page1ButtonClick:(UIButton*)sender {
    [singleButtonGroup selected:sender];
}

- (void)page2ButtonClick:(UIButton*)sender {
    
    [singleButtonGroup selected:sender];
}

- (void)page3ButtonClick:(UIButton*)sender {
    [singleButtonGroup selected:sender];
}

#pragma mark - UITabBarControllerDelegate
-(void)IR_tabbedController:(IRTabbedPageViewControllerImp *)tabbedPageViewController didSelectIndex:(NSInteger)index {
    [tabbedPageViewController.tabBarView setTabIndex:index animated:YES];
}

#pragma mark - SingleButtonGroupDelegate

- (void)didSelectedButton:(UIButton *)button {
    [self.tabBarView setTabSelected:[singleButtonGroup.buttons indexOfObject:button] animated:YES];
}

- (void)didDeselectedButton:(UIButton *)button {
    
}

@end

