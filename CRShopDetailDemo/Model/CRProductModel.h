//
//  CRProductModel.h
//  CRShopDetailDemo
//
//  Created by roger wu on 18/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRProductModel : NSObject

@property (copy, nonatomic) NSString *cover; // 封面图
@property (copy, nonatomic) NSString *name; // 品名
@property (copy, nonatomic) NSString *price; // 价格
@property (assign, nonatomic) NSUInteger payCount; // 付款人数

@end
