//
//  CRProductCell.m
//  CRShopDetailDemo
//
//  Created by roger wu on 20/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "CRProductCell.h"
#import "CRConst.h"

static const CGFloat kProductNameLabelFont = 14.f;
static const CGFloat kPriceLabelFont = 15.f;
static const CGFloat kBrowerCountLabelFont = 12.f;
static const CGFloat kBottomViewH = 62.f;

@implementation CRProductCell {
    UIImageView *_portraitImageView; // 产品图片
    UILabel *_nameLabel;
    UILabel *_priceLabel;
    UILabel *_soldLabel;
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
    self.backgroundColor = kBackgroundColor;
    
    UIView *contentView = self.contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)setModel:(CRProductModel *)model {
    
}

@end
