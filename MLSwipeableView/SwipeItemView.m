//
//  SwipeItemView.m
//  MLSwipeableView
//
//  Created by Mrlu on 05/03/2018.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import "SwipeItemView.h"

@interface SwipeItemView()

@end

@implementation SwipeItemView

- (instancetype)initWithFrame:(CGRect)frame index:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self) {
        self.index = index;
        [[NSBundle mainBundle] loadNibNamed:@"SwipeItemView" owner:self options:nil];
        self.contentView.frame = self.bounds;
        [self addSubview:self.contentView];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.testBtn setTitle:@(index).stringValue forState:UIControlStateNormal];
        [self setVisiable:NO];
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
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self setVisiable:NO];
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

- (void)setVisiable:(BOOL)isVisiable {
    [self.edageView setHidden:!isVisiable];
}

- (void)setVisiable:(BOOL)isVisiable translate:(CGFloat)translate {
    
    if (fabs(translate) > 50) {
        [self setVisiable:isVisiable];
    }
    if (fabs(translate) == 0) {
        [self setVisiable:isVisiable];
    }
    self.edageView.transform = CGAffineTransformMakeTranslation(-translate*2, 0);
}

@end
