//
//  MLSwipeableHorView.m
//  MLSwipeableHorViewDemo
//
//  Created by Mrlu on 05/03/2018.
//  Copyright (c) 2018 Mrlu. All rights reserved.
//

#import "MLSwipeableHorView.h"

static const int numPrefetchedViews = 3;

@interface MLSwipeableHorView ()

// ContainerView
@property (nonatomic, strong, readwrite) UIView *containerView;

/*!
 * When the pan gesture originates at the top half of the view, the view rotates
 * away from its original center, and this property takes on a value of 1.
 *
 * When the pan gesture originates at the bottom half, the view rotates toward its
 * original center, and this takes on a value of -1.
 */
@property (nonatomic, assign) MLRotationDirection rotationDirection;
@property (nonatomic, assign) CGFloat usingSpringWithDamping;
@property (nonatomic, assign) CGFloat initialSpringVelocity;
@property (nonatomic, strong) NSMutableArray *cellConstains;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong, readwrite) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) NSMutableArray<SwipeItemTransform *> *swipeItemTransforms;

@end

@implementation MLSwipeableHorView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(void)setup {
    self.index = -1;
    self.normalOffset = 20;
    self.swipeClosedAnimationDuration = 0.25;
    self.swipeClosedAnimationOptions = UIViewAnimationOptionCurveLinear;
    self.swipeCancelledAnimationDuration = 0.6;
    self.usingSpringWithDamping = 0.7;
    self.initialSpringVelocity = 0.7;
    self.swipeCancelledAnimationOptions = UIViewAnimationOptionCurveEaseOut;
    self.swipeAnimationDuration = 0.15;
    self.swipeAnimationOptions = UIViewAnimationOptionCurveEaseInOut;
    self.rotationFactor = 3.f;
    self.threshold = self.bounds.size.width/2;
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.containerView];
    
    // Default properties
    self.isRotationEnabled = NO;
    self.rotationRelativeYOffsetFromCenter = 0.3;
    
    self.escapeVelocityThreshold = 650;

    self.swipeableViewsCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    self.cellConstains = [NSMutableArray<SwipeableViewProtocol> array];
    self.swipeItemTransforms = [NSMutableArray<SwipeItemTransform *> arrayWithObjects:[SwipeItemTransform new],[SwipeItemTransform new],[SwipeItemTransform new], nil];
    
    [self setupPanGestureRecognizer];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.containerView.frame = self.bounds;
    self.swipeableViewsCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

-(void)setSwipeableViewsCenter:(CGPoint)swipeableViewsCenter {
    _swipeableViewsCenter = swipeableViewsCenter;
    [self animateSwipeableViewsIfNeeded:NO];
}

- (void)setupPanGestureRecognizer {
    SEL action = @selector(handlePan:);
    self.panGestureRecognizer =
    [[UIPanGestureRecognizer alloc] initWithTarget:self
                                            action:action];
    [self addGestureRecognizer:self.panGestureRecognizer];
}

- (BOOL)panEnable {
    return self.panGestureRecognizer.enabled && !(self.panGestureRecognizer.state == UIGestureRecognizerStateChanged || self.panGestureRecognizer.state == UIGestureRecognizerStateBegan);
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

#pragma mark - Properties
- (NSInteger)itemsCount {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberItemForSwipeableView:)]) {
        return [self.dataSource numberItemForSwipeableView:self];
    }
    return 0;
}


#pragma mark - Internal Helpers
- (NSInteger)indexOf:(NSInteger)express {
    return (self.itemsCount + (self.index + express)) % self.itemsCount;
}

#pragma mark - DataSource
- (void)discardAllSwipeableViews {
    [self.cellConstains removeAllObjects];
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)reloadData {
    [self reloadData:NO];
}

- (void)reloadData:(BOOL)animated {
    [self reloadData:animated layout:YES];
}

