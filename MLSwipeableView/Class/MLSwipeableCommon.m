//
//  MLSwipeableCommon.m
//  MLSwipeableView
//
//  Created by Mrlu on 2018/5/25.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import "MLSwipeableCommon.h"


CGPoint MLCGPointAddX(const CGPoint a, const CGPoint b, const CGFloat y) {
    return CGPointMake(a.x + b.x,
                       y);
}

CGPoint MLCGPointAdd(const CGPoint a, const CGPoint b) {
    return CGPointMake(a.x + b.x,
                       a.y + b.y);
}

CGPoint MLCGPointSubtract(const CGPoint minuend, const CGPoint subtrahend) {
    return CGPointMake(minuend.x - subtrahend.x,
                       minuend.y - subtrahend.y);
}

CGFloat MDCDegreesToRadians(const CGFloat degrees) {
    return degrees * (M_PI/180.0);
}

CGRect MLCGRectExtendedOutOfBounds(const CGRect rect,
                                   const CGRect bounds,
                                   const CGPoint translation,
                                   const NSUInteger direction) {
    CGRect destination = rect;
    while (!CGRectIsNull(CGRectIntersection(bounds, destination))) {
        if (direction>=2) { //XY轴
            destination = CGRectMake(CGRectGetMinX(destination) + translation.x,
                                     CGRectGetMinY(destination) + translation.y,
                                     CGRectGetWidth(destination),
                                     CGRectGetHeight(destination));
        }
        if (direction==0) { //X轴
            destination = CGRectMake(CGRectGetMinX(destination) + translation.x,
                                     CGRectGetMinY(destination),
                                     CGRectGetWidth(destination),
                                     CGRectGetHeight(destination));
        }
        if (direction==1) { //Y轴
            destination = CGRectMake(CGRectGetMinX(destination),
                                     CGRectGetMinY(destination) + translation.y,
                                     CGRectGetWidth(destination),
                                     CGRectGetHeight(destination));
        }
    }
    
    return destination;
}

CGRect MLCGRectAddHeight(const CGRect a, const CGFloat height) {
    return CGRectMake(a.origin.x, a.origin.y, a.size.width, height);
}

CGPoint MLCGPointFromRect(const CGRect frame) {
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
}








