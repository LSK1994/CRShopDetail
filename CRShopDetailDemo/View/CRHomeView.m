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

// https://render.m.taobao.com/shop/index-page.htm?wh_weex=true&hideHeader=true&personality=true&hiddenTab=false&nativeShop=true&shopId=58499649&ruleId=-1&pageId=161753766&pathInfo=shop/index&userId=263726286&isCompatible=true

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
}

- (void)setHomeURL:(NSString *)homeURL {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:homeURL]];
    [_webView loadRequest:request];
}

@end