- (void)reloadData:(BOOL)animated layout:(BOOL)layout {
    if (self.dataSource == nil) { return; }
    
    self.index = 0;
        
    [self loadNextSwipeableViewsIfNeeded:animated layout:layout];
}

- (void)loadNextSwipeableViewsIfNeeded {
    [self loadNextSwipeableViewsIfNeeded:NO];
}

- (void)loadNextSwipeableViewsIfNeeded:(BOOL)animated {
    [self loadNextSwipeableViewsIfNeeded:animated layout:YES];
}

- (void)loadNextSwipeableViewsIfNeeded:(BOOL)animated layout:(BOOL)layout {
    NSInteger numViews = self.cellConstains.count;
    NSMutableSet *newViews = [NSMutableSet set];
    if (numViews == numPrefetchedViews) {
        return;
    }
    if (numViews < numPrefetchedViews) {
        UIView<SwipeableViewProtocol> *nextView = [self nextSwipeableView:[self indexOf:1]];
        UIView<SwipeableViewProtocol> *currentView = [self nextSwipeableView:self.index];
        UIView<SwipeableViewProtocol> *frontView = [self nextSwipeableView:[self indexOf:-1]];
        if (frontView && frontView.superview == nil) {
            [self.containerView addSubview:frontView];
            [self.containerView sendSubviewToBack:frontView];
            [self.cellConstains addObject:frontView];
            // 下一张的布局
            frontView.center = CGPointMake(self.swipeableViewsCenter.x - self.normalSize.width - self.normalOffset, self.swipeableViewsCenter.y);
            frontView.transform = CGAffineTransformMakeScale(0.95, 0.95);
            frontView.originalHeight = frontView.frame.size.height;
            [newViews addObject:frontView];
        }
        if (currentView && currentView.superview == nil) {
            [self.containerView addSubview:currentView];
            [self.containerView bringSubviewToFront:currentView];
            [self.cellConstains addObject:currentView];
            
            // 下一张的布局
            currentView.center = CGPointMake(self.swipeableViewsCenter.x, self.swipeableViewsCenter.y);
            currentView.originalHeight = currentView.frame.size.height;

            [newViews addObject:currentView];
        }
        if (nextView && nextView.superview == nil) {
            [self.containerView addSubview:nextView];
            [self.containerView sendSubviewToBack:nextView];
            [self.cellConstains addObject:nextView];
            // 下一张的布局
            nextView.center = CGPointMake(self.swipeableViewsCenter.x + self.normalSize.width + self.normalOffset, self.swipeableViewsCenter.y);
            nextView.transform = CGAffineTransformMakeScale(0.95, 0.95);
            nextView.originalHeight = nextView.frame.size.height;
            [newViews addObject:nextView];
        }
    }
    if (layout) {
        if (animated) {
            NSTimeInterval maxDelay = 0.3;
            NSTimeInterval delayStep = maxDelay/numPrefetchedViews;
            NSTimeInterval aggregatedDelay = maxDelay;
            NSTimeInterval animationDuration = 0.25;
            for (UIView *view in newViews) {
                view.center = CGPointMake(view.center.x, -view.frame.size.height);
                [UIView animateWithDuration: animationDuration
                                      delay: aggregatedDelay
                                    options: UIViewAnimationOptionCurveEaseIn
                                 animations: ^{
                                     view.center = self.swipeableViewsCenter;
                                 }
                                 completion:^(BOOL finished) {
                                 }];
                aggregatedDelay -= delayStep;
            }
            [self performSelector:@selector(animateSwipeableViewsIfNeeded) withObject:nil afterDelay:animationDuration];
        } else {
            [self animateSwipeableViewsIfNeeded];
        }
    }
}

- (void)animateSwipeableViewsIfNeeded {
    [self animateSwipeableViewsIfNeeded:YES];
}

