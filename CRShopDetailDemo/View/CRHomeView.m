//
//  CRHomeView.m
//  CRShopDetailDemo
//
//  Created by roger wu on 19/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "CRHomeView.h"
#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>

@implementation CRHomeView {
    WKWebView *_webView;
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
    _webView = [WKWebView new];
    [self addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self setupWithScrollView:_webView.scrollView];
}

- (void)setHomeURL:(NSString *)homeURL {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:homeURL]];
    [_webView loadRequest:request];
}

@end
