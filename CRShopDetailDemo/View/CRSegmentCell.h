//
//  CRSegmentCell.h
//  CRShopDetailDemo
//
//  Created by roger wu on 19/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "CRTableViewCell.h"
@class CRDetailModel;

@interface CRSegmentCell : CRTableViewCell

@property (strong, nonatomic) CRDetailModel *model;

@end