- (void)animateSwipeableViewsIfNeeded:(BOOL)enableDelegate {
    UIView *topSwipeableView = [self topSwipeableView];
    if (!topSwipeableView) {return;}
    
    for (UIView *cover in self.cellConstains) {
        cover.userInteractionEnabled = NO;
    }
    topSwipeableView.userInteractionEnabled = YES;
    NSUInteger numSwipeableViews = self.cellConstains.count;
    
    if (numSwipeableViews>=1) {
        // 不会有抖动效果
        if (enableDelegate && [self.delegate respondsToSelector:@selector(swipeableView:willDisplay:)]) {
            [self.delegate swipeableView:self willDisplay:topSwipeableView];
        }
//        topSwipeableView.center = self.swipeableViewsCenter;
//        topSwipeableView.transform = CGAffineTransformIdentity;
        if (enableDelegate && [self.delegate respondsToSelector:@selector(swipeableView:didDisplay:)]) {
            [self.delegate swipeableView:self didDisplay:topSwipeableView];
        }
    }
    
    if (self.isRotationEnabled) {
//        // rotation
//        CGPoint rotationCenterOffset = {0,CGRectGetHeight(topSwipeableView.frame)*self.rotationRelativeYOffsetFromCenter};
//        if (numSwipeableViews>=2) {
//            [self rotateView:self.cellConstains[numSwipeableViews-2] forDegree:self.rotationFactor atOffsetFromCenter:rotationCenterOffset animated:YES];
//        }
//        if (numSwipeableViews>=3) {
//            [self rotateView:self.cellConstains[numSwipeableViews-3] forDegree:-self.rotationFactor atOffsetFromCenter:rotationCenterOffset animated:YES];
//        }
    }
}

#pragma mark - Action
-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    UIView<SwipeableViewProtocol> *swipeableView = [self topSwipeableView];
    if ([swipeableView respondsToSelector:@selector(enableSwipe)]) {
        if (![swipeableView enableSwipe]) return;
    }
    #pragma mark 下一张卡片变化
    CGFloat basex = CGRectGetWidth(self.frame) / 2.;
    CGFloat basey = CGRectGetHeight(self.frame) / 2.;

    CGFloat move = MAX(fabs(basex-swipeableView.center.x), fabs(basey-swipeableView.center.y));
    CGFloat max = 70.f;
    
    CGFloat ratio = move / max;
    if (ratio > 1) {
        ratio = 1;
    }
    
