//
//  ViewController.m
//  MLSwipeableView
//
//  Created by Mrlu on 05/03/2018.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import "ViewController.h"
#import "SwipeItemView.h"

@interface ViewController ()<MLSwipeableViewDataSource,MLSwipeableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.swipeableView.delegate = self;
    self.swipeableView.dataSource = self;
    self.swipeableView.threshold = self.view.frame.size.width/2+80;
    self.swipeableView.escapeVelocityThreshold = 100;
    [self.swipeableView reloadData];
}

#pragma mark - MLSwipeableViewDataSource
- (UIView<SwipeableViewProtocol> *)nextViewForSwipeableView:(MLSwipeableView *)swipeableView index:(NSUInteger)index {
    SwipeItemView *item = [[SwipeItemView alloc] initWithFrame:CGRectInset(swipeableView.bounds, 40, 30)];
    return item;
}

#pragma mark - MLSwipeableViewDelegate
- (void)swipeableView: (MLSwipeableView *)swipeableView willDisplay:(UIView *)view {
    
}

- (void)swipeableView: (MLSwipeableView *)swipeableView didDisplay:(UIView *)view {
    
}

- (BOOL)swipeableView: (MLSwipeableView *)swipeableView willSwipeLeft:(UIView *)view {
    return YES;
}

- (BOOL)swipeableView: (MLSwipeableView *)swipeableView willSwipeRight:(UIView *)view {
    return YES;
}

- (void)swipeableView: (MLSwipeableView *)swipeableView didSwipeLeft:(UIView *)view {
    
}

- (void)swipeableView: (MLSwipeableView *)swipeableView didSwipeRight:(UIView *)view {
    
}

- (void)swipeableView: (MLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location {
    
}

- (void)swipeableView: (MLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location panState:(MLPanState *)panState {
    if ([view isKindOfClass:[SwipeItemView class]]) {
        SwipeItemView *item = (SwipeItemView *)view;
        [item swipingViewAtLocation:location panState:panState];
    }
}

- (void)swipeableViewdidEndSwipe:(MLSwipeableView *)swipeableView swipingView:(UIView *)view {
    
}

- (void)swipeableViewWillEndSwipe:(MLSwipeableView *)swipeableView swipingView:(UIView *)view {
    
}

- (IBAction)leftAction:(id)sender {
    [self.swipeableView swipeTopViewToLeft];
}

- (IBAction)rightAction:(id)sender {
    [self.swipeableView swipeTopViewToRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
