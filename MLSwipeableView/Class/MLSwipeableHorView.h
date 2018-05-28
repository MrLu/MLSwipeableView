//
//  MLSwipeableHorView.h
//  MLSwipeableHorViewDemo
//
//  Created by Mrlu on 05/03/2018.
//  Copyright (c) 2018 Mrlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSwipeableCommon.h"

#import "MLPanState.h"
#import "MLSwipeResult.h"
#import "SwipeItemTransform.h"
#import "SwipeableViewProtocol.h"

@class MLSwipeableHorView;
// Delegate
@protocol MLSwipeableHorViewDelegate <NSObject>
@optional
- (void)swipeableView: (MLSwipeableHorView *)swipeableView willDisplay:(UIView *)view;
- (void)swipeableView: (MLSwipeableHorView *)swipeableView didDisplay:(UIView *)view;
- (BOOL)swipeableView: (MLSwipeableHorView *)swipeableView willSwipeLeft:(UIView *)view;
- (BOOL)swipeableView: (MLSwipeableHorView *)swipeableView willSwipeRight:(UIView *)view;
- (void)swipeableView: (MLSwipeableHorView *)swipeableView didSwipeLeft:(UIView *)view;
- (void)swipeableView: (MLSwipeableHorView *)swipeableView didSwipeRight:(UIView *)view;
- (void)swipeableView: (MLSwipeableHorView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location;
- (void)swipeableView: (MLSwipeableHorView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location panState:(MLPanState *)panState;
- (void)swipeableViewdidEndSwipe:(MLSwipeableHorView *)swipeableView swipingView:(UIView *)view;
- (void)swipeableViewWillEndSwipe:(MLSwipeableHorView *)swipeableView swipingView:(UIView *)view;

@end



// DataSource
@protocol MLSwipeableHorViewDataSource <NSObject>
@required
- (UIView<SwipeableViewProtocol> *)nextViewForSwipeableView:(MLSwipeableHorView *)swipeableView index:(NSUInteger)index;
- (NSInteger)numberItemForSwipeableView:(MLSwipeableHorView *)swipeableView;
@end

@interface MLSwipeableHorView : UIView
@property (nonatomic, weak) id <MLSwipeableHorViewDataSource> dataSource;
@property (nonatomic, weak) id <MLSwipeableHorViewDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign, readonly) NSInteger itemsCount;
@property (nonatomic, assign, readonly) BOOL panEnable;

/**
 *  Enable this to rotate the views behind the top view. Default to YES.
 */
@property (nonatomic) BOOL isRotationEnabled;
/**
 *  Relative vertical offset of the center of rotation. From 0 to 1. Default to 0.3.
 */
@property (nonatomic) float rotationRelativeYOffsetFromCenter;
/**
 *  Magnitude in points per second.
 */
@property (nonatomic) CGFloat escapeVelocityThreshold;
/**
 *  Center of swipable Views. This property is animated.
 */
@property (nonatomic) CGPoint swipeableViewsCenter;

@property (nonatomic, assign) CGSize normalSize;

@property (nonatomic, assign) CGFloat normalOffset;

// 视图view
@property (nonatomic, strong, readonly) UIView *containerView;

/**
 *  Discard all swipeable views on the screen.
 */
-(void)discardAllSwipeableViews;
/**
 *  Load up to 3 swipeable views.
 */
-(void)loadNextSwipeableViewsIfNeeded;
/**
 *  Swipe top view to the left programmatically
 */
-(BOOL)swipeTopViewToLeft;
/**
 *  Swipe top view to the right programmatically
 */
-(BOOL)swipeTopViewToRight;

/**
 top view in containerView
 @return UIView
 */
- (UIView<SwipeableViewProtocol> *)topSwipeableView;

/**
 last view in containerView
 @return UIView
 */
- (UIView<SwipeableViewProtocol> *)lastSwipeableView;

/**
 forceTopViewToLeft ignore enableSwipe
 */
- (void)forceTopViewToLeft;

/**
 forceTopViewToRight ignore enableSwipe
 */
- (void)forceTopViewToRight;
/**
 *  Load up to 3 swipeable views. and set index = 0;
 */
- (void)reloadData;

- (void)reloadData:(BOOL)animated;

- (void)reloadData:(BOOL)animated layout:(BOOL)layout;

/*!
 * The duration of the animation that occurs when a swipe is cancelled. By default, this
 * animation simply slides the view back to its original position. A default value is
 * provided in the `-init` method.
 */
@property (nonatomic, assign) NSTimeInterval swipeClosedAnimationDuration;

/*!
 * Animation options for the swipe-cancelled animation. Default values are provided in the
 * `-init` method.
 */
@property (nonatomic, assign) UIViewAnimationOptions swipeClosedAnimationOptions;


/*!
 * The duration of the animation that occurs when a swipe is cancelled. By default, this
 * animation simply slides the view back to its original position. A default value is
 * provided in the `-init` method.
 */
@property (nonatomic, assign) NSTimeInterval swipeCancelledAnimationDuration;

/*!
 * Animation options for the swipe-cancelled animation. Default values are provided in the
 * `-init` method.
 */
@property (nonatomic, assign) UIViewAnimationOptions swipeCancelledAnimationOptions;

/*!
 * THe duration of the animation that moves a view to its threshold, caused when `mdc_swipe:`
 * is called. A default value is provided in the `-init` method.
 */
@property (nonatomic, assign) NSTimeInterval swipeAnimationDuration;

/*!
 * Animation options for the animation that moves a view to its threshold, caused when
 * `mdc_swipe:` is called. A default value is provided in the `-init` method.
 */
@property (nonatomic, assign) UIViewAnimationOptions swipeAnimationOptions;

/*!
 * The distance, in points, that a view must be panned in order to constitue a selection.
 * For example, if the `threshold` is `100.f`, panning the view `101.f` points to the right
 * is considered a selection in the `MDCSwipeDirectionRight` direction. A default value is
 * provided in the `-init` method.
 */
@property (nonatomic, assign) CGFloat threshold;

/*!
 * When a view is panned, it is rotated slightly. Adjust this value to increase or decrease
 * the angle of rotation.
 */
@property (nonatomic, assign) CGFloat rotationFactor;


/*!
 * A callback to be executed when the view is panned. The block takes an instance of
 * `MDCPanState` as an argument. Use this `state` instance to determine the pan direction
 * and the distance until the threshold is reached.
 */
//@property (nonatomic, copy) MDCSwipeToChooseOnPanBlock onPan;

/*!
 * A callback to be executed when the view is swiped and the swipe is cancelled
 (i.e. because view:shouldBeChosen: delegate callback returned NO for swiped view).
 The view that was swiped is passed into this block so that you can restore its
 state in this callback. May be nil.
 */
//@property (nonatomic, copy) MDCSwipeToChooseOnCancelBlock onCancel;

@end