//    UIView *nextView = [self getNextSwipeableView:swipeableView];
//    if (nextView) {
//        nextView.transform = CGAffineTransformMakeScale(0.95+0.05*ratio, 0.95+0.05*ratio);
//        nextView.center = CGPointMake(self.swipeableViewsCenter.x, self.swipeableViewsCenter.y+(CGRectGetHeight(nextView.frame)/2.*0.05+10)*(1-ratio));
//    }
    
    UIView<SwipeableViewProtocol> *currentView = [self topSwipeableView];
    UIView<SwipeableViewProtocol> *nextView = [self lastSwipeableView];
    UIView<SwipeableViewProtocol> *frontView = [self frontSwipeableView];
    CGPoint translation = [recognizer translationInView:currentView];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        currentView.originalCenter = currentView.center;
        currentView.originalTransform = currentView.transform;
        [self.swipeItemTransforms replaceObjectAtIndex:1 withObject:[[SwipeItemTransform alloc] initWithSwipeProtocol:currentView]];
        nextView.originalCenter = nextView.center;
        nextView.originalTransform = nextView.transform;
        [self.swipeItemTransforms replaceObjectAtIndex:2 withObject:[[SwipeItemTransform alloc] initWithSwipeProtocol:nextView]];
        frontView.originalCenter = frontView.center;
        frontView.originalTransform = frontView.transform;
        [self.swipeItemTransforms replaceObjectAtIndex:0 withObject:[[SwipeItemTransform alloc] initWithSwipeProtocol:frontView]];
        
        // If the pan gesture originated at the top half of the view, rotate the view
        // away from the center. Otherwise, rotate towards the center.
        if ([recognizer locationInView:currentView].y < currentView.center.y) {
            self.rotationDirection = MLRotationAwayFromCenter;
        } else {
            self.rotationDirection = MLRotationTowardsCenter;
        }
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled ||
               recognizer.state == UIGestureRecognizerStateFailed) {
        // Either move the view back to its original position or move it off screen.
        CGPoint velocity = [recognizer velocityInView:self];
        CGFloat velocityMagnitude = sqrt(pow(velocity.x,2)+pow(velocity.y,2));
//        CGPoint normalizedVelocity = CGPointMake(velocity.x/velocityMagnitude, velocity.y/velocityMagnitude);
        [self mdc_finalizePosition:frontView velocity:velocityMagnitude];
        [self mdc_finalizePosition:currentView velocity:velocityMagnitude];
        [self mdc_finalizePosition:nextView velocity:velocityMagnitude];
    } else {
        // Update the position and transform. Then, notify any listeners of
        // the updates via the pan block.
        currentView.center = MLCGPointAddX(currentView.originalCenter, translation, currentView.center.y);
        nextView.center = MLCGPointAddX(nextView.originalCenter, translation, nextView.center.y);
        frontView.center = MLCGPointAddX(frontView.originalCenter, translation, frontView.center.y);
//        [self mdc_rotateForTranslation:translation rotationDirection:self.rotationDirection view:view];
//        [self mdc_TranslationHeight:translation view:currentView];
        [self mdc_Translation:translation view:currentView];
        [self mdc_executeOnPanBlockForTranslation:translation view:currentView isAuto:NO];
    }
}

- (BOOL)swipeTopViewToLeft {
    return [self swipeTopViewToLeft:YES force:NO];
}

- (void)forceTopViewToLeft {
    [self swipeTopViewToLeft:YES force:YES];
}

- (BOOL)swipeTopViewToRight {
    return [self swipeTopViewToLeft:NO force:NO];
}

- (void)forceTopViewToRight {
    [self swipeTopViewToLeft:NO force:YES];
}

- (BOOL)swipeTopViewToLeft:(BOOL)left force:(BOOL)force {
    UIView<SwipeableViewProtocol> *topSwipeableView = [self topSwipeableView];
    if (!topSwipeableView) {return NO;}
    if ([topSwipeableView respondsToSelector:@selector(enableSwipe)] && !force) {
        if(![topSwipeableView enableSwipe]) return NO;
    }
    if (left) {
        [self mdc_swipe:MLSwipeDirectionLeft view:topSwipeableView];
    } else {
        [self mdc_swipe:MLSwipeDirectionRight view:topSwipeableView];
    }
    return YES;
}

#pragma mark - ()

- (CGFloat) degreesToRadians: (CGFloat) degrees
{
    return degrees * M_PI / 180;
};

- (CGFloat) radiansToDegrees: (CGFloat) radians
{
    return radians * 180 / M_PI;
};

- (UIView<SwipeableViewProtocol> *)nextSwipeableView:(NSInteger)index {
    UIView<SwipeableViewProtocol> *nextView = nil;
    nextView = [self viewForIndex:index];
    if (nextView == nil && self.dataSource && [self.dataSource respondsToSelector:@selector(nextViewForSwipeableView:index:)]) {
        nextView = [self.dataSource nextViewForSwipeableView:self index:index];
        nextView.tag = index;
    }
    return nextView;
}

- (UIView<SwipeableViewProtocol> *)viewForIndex:(NSInteger)index {
    UIView<SwipeableViewProtocol> *item = nil;
    for (UIView<SwipeableViewProtocol> *view in self.cellConstains) {
        if ( view.tag == index ) {
            item = view;
            break;
        }
    }
    return item;
}

