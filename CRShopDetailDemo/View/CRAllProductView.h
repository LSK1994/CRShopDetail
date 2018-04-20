//
//  CRAllProductView.h
//  CRShopDetailDemo
//
//  Created by roger wu on 19/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CRDetailModel;
#import "CRSegmentItemBase.h"

/**
 全部宝贝
 */
@interface CRAllProductView : CRSegmentItemBase

@property (strong, nonatomic) CRDetailModel *model;

@end
