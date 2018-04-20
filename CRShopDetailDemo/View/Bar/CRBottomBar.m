//
//  CRBottomBar.m
//  CRShopDetailDemo
//
//  Created by roger wu on 19/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "CRBottomBar.h"
#import "UIButton+CRExtension.h"
#import "CRConst.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>

static const CGFloat kButtonFontSize = 15;

@implementation CRBottomBar {
    UIButton *_categoryButton;
    UIButton *_introButton;
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
    self.backgroundColor = [UIColor whiteColor];
    UIView *contentView = [UIView new];
    [self addSubview:contentView];
    
    _categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_categoryButton setTitle:@"产品分类" forState:UIControlStateNormal];
    [_categoryButton cr_setTitleColor:kBlackColor];
    [_categoryButton cr_setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    _categoryButton.titleLabel.font = [UIFont systemFontOfSize:kButtonFontSize];
    [_categoryButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_categoryButton];
    
    _introButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_introButton setTitle:@"公司简介" forState:UIControlStateNormal];
    [_introButton cr_setTitleColor:kBlackColor];
    [_introButton cr_setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    _introButton.titleLabel.font = [UIFont systemFontOfSize:kButtonFontSize];
    [_introButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_introButton];
    
    UIView *verticalLine = [UIView new];
    verticalLine.backgroundColor = kSeperatorLineColor;
    [contentView addSubview:verticalLine];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(kBottomBarHeight);
    }];
    
    [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(1);
    }];
    
    [_categoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(contentView);
        make.right.equalTo(verticalLine.mas_left);
    }];
    
    [_introButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(contentView);
        make.left.equalTo(verticalLine.mas_right);
    }];
}

- (void)buttonAction:(UIButton *)button {
    if (button == _categoryButton) {
        [self.delegate bottomBarClickedCategory:self];
    } else {
        [self.delegate bottomBarClickedIntro:self];
    }
}

@end
