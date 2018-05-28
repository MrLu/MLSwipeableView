//
//  SwipeItemView.h
//  MLSwipeableView
//
//  Created by Mrlu on 05/03/2018.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSwipeableFitView.h"

@interface SwipeItemView : UIView <SwipeableViewProtocol>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *edageView;
@property (weak, nonatomic) IBOutlet UIButton *testBtn;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) CGAffineTransform originalTransform;
@property (nonatomic, assign) CGFloat actualHeight;
@property (nonatomic, assign) CGFloat originalHeight;
@property (nonatomic, assign) CGRect originalFrame;


- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index;

- (void)swipingViewAtLocation:(CGPoint)location panState:(MLPanState *)panState;

@end
