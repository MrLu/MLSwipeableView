//
//  MLSwipeableCommon.h
//  MLSwipeableView
//
//  Created by Mrlu on 2018/5/25.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef MLSwipeableCommon_h
#define MLSwipeableCommon_h

extern CGPoint MLCGPointAddX(const CGPoint a, const CGPoint b, const CGFloat y);

extern CGPoint MLCGPointAdd(const CGPoint a, const CGPoint b);

extern CGPoint MLCGPointSubtract(const CGPoint minuend, const CGPoint subtrahend);

extern CGFloat MDCDegreesToRadians(const CGFloat degrees);

extern CGRect MLCGRectExtendedOutOfBounds(const CGRect rect,
                                   const CGRect bounds,
                                   const CGPoint translation,
                                          const NSUInteger direction);

extern CGRect MLCGRectAddHeight(const CGRect a, const CGFloat height);

extern CGPoint MLCGPointFromRect(const CGRect frame);



//typedef void (^MDCSwipeToChooseOnPanBlock)(MLPanState *state);
//typedef void (^MDCSwipeToChooseOnChosenBlock)(MLSwipeResult *state);
//typedef void (^MDCSwipeToChooseOnCancelBlock)(UIView *swipedView);

#endif // MLSwipeableCommon_h







