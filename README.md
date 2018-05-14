# 仿淘宝店铺详情页

![录屏](/screenshot/record.gif)

### 问题分析
* 该页面的结构是顶部导航栏要在视图的最上层，中间滚动嵌套视图，底部导航栏在视图最上层
* 顶部导航栏需要跟随滚动视图的contentOffset做透明度变化
* 背景下拉放大效果
* 主要难点是中间滚动视图嵌套，Segment 吸顶和离开效果，内外层滚动视图滚动时机控制

### 导航栏透明度变化
CRContentView 中监听 `- (void)scrollViewDidScroll:(UIScrollView *)scrollView ` 方法，将 offsetY 交给 contentDelegate 去控制
```
    CGFloat offsetY = scrollView.contentOffset.y;
    [self.contentDelegate contentView:self offsetY:offsetY];
```
CRDetailController 实现 contentDelegate，对导航栏进行透明度控制
```
#pragma mark - CRContentViewDelegate
// 用于改变navigationBar的透明度
- (void)contentView:(CRContentView *)contentView offsetY:(CGFloat)offsetY {
    CGFloat top = isIphoneX ? kNavigationBarHeight88 : kNavigationBarHeight64;
    CGFloat total = [CRConst kHeaderViewHeight] - top;
    CGFloat real = offsetY + [CRConst kHeaderViewHeight];
    [_navigationBar changeAlphaWithOffsetY:real total:total];
}
```
CRNavigationBar导航栏透明度变换算法
```
- (void)changeAlphaWithOffsetY:(CGFloat)offsetY total:(CGFloat)total {
    CGFloat alpha = offsetY/total; // 透明度
    CGFloat reserveAlpha = 1 - alpha; // 反向透明度

    _backgroundView.alpha = alpha; // 背景透明度变化
    if (alpha < 0) {
        CGFloat a = 1 - alpha/(-0.5);
        _backButton.alpha = a;
        _searchButton.alpha = a;
        _categoryButton.alpha = a;
        _moreButton.alpha = a;
        _badgeLabel.alpha = a;
    } else if (alpha >=0 && alpha <= 0.5) { // 其他按钮变化过程
        _backButton.alpha = reserveAlpha;
        _searchButton.alpha = reserveAlpha;
        _categoryButton.alpha = reserveAlpha;
        _moreButton.alpha = reserveAlpha;
        _badgeLabel.alpha = reserveAlpha;
        [self changeColor:NO];
    } else if (alpha > 0.5) {
        _backButton.alpha = alpha;
        _searchButton.alpha = alpha;
        _categoryButton.alpha = alpha;
        _moreButton.alpha = alpha;
        _badgeLabel.alpha = alpha;
        [self changeColor:YES];
    }

}
```

### 背景下拉放大
我添加了一个 `UIScrollView+CRExtention` Category,只需要把图片视图和headerView设置好，就具有了下拉放大的效果，这是参考了一个开源库的写法，原理就是监听ScrollView的contentOffset变化
```
/**
 设置下拉放大视图

 @param zoomImageView 用于放大的图片视图
 @param headerView UITableView/UICollectionView的HeaderView
 */
-(void)setZoomImageView:(UIImageView *)zoomImageView headerView:(nullable UIView *)headerView;
```

### Segment悬浮+滚动视图嵌套
通过一些逻辑判断确定 `segment` 是悬浮置顶，还是跟随滚动；
为此设计了两个通知 `kToTopNotification` 和 `kLeaveTopNotification`；
监听`- (void)scrollViewDidScroll:(UIScrollView *)scrollView`, 改变内外 `ScrollView` 的 `contentOffset`。

#### 关键点1
CRContentView继承UITableView，作为外层滚动视图，实现以下方法 ，让子视图同时可以接收滑动事件
```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
```

#### 关键点2
CRContentView类中监听 `kLeaveTopNotification`, 当 `segment` 离开顶部时，局部变量`_isScrollable`，变为可滚动

#### 关键点3
CRContentView 监听 `- (void)scrollViewDidScroll:(UIScrollView *)scrollView`，做出响应的处理
```
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat top = isIphoneX ? kNavigationBarHeight88 : kNavigationBarHeight64;
    CGFloat segmentOffsetY = [self rectForSection:0].origin.y - top;
    CGFloat offsetY = scrollView.contentOffset.y;
    [self.contentDelegate contentView:self offsetY:offsetY];

    _isSegmentToTopPre = _isSegmentToTop;
    if (offsetY >= segmentOffsetY) { // segment 到顶端
        scrollView.contentOffset = CGPointMake(0, segmentOffsetY);
        _isSegmentToTop = YES;
    } else {
        _isSegmentToTop = NO;
    }

    if (_isSegmentToTop != _isSegmentToTopPre) {
        if (!_isSegmentToTopPre && _isSegmentToTop) { // 到顶端
            [[NSNotificationCenter defaultCenter] postNotificationName:kToTopNotification
                                                                object:@(YES)];
            _isScrollable = NO;
        }
        if (_isSegmentToTopPre && !_isSegmentToTop) { // 离开顶端
            if (!_isScrollable && offsetY != -[CRConst kHeaderViewHeight]) {
                scrollView.contentOffset = CGPointMake(0, segmentOffsetY);
            }
        }
    }
}
```

#### 关键点4
Segment下的三个视图 CRHomeView、CRAllProductView、CRMomentsView，都继承 CRSegmentItemBase。
CRSegmentItemBase 作了内部滚动视图的统一逻辑处理，根据不同的条件出发相应的通知和监听通知
```
- (void)setupWithScrollView:(UIScrollView *)scrollView {
    _scrollView = scrollView;
    scrollView.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollable:)
                                                 name:kToTopNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(scrollable:)
                                                 name:kLeaveTopNotification
                                               object:nil];
    //其中一个 Segment 离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
}

- (void)scrollable:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kToTopNotification]) { // 可以滚动
        _isScrollable = [notification.object boolValue];
        self.scrollView.showsVerticalScrollIndicator = YES;
    } else if ([notificationName isEqualToString:kLeaveTopNotification]) { // 不可滚动
        self.scrollView.contentOffset = CGPointZero;
        _isScrollable = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isScrollable) {
        scrollView.contentOffset = CGPointZero;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLeaveTopNotification
                                                            object:@(YES)];
    }
}
```

#### 关键点5
CRContentView 屏幕边缘返回手势处理逻辑
```
- (void)setup {
    // 当被依赖的gestureRecognizer.state = failed时，另一个gestureRecognizer才能对手势进行响应。
    UIView *v = _detailModel.currentController.navigationController.view;
    UIScreenEdgePanGestureRecognizer *screenGesture = [v cr_screenEdgePanGestureRecognizer];
    if (screenGesture) {
        [self.panGestureRecognizer requireGestureRecognizerToFail:screenGesture];
    }
}
```
