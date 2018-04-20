//
//  CRShopDetailNavigationBar.m
//  CRShopDetailDemo
//
//  Created by roger wu on 19/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "CRNavigationBar.h"
#import "CRConst.h"
#import <Masonry/Masonry.h>
#import <YYCategories/YYCategories.h>

static const CGFloat kSearchBarHeight = 30;
static const CGFloat kRedDotViewWH = 14;
static const CGFloat kMargin = 15;

#define kNormalColor [UIColor whiteColor]
#define kHighlightColor kMainColor
#define kSearchTintColor rgba(153,153,153,1)
#define kPlaceholderNormalColor rgba(200,200,200,1)
#define kPlaceholderHighlightColor rgba(180,180,180,1)
#define kRedDotColor [UIColor redColor]

@implementation CRNavigationBar {
    UIView *_backgroundView;
    UIView *_contentView;
    UIButton *_backButton;
    UIButton *_searchButton;
    UIImageView *_searchImageView;
    UILabel *_searchPlaceholderLabel;
    UIButton *_categoryButton;
    UIButton *_moreButton;
    UILabel *_badgeLabel;
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
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [UIView new];
    _backgroundView.backgroundColor = [UIColor whiteColor];
    _backgroundView.alpha = 0;
    [self addSubview:_backgroundView];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:_contentView];
    
    // 返回按钮
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [[UIImage imageNamed:@"back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_backButton setImage:backImage forState:UIControlStateNormal];
    _backButton.tintColor = kNormalColor;
    [_contentView addSubview:_backButton];
    
    // 搜索
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.backgroundColor = kNormalColor;
    _searchButton.layer.masksToBounds = YES;
    [_contentView addSubview:_searchButton];
    _searchButton.layer.cornerRadius = kSearchBarHeight/2;
    
    _searchImageView = [UIImageView new];
    UIImage *searchImage = [[UIImage imageNamed:@"search_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _searchImageView.image = searchImage;
    _searchImageView.tintColor = kSearchTintColor;
    [_searchButton addSubview:_searchImageView];
    
    _searchPlaceholderLabel = [UILabel new];
    _searchPlaceholderLabel.textColor = kPlaceholderNormalColor;
    _searchPlaceholderLabel.text = @"搜索店铺内宝贝";
    _searchPlaceholderLabel.font = [UIFont systemFontOfSize:14];
    [_searchButton addSubview:_searchPlaceholderLabel];
    
    // 二维码
    _categoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *categoryImage = [[UIImage imageNamed:@"category_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_categoryButton setImage:categoryImage forState:UIControlStateNormal];
    _categoryButton.tintColor = kNormalColor;
    [_contentView addSubview:_categoryButton];
    
    // 更多
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *moreImage = [[UIImage imageNamed:@"more_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_moreButton setImage:moreImage forState:UIControlStateNormal];
    _moreButton.tintColor = kNormalColor;
    [_contentView addSubview:_moreButton];
    
    // 小红点
    _badgeLabel = [UILabel new];
    _badgeLabel.backgroundColor = kRedDotColor;
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.font = [UIFont systemFontOfSize:11];
    _badgeLabel.layer.masksToBounds = YES;
    _badgeLabel.layer.cornerRadius = kRedDotViewWH/2;
    _badgeLabel.hidden = YES;
    [_contentView addSubview:_badgeLabel];
    
    [_backButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_searchButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_categoryButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(kLineHeight44);
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_contentView);
        make.centerY.equalTo(self->_contentView);
        make.width.height.mas_equalTo(40);
    }];
    
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_backButton.mas_right).offset(0);
        make.right.equalTo(self->_categoryButton.mas_left).offset(-kMargin);
        make.centerY.equalTo(self->_contentView);
        make.height.mas_equalTo(kSearchBarHeight);
    }];
    
    [_searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self->_searchButton);
    }];
    
    [_searchPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self->_searchImageView.mas_right).offset(10);
        make.centerY.equalTo(self->_searchButton);
    }];
    
    [_categoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_moreButton.mas_left).offset(-10);
        make.centerY.equalTo(self->_contentView);
    }];
    
    [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self->_contentView);
    }];
    
    [_badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self->_moreButton.mas_right);
        make.top.equalTo(self->_moreButton.mas_top);
        make.height.mas_equalTo(kRedDotViewWH);
    }];
}

- (void)buttonAction:(UIButton *)button {
    if (button == _backButton) {
        [self.delegate navigationBarClickedBack:self];
    } else if (button == _searchButton) {
        [self.delegate navigationBarClickedSearch:self];
    } else if (button == _categoryButton) {
        [self.delegate navigationBarClickedCategory:self];
    } else if (button == _moreButton) {
        [self.delegate navigationBarClickedMore:self];
    }
}

- (void)changeColor:(BOOL)isHighlight {
    if (isHighlight) {
        _backButton.tintColor = kHighlightColor;
        _categoryButton.tintColor = kHighlightColor;
        _moreButton.tintColor = kHighlightColor;
        _searchButton.tintColor = kHighlightColor;
        _searchPlaceholderLabel.textColor = kPlaceholderHighlightColor;
    } else {
        _backButton.tintColor = kNormalColor;
        _categoryButton.tintColor = kNormalColor;
        _moreButton.tintColor = kNormalColor;
        _searchButton.tintColor = [UIColor whiteColor];
        _searchPlaceholderLabel.textColor = kPlaceholderNormalColor;
    }
}

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

- (void)setMessageCount:(NSInteger)messageCount {
    _badgeLabel.hidden = (messageCount == 0);
    _badgeLabel.text = [NSString stringWithFormat:@"%@", @(messageCount)];
    CGRect rect = [_badgeLabel.text boundingRectWithSize:CGSizeMake(20, 14) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:_badgeLabel.font} context:nil];
    float width = rect.size.width < 10 ? 10 : rect.size.width;
    _badgeLabel.frame = CGRectMake(kScreenWidth - width - 10, 2, width + 4, 14);
}

@end
