//
//  CRShopDetailController.m
//  CRShopDetailDemo
//
//  Created by roger wu on 18/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "CRDetailController.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import "CRConst.h"
#import "CRNavigationBar.h"
#import "CRBottomBar.h"
#import "CRContentView.h"
#import "CRDetailModel.h"
#import "MBProgressHUD+CRExtention.h"


@interface CRDetailController ()<
    CRContentViewDelegate,
    CRNavigationBarDelegate,
    CRBottomBarDelegate>

@end

@implementation CRDetailController {
    CRNavigationBar *_navigationBar;
    CRContentView *_contentView;
    CRBottomBar *_bottomBar;
    CRDetailModel *_detailModel;
    NSURLSessionTask *_task;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    [self refreshAction];
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)dealloc {
    [_task cancel];
}

- (void)refreshAction {
    MBProgressHUD *hud = [MBProgressHUD cr_showLoadinWithView:self.view text:@"加载中..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud cr_hide];
            
            CRDetailModel *model = [CRDetailModel new];
            model.currentController = self;
            model.background = @"https://img.alicdn.com/imgextra/i4/268451883/TB2Z6ndfk9WBuNjSspeXXaz5VXa_!!268451883.jpg_q90.jpg";
            model.portrait = @"https://img.alicdn.com/imgextra/i2/268451883/TB2BUcbdv1TBuNjy0FjXXajyXXa_!!268451883.jpg";
            model.name = @"三际数码官方旗舰店";
            model.fansCount = @"125万";
            model.home = @"https://render.m.taobao.com/shop/index-page.htm?wh_weex=true&hideHeader=true&personality=true&hiddenTab=false&nativeShop=true&shopId=58499649&ruleId=-1&pageId=161753766&pathInfo=shop/index&userId=263726286&isCompatible=true";
            model.allProduct = @"https://sjsm.m.tmall.com/shop/shop_auction_search.do?spm=a1z60.7754813.0.0.c0c53d8daZJwoJ&suid=268451883&sort=s&p=1&page_size=12&from=h5&shop_id=58613162&ajson=1&_tm_source=tmallsearch&callback=jsonp_52824303";
            model.moments = @"https://sjsm.m.tmall.com/shop/shop-new.htm";
            
            self->_detailModel = model;
            [self setup];
        });
    });
}

- (void)setupNavigationBar {
    _navigationBar = [CRNavigationBar new];
    _navigationBar.delegate = self;
    [self.view addSubview:_navigationBar];
    [_navigationBar changeColor:YES];
    
    CGFloat height = isIphoneX ? kNavigationBarHeight88 : kNavigationBarHeight64;
    _navigationBar.frame = CGRectMake(0, 0, kScreenWidth, height);
}

- (void)setup {
    CGRect contentFrame = self.view.bounds;
    CGFloat bottomBarHeight = isIphoneX ? (kBottomBarHeight+kSafeAreaLayoutGuideBottomHeight) : kBottomBarHeight;
    contentFrame.size.height -= bottomBarHeight;
    _contentView = [[CRContentView alloc] initWithFrame:contentFrame
                                        contentDelegate:self
                                            detailModel:_detailModel];
    [self.view addSubview:_contentView];
    
    [self.view bringSubviewToFront:_navigationBar];
    [_navigationBar changeColor:NO];
    
    _bottomBar = [CRBottomBar new];
    _bottomBar.delegate = self;
    _bottomBar.frame = CGRectMake(0, CGRectGetMaxY(_contentView.frame), kScreenWidth, bottomBarHeight);
    [self.view addSubview:_bottomBar];
    
    if (kiOS11Later) {
        adjustsScrollViewInsets_NO(_contentView);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - CRContentViewDelegate
// 用于改变navigationBar的透明度
- (void)contentView:(CRContentView *)contentView offsetY:(CGFloat)offsetY {
    CGFloat top = isIphoneX ? kNavigationBarHeight88 : kNavigationBarHeight64;
    CGFloat total = [CRConst kHeaderViewHeight] - top;
    CGFloat real = offsetY + [CRConst kHeaderViewHeight];
    [_navigationBar changeAlphaWithOffsetY:real total:total];
}

#pragma mark - CRNavigationBarDelegate
- (void)navigationBarClickedBack:(CRNavigationBar *)navigationBar {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarClickedSearch:(CRNavigationBar *)navigationBar {
    [MBProgressHUD cr_showToastWithText:@"搜索"];
}

- (void)navigationBarClickedCategory:(CRNavigationBar *)navigationBar {
    [MBProgressHUD cr_showToastWithText:@"分类"];
}

- (void)navigationBarClickedMore:(CRNavigationBar *)navigationBar {
    [MBProgressHUD cr_showToastWithText:@"更多"];
}

#pragma mark - CRBottomBarDelegate
- (void)bottomBarClickedCategory:(CRBottomBar *)bottomBar {
    [MBProgressHUD cr_showToastWithText:@"产品分类"];
}

- (void)bottomBarClickedIntro:(CRBottomBar *)bottomBar {
    [MBProgressHUD cr_showToastWithText:@"公司简介"];
}

@end
