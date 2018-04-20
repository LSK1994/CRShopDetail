//
//  CRAllProductView.m
//  CRShopDetailDemo
//
//  Created by roger wu on 19/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "CRAllProductView.h"
#import "CRSortBar.h"
#import "CRProductLayout.h"
#import "CRProductCell.h"
#import "CRConst.h"
#import "CRDetailModel.h"
#import "CRProductModel.h"
#import "CRRefreshFooter.h"


#import <MBProgressHUD/MBProgressHUD.h>
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>
#import <YYModel/YYModel.h>


@interface CRAllProductView()<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    CRSortBarDelegate>
@end

@implementation CRAllProductView {
    CRSortBar *_sortBar;
    UICollectionView *_collectionView;
    NSMutableArray<CRProductModel *> *_dataSource;
    NSURLSessionTask *_headerTask;
    NSURLSessionTask *_footerTask;
    NSInteger _currentPage;
    CRSortType _sortType;
    MBProgressHUD *_hud;
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

- (void)dealloc {
    [_headerTask cancel];
    [_footerTask cancel];
}

- (void)setup {
    _dataSource = [NSMutableArray array];
    _sortType = CRSortTypeComposite;
    
    _sortBar = [CRSortBar new];
    _sortBar.delegate = self;
    [self addSubview:_sortBar];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:[CRProductLayout new]];
    _collectionView.backgroundColor = kBackgroundColor;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[CRProductCell class] forCellWithReuseIdentifier:kCRProductCellID];
    [self addSubview:_collectionView];
    [self setupWithScrollView:_collectionView];
    
    [_sortBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kSortBarHeight);
    }];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self->_sortBar.mas_bottom);
    }];
    
    @weakify(self);
    _collectionView.mj_footer = [CRRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self footerRefresh];
    }];
}

- (void)setModel:(CRDetailModel *)model {
    _model = model;
    [self headerRefresh];
}

- (NSMutableArray<CRProductModel *> *)getData {
    NSMutableArray<CRProductModel *> *temp = [NSMutableArray array];
    NSData *data = [NSData dataNamed:@"product_list"];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data
                                                     options:kNilOptions
                                                       error:NULL];
    for (NSDictionary *json in array) {
        CRProductModel *model = [CRProductModel yy_modelWithJSON:json];
        [temp addObject:model];
    }
    return [temp mutableCopy];
}

- (void)headerRefresh {
    _dataSource = [self getData];
    [_collectionView reloadData];
}

- (void)footerRefresh {
    [_dataSource addObjectsFromArray:[self getData]];
    [_collectionView.mj_footer endRefreshingWithNoMoreData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CRProductCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCRProductCellID
                                                                    forIndexPath:indexPath];
    cell.model = _dataSource[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    CRProductModel *model = _dataSource[indexPath.item];
}

#pragma mark - ShopDetailSortBarViewDelegate
- (void)sortBar:(CRSortBar *)sortBar sortType:(CRSortType)sortType {
    _sortType = sortType;
    [_collectionView scrollToTopAnimated:NO];
    [self headerRefresh];
}

@end
