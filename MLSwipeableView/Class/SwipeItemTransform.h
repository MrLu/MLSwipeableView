//
//  SwipeItemTransform.h
//  MLSwipeableView
//
//  Created by Mrlu on 2018/5/25.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SwipeableViewProtocol.h"

typedef CGFloat MLRotationDirection;
extern const MLRotationDirection MLRotationAwayFromCenter;
extern const MLRotationDirection MLRotationTowardsCenter;

@interface SwipeItemTransform:NSObject

@property (nonatomic, assign) CGPoint originalCenter;
@property (nonatomic, assign) CGAffineTransform originalTransform;
@property (nonatomic, assign) CGRect originalFrame;

- (instancetype)initWithSwipeProtocol:(id<SwipeableViewProtocol>)obj;

@end
