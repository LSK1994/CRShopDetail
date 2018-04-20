//
//  HMSegmentedControl+CRExtention.m
//  CRShopDetailDemo
//
//  Created by roger wu on 19/04/2018.
//  Copyright © 2018 cocoaroger. All rights reserved.
//

#import "HMSegmentedControl+CRExtention.h"
#import "CRConst.h"

@implementation HMSegmentedControl (CRExtention)

+ (instancetype)cr_segmentWithTitles:(NSArray *)titles {
    CGFloat fontSize = 14;
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorColor = kMainColor;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorHeight = 2.f;
    segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName: kMainColor,
                                                     NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName: kBlackColor,
                                             NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    
    segmentedControl.borderType = HMSegmentedControlBorderTypeBottom;
    segmentedControl.borderColor = kLightGrayColor;
    segmentedControl.borderWidth = kSeperatorLineHeight;
    
    return segmentedControl;
}

@end