- (void)rotateView:(UIView*)view forDegree:(float)degree atOffsetFromCenter:(CGPoint)offset animated:(BOOL)animated {
    float duration = animated? 0.4:0;
    NSLog(@"%lf", duration);
    float rotationRadian = [self degreesToRadians:degree];
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        view.center = self.swipeableViewsCenter;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(offset.x, offset.y);
        transform = CGAffineTransformRotate(transform, rotationRadian);
        transform = CGAffineTransformTranslate(transform,-offset.x,-offset.y);
        view.transform=transform;
    } completion:^(BOOL finished) {
//        self.userInteractionEnabled = YES;
    }];
}

- (UIView<SwipeableViewProtocol> *)topSwipeableView {
    return [self viewForIndex:self.index];
}

- (UIView<SwipeableViewProtocol> *)lastSwipeableView {
    return [self viewForIndex:[self indexOf:1]];
}

- (UIView<SwipeableViewProtocol> *)frontSwipeableView {
    return [self viewForIndex:[self indexOf:-1]];
}

#pragma mark - Internal Helpers

- (void)mdc_swipe:(MLSwipeDirection)direction view:(UIView<SwipeableViewProtocol> *)view {
    // A swipe in no particular direction "finalizes" the swipe.
    if (direction == MLSwipeDirectionNone) {
        [self mdc_finalizePosition:view];
        return;
    }
    view.originalCenter = view.center;
    view.originalTransform = view.transform;
    
    /*
    // Moves the view to the minimum point exceeding the threshold.
    // Transforms and executes pan callbacks as well.
    void (^animations)(void) = ^{
        CGPoint translation = [self mdc_translationExceedingThreshold:self.threshold
                                                            direction:direction view:view];
        view.center = MLCGPointAdd(view.center, translation);
        [self mdc_rotateForTranslation:translation
                     rotationDirection:MLRotationAwayFromCenter view:view];
        [self mdc_executeOnPanBlockForTranslation:translation view:view];
        
    };
    
    // Finalize upon completion of the animations.
    void (^completion)(BOOL) = ^(BOOL finished) {
        if (finished) { [self mdc_finalizePosition:view velocity:2000 direction:direction]; }
    };
    
    [UIView animateWithDuration:self.swipeAnimationDuration
                          delay:0.0
                        options:self.swipeAnimationOptions
                     animations:animations
                     completion:completion];
     */
    CGPoint point = view.center;
    point.x += (direction == MLSwipeDirectionLeft?-10:10);
    CGPoint translation = MLCGPointSubtract(point,
                                            view.originalCenter);
    self.panGestureRecognizer.enabled = NO;
    [self mdc_exitSuperviewFromTranslation:translation view:view direction:direction isAuto:YES animation:^{
        CGPoint translation = [self mdc_translationExceedingThreshold:self.threshold
                                                            direction:direction view:view];
        [self mdc_executeOnPanBlockForTranslation:translation view:view isAuto:YES];
//        [self mdc_rotateForTranslation:translation rotationDirection:MLRotationAwayFromCenter view:view rotationFactor:5];
    }];
}

#pragma mark Translation
- (void)mdc_finalizePosition:(UIView<SwipeableViewProtocol> *)view {
    [self mdc_finalizePosition:view velocity:0];
}

- (void)mdc_finalizePosition:(UIView<SwipeableViewProtocol> *)view velocity:(CGFloat)velocity {
    MLSwipeDirection direction = [self mdc_directionOfExceededThreshold:view velocity:velocity];
    [self mdc_finalizePosition:view velocity:velocity direction:direction];
}

- (void)mdc_finalizePosition:(UIView<SwipeableViewProtocol> *)view velocity:(CGFloat)velocity direction:(MLSwipeDirection)direction  {
    switch (direction) {
        case MLSwipeDirectionRight:
        case MLSwipeDirectionLeft: {
            CGPoint translation = MLCGPointSubtract(view.center,
                                                     view.originalCenter);
            [self mdc_exitSuperviewFromTranslation:translation view:view direction:direction];
            break;
        }
        case MLSwipeDirectionNone:
            [self mdc_returnToOriginalCenter:view];
            [self mdc_executeOnPanBlockForTranslation:CGPointZero view:view isAuto:YES];
            break;
    }
}

