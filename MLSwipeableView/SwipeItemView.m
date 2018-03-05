//
//  SwipeItemView.m
//  MLSwipeableView
//
//  Created by Mrlu on 05/03/2018.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import "SwipeItemView.h"

@implementation SwipeItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SwipeItemView" owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SwipeItemView" owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self.contentView setBackgroundColor:backgroundColor];
}

- (void)swipingViewAtLocation:(CGPoint)location panState:(MLPanState *)panState {
    if (panState.direction == MLSwipeDirectionLeft) {
        [self.backgroundView setImage:[UIImage imageNamed:@"bg_WordCard_strangeness"]];
    } else if (panState.direction == MLSwipeDirectionRight) {
        [self.backgroundView setImage:[UIImage imageNamed:@"bg_WordCard_understand"]];
    } else {
        [self.backgroundView setImage:[UIImage imageNamed:@"bg_WordCard_default"]];
    }
}

- (BOOL)enableSwipe {
    return YES;
}

@end
