//
//  MonitorBrowser.h
//  demo
//
//  Created by Phil on 2019/5/17.
//  Copyright © 2019 Phil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCollectionView.h"
#import "Monitorable.h"

typedef NS_ENUM(NSUInteger, MonitorBrowserScrollDirection){
    ScrollDirectionHorizontal,
    ScrollDirectionVertical
};

typedef void(^CurrentPageChangedBlock)(NSInteger currentPage);
typedef void(^ItemSelectedBlock)(NSIndexPath* indexPath);
typedef void(^DeleteClickBlock)(NSInteger index);
typedef void(^EditClickBlock)(NSInteger index);

@interface CollectionBrowser : UIView

@property (nonatomic) NSArray<id<Monitorable>> *monitors;
@property (nonatomic) MonitorBrowserScrollDirection direction;
@property (nonatomic, copy) CurrentPageChangedBlock currentPageChangedBlock;
@property (nonatomic, copy) ItemSelectedBlock itemSelectedBlock;
@property (nonatomic, copy) DeleteClickBlock deleteClickBlock;
@property (nonatomic, copy) EditClickBlock editClickBlock;

-(void)gotoImageIndex:(NSInteger)imageIndex;
-(void)reloadData;
-(void)reloadDataWithCompletion:(void (^)(void))completionBlock;

@end
