//
//  MLPanState.h
//  MLSwipeableView
//
//  Created by Mrlu on 2018/5/25.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MLSwipeDirection) {
    MLSwipeDirectionNone = 0,
    MLSwipeDirectionLeft,
    MLSwipeDirectionRight
};

/*!
 * An object representing the state of the current pan gesture.
 * This is provided as an argument to `MDCSwipeToChooseOnPanBlock` callbacks.
 */
@interface MLPanState : NSObject

/*!
 * The view being panned.
 */
@property (nonatomic, strong) UIView *view;

/*!
 * The direction of the current pan. Note that a direction of `MDCSwipeDirectionRight`
 * does not imply that the threshold has been reached.
 */
@property (nonatomic, assign) MLSwipeDirection direction;

/*!
 * The ratio of the threshold that has been reached. This can take on any value
 * between `0.0f` and `1.0f`, with `1.0f` meaning the threshold has been reached.
 * A `thresholdRatio` of `1.0f` implies that were the user to end the pan gesture,
 * the current direction would be chosen.
 */
@property (nonatomic, assign) CGFloat thresholdRatio;

@property (nonatomic, assign) BOOL isAuto;

@end