- (void)mdc_returnToOriginalCenter:(UIView<SwipeableViewProtocol> *)view {
//    UIView *nextView = [self getNextSwipeableView:view];
//    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
//        nextView.center = CGPointMake(self.swipeableViewsCenter.x, self.swipeableViewsCenter.y+CGRectGetHeight(nextView.frame)/2.*0.05+10);
//        nextView.transform = CGAffineTransformMakeScale(0.95, 0.95);
//    } completion:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeableViewWillEndSwipe:swipingView:)]) {
        [self.delegate swipeableViewWillEndSwipe:self swipingView:view];
    }
    [UIView animateWithDuration:self.swipeCancelledAnimationDuration
                          delay:0.0
         usingSpringWithDamping:self.usingSpringWithDamping
          initialSpringVelocity:self.initialSpringVelocity
                        options:self.swipeCancelledAnimationOptions | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         view.transform = view.originalTransform;
                         [self frontSwipeableView].transform = [self frontSwipeableView].originalTransform;
                         [self lastSwipeableView].transform = [self lastSwipeableView].originalTransform;
                         view.center = view.originalCenter;
                         [self frontSwipeableView].center = [self frontSwipeableView].originalCenter;
                         [self lastSwipeableView].center = [self lastSwipeableView].originalCenter;
                     } completion:^(BOOL finished) {
                         if (self.delegate && [self.delegate respondsToSelector:@selector(swipeableViewdidEndSwipe:swipingView:)]) {
                             [self.delegate swipeableViewdidEndSwipe:self swipingView:view];
                         }
                     }];
}

- (void)mdc_exitSuperviewFromTranslation:(CGPoint)translation view:(UIView<SwipeableViewProtocol> *)view direction:(MLSwipeDirection)direction {
    [self mdc_exitSuperviewFromTranslation:translation view:view direction:direction animation:nil];
}

- (void)mdc_exitSuperviewFromTranslation:(CGPoint)translation view:(UIView<SwipeableViewProtocol> *)view direction:(MLSwipeDirection)direction animation:(void (^)(void))animations {
    [self mdc_exitSuperviewFromTranslation:translation view:view direction:direction isAuto:NO animation:nil];
}

- (void)mdc_exitSuperviewFromTranslation:(CGPoint)translation view:(UIView<SwipeableViewProtocol> *)view direction:(MLSwipeDirection)direction isAuto:(BOOL)Auto animation:(void (^)(void))animations {
    if (![view isEqual:[self topSwipeableView]]) {
        return;
    }
    if (direction == MLSwipeDirectionLeft && [self.delegate respondsToSelector:@selector(swipeableView:willSwipeLeft:)]) {
        if (![self.delegate swipeableView:self willSwipeLeft:view]) {
            [self mdc_returnToOriginalCenter:view];
            [self mdc_executeOnPanBlockForTranslation:CGPointZero view:view isAuto:Auto];
            return;
        }
    }
    
    if (direction == MLSwipeDirectionRight && [self.delegate respondsToSelector:@selector(swipeableView:willSwipeRight:)]) {
        if(![self.delegate swipeableView:self willSwipeRight:view]) {
            [self mdc_returnToOriginalCenter:view];
            [self mdc_executeOnPanBlockForTranslation:CGPointZero view:view isAuto:Auto];
            return;
        }
    }
    
    [self exitScreenOnChosenWithDuration:self.swipeClosedAnimationDuration options:self.swipeClosedAnimationDuration translation:translation direction:direction view:view animation:animations];
}

