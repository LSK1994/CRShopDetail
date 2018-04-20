//
//  CRProductLayout.m
//  CRShopDetailDemo
//
//  Created by roger wu on 20/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "CRProductLayout.h"
#import <YYCategories/YYCategories.h>

static const CGFloat kBottomViewH = 80.f;

@implementation CRProductLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat margin = 6.f;
        
        self.sectionInset = UIEdgeInsetsMake(margin, 0, 0, 0); // 上边距
        self.minimumInteritemSpacing = margin; // 横向最小间距
        self.minimumLineSpacing = margin;
        CGFloat itemWidth = (kScreenWidth - margin)/2.f;
        CGFloat itemHeight = itemWidth + kBottomViewH;
        self.itemSize = CGSizeMake(itemWidth, itemHeight);
        
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}
@end
