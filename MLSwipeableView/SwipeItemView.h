//
//  SwipeItemView.h
//  MLSwipeableView
//
//  Created by Mrlu on 05/03/2018.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLSwipeableView.h"

@interface SwipeItemView : UIView <SwipeableViewProtocol>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
- (void)swipingViewAtLocation:(CGPoint)location panState:(MLPanState *)panState;
@end