- (void)mdc_executeOnPanBlockForTranslation:(CGPoint)translation view:(UIView *)view isAuto:(BOOL)isAuto {
    if (![view isEqual:[self topSwipeableView]]) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(swipeableView:swipingView:atLocation:panState:)]) {
        CGFloat thresholdRatio = MIN(1.f, fabs(translation.x)/self.threshold);
        
        MLSwipeDirection direction = MLSwipeDirectionNone;
        if (translation.x > 0.f) {
            direction = MLSwipeDirectionRight;
        } else if (translation.x < 0.f) {
            direction = MLSwipeDirectionLeft;
        }
        
        MLPanState *state = [MLPanState new];
        state.view = view;
        state.direction = direction;
        state.thresholdRatio = thresholdRatio;
        state.isAuto = isAuto;
        [self.delegate swipeableView:self swipingView:view atLocation:translation panState:state];
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(swipeableView:swipingView:atLocation:)]) {
        [self.delegate swipeableView:self swipingView:view atLocation:translation];
    }
}

- (void)exitScreenOnChosenWithDuration:(NSTimeInterval)duration
                               options:(UIViewAnimationOptions)options
                           translation:(CGPoint)translation
                             direction:(MLSwipeDirection)direction
                                  view:(UIView<SwipeableViewProtocol> *)view {
    [self exitScreenOnChosenWithDuration:duration options:options translation:translation direction:direction view:view animation:nil];
}

- (void)exitScreenOnChosenWithDuration:(NSTimeInterval)duration
                               options:(UIViewAnimationOptions)options
                           translation:(CGPoint)translation
                             direction:(MLSwipeDirection)direction
                                  view:(UIView<SwipeableViewProtocol> *)view animation:(void (^)(void))animations {
    if (![view isEqual:[self topSwipeableView]]) {
        return;
    }
//    UIView *nextView = [self lastSwipeableView];
//    if (!CGAffineTransformIsIdentity(nextView.transform)) {
//        [UIView animateWithDuration:0.15 delay:0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
//            nextView.center = CGPointMake(self.swipeableViewsCenter.x, self.swipeableViewsCenter.y);
//            nextView.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//
//        }];
//    }
    self.panGestureRecognizer.enabled = NO;
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:options | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         if (direction == MLSwipeDirectionLeft ) {
                             [self frontSwipeableView].center = CGPointMake([self frontSwipeableView].center.x-100, [self frontSwipeableView].center.y);
                             [self lastSwipeableView].center = self.swipeItemTransforms[1].originalCenter;
                             view.center = self.swipeItemTransforms[0].originalCenter;
                             
                             [self lastSwipeableView].transform = self.swipeItemTransforms[1].originalTransform;
                             view.transform = self.swipeItemTransforms[0].originalTransform;
                         }
                         if (direction == MLSwipeDirectionRight) {
                             [self lastSwipeableView].center = CGPointMake([self lastSwipeableView].center.x+100, [self lastSwipeableView].center.y);
                             [self frontSwipeableView].center = self.swipeItemTransforms[1].originalCenter;
                             view.center = self.swipeItemTransforms[2].originalCenter;
                             
                             [self frontSwipeableView].transform = self.swipeItemTransforms[1].originalTransform;
                             view.transform = self.swipeItemTransforms[2].originalTransform;
                         }
                         if (animations) {
                             animations();
                         }
                     } completion:^(BOOL finished) {
                         if (finished) {
                             if (direction == MLSwipeDirectionLeft ) {
                                 [[self frontSwipeableView] removeFromSuperview];
                                 [self.cellConstains removeObject:[self frontSwipeableView]];
                             }
                             if (direction == MLSwipeDirectionRight) {
                                 [[self lastSwipeableView] removeFromSuperview];
                                 [self.cellConstains removeObject:[self lastSwipeableView]];
                             }
                             if (direction == MLSwipeDirectionLeft && [self.delegate respondsToSelector:@selector(swipeableView:didSwipeLeft:)]) {
                                 [self.delegate swipeableView:self didSwipeLeft:view];
                             }
                             if (direction == MLSwipeDirectionRight && [self.delegate respondsToSelector:@selector(swipeableView:didSwipeRight:)]) {
                                 [self.delegate swipeableView:self didSwipeRight:view];
                             }
                             
                             if (direction == MLSwipeDirectionLeft ) {
                                 self.index = [self indexOf:1];
                             }
                             if (direction == MLSwipeDirectionRight) {
                                 self.index = [self indexOf:-1];
                             }
                             [self loadNextSwipeableViewsIfNeeded:NO];
                         }
                         self.panGestureRecognizer.enabled = YES;
                     }];
}
#pragma mark - translate
- (void)mdc_TranslationHeight:(CGPoint)translation view:(UIView<SwipeableViewProtocol> *)view {
    CGFloat height = MAX(view.actualHeight-fabs(translation.x), view.originalHeight);
    view.frame = MLCGRectAddHeight(view.frame, height);
}

