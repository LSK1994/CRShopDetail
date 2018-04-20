//
//  CRShopDetailModel.h
//  CRShopDetailDemo
//
//  Created by roger wu on 18/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CRDetailModel : NSObject

@property (nonatomic, weak) UIViewController *currentController; // 当前ViewController

@property (copy, nonatomic) NSString *background; // 店铺背景图
@property (copy, nonatomic) NSString *portrait; // 头像
@property (copy, nonatomic) NSString *name; // 店铺名
@property (copy, nonatomic) NSString *fansCount; // 粉丝数

- (NSURL *)backgroundURL;
- (NSURL *)portraitURL;

@end
