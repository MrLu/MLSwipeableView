//
//  MLSwipeResult.h
//  MLSwipeableView
//
//  Created by Mrlu on 2018/5/25.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MLPanState.h"


typedef void (^MLSwipedOnCompletionBlock)(void);

/*!
 * An object representing the result of a swipe.
 * This is provided as an argument to `MDCSwipeToChooseOnChosenBlock` callbacks.
 */
@interface MLSwipeResult : NSObject

/*!
 * The view that was swiped.
 */
@property (nonatomic, strong) UIView *view;

/*!
 * The translation of the swiped view; i.e.: the distance it has been panned
 * from its original location.
 */
@property (nonatomic, assign) CGPoint translation;

/*!
 * The final direction of the swipe.
 */
@property (nonatomic, assign) MLSwipeDirection direction;

/*!
 * A callback to be executed after any animations performed by the `MDCSwipeOptions`
 * `onChosen` callback.
 */
@property (nonatomic, copy) MLSwipedOnCompletionBlock onCompletion;

@end