- (CGRect)changeHeight:(CGFloat)height view:(UIView<SwipeableViewProtocol> *)view {
    return MLCGRectAddHeight(view.frame, height);
}

- (void)mdc_Translation:(CGPoint)translation view:(UIView *)view {
    view.transform = CGAffineTransformMakeScale(MAX(1 - fabs(translation.x/1000.0), 0.95), MAX(1 - fabs(translation.x/1000), 0.95));
}

#pragma mark Rotation
- (void)mdc_rotateForTranslation:(CGPoint)translation
               rotationDirection:(MLRotationDirection)rotationDirection view:(UIView *)view {
    [self mdc_rotateForTranslation:translation rotationDirection:rotationDirection view:view rotationFactor:self.rotationDirection];
}

- (void)mdc_rotateForTranslation:(CGPoint)translation
               rotationDirection:(MLRotationDirection)rotationDirection view:(UIView *)view  rotationFactor:(CGFloat)rotationFactor {
    CGFloat rotation = MDCDegreesToRadians(translation.x/100 * rotationFactor);
    view.transform = CGAffineTransformMakeRotation(rotationDirection * rotation);
}

#pragma mark Transform

#pragma mark Threshold
- (CGPoint)mdc_translationExceedingThreshold:(CGFloat)threshold
                                   direction:(MLSwipeDirection)direction view:(UIView *)view {
    NSParameterAssert(direction != MLSwipeDirectionNone);
    
    CGFloat offset = threshold + 10.f;
    switch (direction) {
        case MLSwipeDirectionLeft:
            return CGPointMake(-offset, 0);
        case MLSwipeDirectionRight:
            return CGPointMake(offset, 0);
        default:
            [NSException raise:NSInternalInconsistencyException
                        format:@"Invallid direction argument."];
            return CGPointZero;
    }
}

- (MLSwipeDirection)mdc_directionOfExceededThreshold:(UIView<SwipeableViewProtocol> *)view{
    return [self mdc_directionOfExceededThreshold:view velocity:0];
}

- (MLSwipeDirection)mdc_directionOfExceededThreshold:(UIView<SwipeableViewProtocol> *)view velocity:(CGFloat)velocity{
    if (velocity > self.escapeVelocityThreshold) {
        if (view.center.x > view.originalCenter.x + 71) {
            return MLSwipeDirectionRight;
        } else if (view.center.x < view.originalCenter.x - 71) {
            return MLSwipeDirectionLeft;
        } else {
            return MLSwipeDirectionNone;
        }
    } else {
        if (view.center.x > view.originalCenter.x + self.threshold) {
            return MLSwipeDirectionRight;
        } else if (view.center.x < view.originalCenter.x - self.threshold) {
            return MLSwipeDirectionLeft;
        } else {
            return MLSwipeDirectionNone;
        }
    }
}

@end
