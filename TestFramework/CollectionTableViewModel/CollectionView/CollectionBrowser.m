//
//  MonitorBrowser.m
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import "CollectionBrowser.h"
#import "CollectionBrowserViewModel.h"

@interface CollectionBrowser()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic, readwrite) IBOutlet CustomCollectionView *monitorCollectionView;
@end

@implementation CollectionBrowser {
    NSLayoutConstraint * heightConstraint;
    NSInteger currentPageIndex;
    CollectionBrowserViewModel* viewModel;
    BOOL shouldInvalidateLayout;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:nibName
                                                   owner:self
                                                 options:nil];
    UIView *viewFromNib = [views firstObject];
    viewFromNib.translatesAutoresizingMaskIntoConstraints = false;
    
    [self addSubview:viewFromNib];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint * bottomConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint * centerXConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    NSLayoutConstraint * centerYConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    heightConstraint = [NSLayoutConstraint constraintWithItem:viewFromNib attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
    
    topConstraint.active = YES;
    bottomConstraint.active = YES;
    leadingConstraint.active = YES;
    trailingConstraint.active = YES;
    centerXConstraint.active = YES;
    centerYConstraint.active = YES;
    heightConstraint.active = YES;
    
    [self initMonitorCollectionView];
    
    viewModel = [[CollectionBrowserViewModel alloc] initWithCollectionView:self.monitorCollectionView];
    viewModel.monitors = self.monitors;
    self.monitorCollectionView.dataSource = viewModel;
    [viewModel update];
    
    shouldInvalidateLayout = YES;
}

- (void)setMonitors:(NSArray<id<Monitorable>> *)monitors {
    _monitors = monitors;
    viewModel.monitors = _monitors;
    [viewModel update];
}

- (void)gotoImageIndex:(NSInteger)imageIndex {
    [self reloadDataWithCompletion:^{
        [self.monitorCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:imageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        if(self.monitorCollectionView.isPagingEnabled){
            [self setCurrentPageIndex:imageIndex];
        }
    }];
}

- (void)setDirection:(MonitorBrowserScrollDirection)direction {
    _direction = direction;
    switch (self.direction) {
        case ScrollDirectionVertical:
            [((UICollectionViewFlowLayout *)self.monitorCollectionView.collectionViewLayout) setScrollDirection:UICollectionViewScrollDirectionVertical];
            break;
        case ScrollDirectionHorizontal:
            [((UICollectionViewFlowLayout *)self.monitorCollectionView.collectionViewLayout) setScrollDirection:UICollectionViewScrollDirectionHorizontal];
            break;
    }
}

- (void)reloadData {
    shouldInvalidateLayout = YES;
    [self.monitorCollectionView reloadDataWithCompletion:nil];
}

- (void)reloadDataWithCompletion:(void (^)(void))completionBlock {
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        NSLog(@"reload completed");
        heightConstraint.constant = 80;
        if(completionBlock)
            completionBlock();
    }];
    NSLog(@"reloading");
//    [self.monitorCollectionView.collectionViewLayout invalidateLayout];
    [self.monitorCollectionView layoutIfNeeded];
    [self layoutIfNeeded];
    [self.monitorCollectionView reloadData];
    [CATransaction commit];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if(shouldInvalidateLayout) {
        [self.monitorCollectionView.collectionViewLayout invalidateLayout];
        shouldInvalidateLayout = NO;
    }
    
//    CGFloat itemWidth,itemHeight;
//    switch (self.direction) {
//        case ScrollDirectionVertical:
//            if(self.monitorCollectionView.isPagingEnabled){
//                itemWidth = self.monitorCollectionView.bounds.size.width;
//                itemHeight = self.monitorCollectionView.bounds.size.height;
//            }else{
//                itemWidth = self.monitorCollectionView.bounds.size.width - 10;
//                itemHeight = itemWidth/2 + 20;
//            }
//            
//            break;
//            
//        case ScrollDirectionHorizontal:
//            if(self.monitorCollectionView.isPagingEnabled){
//                itemWidth = self.monitorCollectionView.bounds.size.width;
//                itemHeight = self.monitorCollectionView.bounds.size.height;
//            }else{
//                itemWidth = self.monitorCollectionView.bounds.size.width/3*2;
//                itemHeight = itemWidth/16*11;
//            }
//            break;
//    }
//    
//    ((UICollectionViewFlowLayout *)self.monitorCollectionView.collectionViewLayout).itemSize = CGSizeMake(itemWidth, itemHeight);
//    //    ((UICollectionViewFlowLayout *)self.photomanageCollectionView.collectionViewLayout).estimatedItemSize = CGSizeMake(itemWidth > self.photomanageCollectionView.frame.size.width ? self.photomanageCollectionView.frame.size.width : itemWidth, itemHeight > self.photomanageCollectionView.frame.size.height ? self.photomanageCollectionView.frame.size.height : itemHeight);
//    [self.monitorCollectionView.collectionViewLayout invalidateLayout];
//    [self.monitorCollectionView layoutIfNeeded];
//    [self.monitorCollectionView reloadData];
}

- (void)initMonitorCollectionView {
    self.monitorCollectionView.backgroundColor = [UIColor clearColor];
    self.monitorCollectionView.showsHorizontalScrollIndicator = NO;
//    ((UICollectionViewFlowLayout *)self.monitorCollectionView.collectionViewLayout).minimumInteritemSpacing = CGFLOAT_MAX;
    [self.monitorCollectionView setAllowsMultipleSelection:YES];
    [((UICollectionViewFlowLayout *)self.monitorCollectionView.collectionViewLayout) setMinimumLineSpacing:0];
    self.monitorCollectionView.pagingEnabled = NO;
    ((UICollectionViewFlowLayout *)self.monitorCollectionView.collectionViewLayout).itemSize = UICollectionViewFlowLayoutAutomaticSize;
    ((UICollectionViewFlowLayout *)self.monitorCollectionView.collectionViewLayout).estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.monitorCollectionView.collectionViewLayout invalidateLayout];
        [self.monitorCollectionView layoutIfNeeded];
        [self layoutIfNeeded];
    });
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.itemSelectedBlock)
        self.itemSelectedBlock(indexPath);
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}

- (void)didClickDeleteButtonInItemIndex:(NSInteger)itemIndex {
    if(self.deleteClickBlock)
        self.deleteClickBlock(itemIndex);
}

- (void)didClickEditButtonInItemIndex:(NSInteger)itemIndex {
    if(self.editClickBlock)
        self.editClickBlock(itemIndex);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkPageChangedByScrollView:scrollView];
}

- (void)checkPageChangedByScrollView:(UIScrollView *)scrollView {
    if(self.monitorCollectionView.isPagingEnabled){
        NSInteger newPageIndex = (int)scrollView.contentOffset.x / (int)scrollView.frame.size.width;
        [self setCurrentPageIndex:newPageIndex];
    }
}

- (void)setCurrentPageIndex:(NSInteger)newPageIndex {
    if (currentPageIndex != newPageIndex){
        currentPageIndex = newPageIndex;
        if(self.currentPageChangedBlock)
            self.currentPageChangedBlock(currentPageIndex);
    }
}

@end
