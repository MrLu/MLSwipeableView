//
//  SwipeableViewProtocol.h
//  MLSwipeableView
//
//  Created by Mrlu on 2018/5/25.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SwipeableViewProtocol <NSObject>

@required
@property (nonatomic, assign) CGAffineTransform originalTransform;

@optional
@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign) CGFloat originalHeight;
@property (nonatomic, assign) CGFloat actualHeight;

- (BOOL)enableSwipe;
- (void)setVisiable:(BOOL)isVisiable;
- (void)setVisiable:(BOOL)isVisiable translate:(CGFloat)translate;

@end
