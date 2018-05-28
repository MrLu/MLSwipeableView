//
//  SwipeItemTransform.m
//  MLSwipeableView
//
//  Created by Mrlu on 2018/5/25.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import "SwipeItemTransform.h"

typedef CGFloat MLRotationDirection;
const MLRotationDirection MLRotationAwayFromCenter = 1.f;
const MLRotationDirection MLRotationTowardsCenter = -1.f;

@implementation SwipeItemTransform
- (instancetype)initWithSwipeProtocol:(id<SwipeableViewProtocol>)obj
{
    self = [super init];
    if (self) {
        if ([obj respondsToSelector:@selector(originalCenter)]) {
            self.originalCenter = obj.originalCenter;
        }
        self.originalTransform = obj.originalTransform;
        if ([obj respondsToSelector:@selector(originalFrame)]) {
            self.originalFrame = obj.originalFrame;
        }
    }
    return self;
}
@end
