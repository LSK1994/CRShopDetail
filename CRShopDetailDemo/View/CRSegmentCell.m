//
//  CRSegmentCell.m
//  CRShopDetailDemo
//
//  Created by roger wu on 19/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "CRSegmentCell.h"
#import "HMSegmentedControl+CRExtention.h"
#import "UIView+CRExtention.h"
#import "CRHomeView.h"
#import "CRAllProductView.h"
#import "CRMomentsView.h"
#import "CRConst.h"
#import "CRDetailModel.h"

#import <YYCategories/YYCategories.h>


static const CGFloat kSegmentControlHeight = 44;

/**
 支持多手势滑动图
 */
@interface CRSegmentScrollView: UIScrollView
@end

@implementation CRSegmentScrollView

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] &&
        [otherGestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return YES;
    } else {
        return  NO;
    }
}

@end

@interface CRSegmentCell ()<UIScrollViewDelegate>
@end

@implementation CRSegmentCell {
    HMSegmentedControl *_segmentedControl;
    UIScrollView *_scrollView;
    CRHomeView *_homeView;
    CRAllProductView *_allProductView;
    CRMomentsView *_momentsView;
    NSInteger _lastSelectedIndex; // 上次选中
}

- (void)setupViews {
    NSArray *titles = @[@"首页", @"全部宝贝", @"店铺微淘"];
    _segmentedControl = [HMSegmentedControl cr_segmentWithTitles:titles];
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    [_segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segmentedControl];
    
    _scrollView = [CRSegmentScrollView new];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    self.width = kScreenWidth;
    if (isIphoneX) {
        self.height = kScreenHeight - kNavigationBarHeight88 - kBottomBarHeight - kSafeAreaLayoutGuideBottomHeight;
    } else {
        self.height = kScreenHeight - kNavigationBarHeight64 - kBottomBarHeight;
    }
    _segmentedControl.frame = CGRectMake(0, 0, self.width, kSegmentControlHeight);
    _scrollView.frame = CGRectMake(0, _segmentedControl.bottom, kScreenWidth, self.height - kSegmentControlHeight);
    
    for (NSInteger i = 0; i < 3; i++) {
        CGRect frame = CGRectMake(i * self.width, 0, self.width, _scrollView.height);
        switch (i) {
            case 0: {
                _homeView = [[CRHomeView alloc] initWithFrame:frame];
                [self addViewToScroll:_homeView];
                break;
            }
            case 1: {
                _allProductView = [[CRAllProductView alloc] initWithFrame:frame];
                [self addViewToScroll:_allProductView];
                break;
            }
            case 2: {
                _momentsView = [[CRMomentsView alloc] initWithFrame:frame];
                [self addViewToScroll:_momentsView];
                break;
            }
            default: {
                break;
            }
        }
    }
}

- (void)addViewToScroll:(UIView *)view {
    [_scrollView addSubview:view];
    CGSize oldSize = _scrollView.contentSize;
    _scrollView.contentSize = CGSizeMake(oldSize.width + self.width, oldSize.height);
}

- (void)setModel:(CRDetailModel *)model {
    _model = model;
    
    // 当被依赖的gestureRecognizer.state = failed时，另一个gestureRecognizer才能对手势进行响应。
    UIView *v = model.currentController.navigationController.view;
    UIScreenEdgePanGestureRecognizer *screenGesture = [v cr_screenEdgePanGestureRecognizer];
    if (screenGesture) {
        [_scrollView.panGestureRecognizer requireGestureRecognizerToFail:screenGesture];
    }
    
    _homeView.homeURL = model.home;
    _allProductView.model = model;
    _momentsView.momentsURL = model.moments;
}

#pragma mark - Actions
- (void)segmentAction:(HMSegmentedControl *)segment {
    _lastSelectedIndex = segment.selectedSegmentIndex;
    
    CGPoint toPoint = CGPointMake(segment.selectedSegmentIndex*self.width, 0);
    [_scrollView setContentOffset:toPoint animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat currentX = scrollView.contentOffset.x;
    NSInteger selectedIndex = currentX/self.width;
    _lastSelectedIndex = selectedIndex;
    [_segmentedControl setSelectedSegmentIndex:selectedIndex animated:YES];
}

@end
