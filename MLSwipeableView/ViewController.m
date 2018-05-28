//
//  ViewController.m
//  MLSwipeableFitView
//
//  Created by Mrlu on 05/03/2018.
//  Copyright © 2018 Mrlu. All rights reserved.
//

#import "ViewController.h"
#import "SwipeItemView.h"

@interface ViewController ()<MLSwipeableFitViewDataSource,MLSwipeableFitViewDelegate>

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.swipeableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.swipeableView.delegate = self;
    self.swipeableView.dataSource = self;
    self.swipeableView.threshold = self.view.frame.size.width/2+80;
    self.swipeableView.escapeVelocityThreshold = 100;
    self.swipeableView.normalOffset = 10;
    self.swipeableView.normalSize = CGRectInset(self.swipeableView.bounds, 30, 30).size;
//    [self.swipeableView reloadData];
}

#pragma mark - MLSwipeableFitViewDataSource
- (UIView<SwipeableViewProtocol> *)nextViewForSwipeableView:(MLSwipeableFitView *)swipeableView index:(NSUInteger)index {
    SwipeItemView *item = [[SwipeItemView alloc] initWithFrame:CGRectMake(0, 0, self.swipeableView.normalSize.width, self.swipeableView.normalSize.height) index:index];
    item.actualHeight = self.swipeableView.normalSize.height+(index+1)%4*40;
    return item;
}

- (NSInteger)numberItemForSwipeableView:(MLSwipeableFitView *)swipeableView {
    return 100;
}

#pragma mark - MLSwipeableFitViewDelegate
- (void)swipeableView: (MLSwipeableFitView *)swipeableView willDisplay:(UIView *)view {
    
}

- (void)swipeableView: (MLSwipeableFitView *)swipeableView didDisplay:(UIView<SwipeableViewProtocol> *)view {
//    [view setVisiable:YES];
}

- (BOOL)swipeableView: (MLSwipeableFitView *)swipeableView willSwipeLeft:(UIView *)view {
    return YES;
}

- (BOOL)swipeableView: (MLSwipeableFitView *)swipeableView willSwipeRight:(UIView *)view {
    return YES;
}

- (void)swipeableView: (MLSwipeableFitView *)swipeableView didSwipeLeft:(UIView *)view {
    
}

- (void)swipeableView: (MLSwipeableFitView *)swipeableView didSwipeRight:(UIView *)view {
    
}

- (void)swipeableView: (MLSwipeableFitView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location {
    
}

- (void)swipeableView: (MLSwipeableFitView *)swipeableView swipingView:(UIView<SwipeableViewProtocol> *)view atLocation:(CGPoint)location panState:(MLPanState *)panState {
//    if ([view isKindOfClass:[SwipeItemView class]]) {
//        SwipeItemView *item = (SwipeItemView *)view;
//        [item swipingViewAtLocation:location panState:panState];
//    }

//    CGFloat height = MIN(fabs(location.x) + (view.originalHeight + 80), view.actualHeight);
    
//    swipeableView.frame = CGRectMake(swipeableView.frame.origin.x, swipeableView.frame.origin.y, swipeableView.frame.size.width, height);
//    [view setVisiable:panState.direction == MLSwipeDirectionNone translate:location.x];
}

- (void)swipeableViewdidEndSwipe:(MLSwipeableFitView *)swipeableView swipingView:(UIView *)view {
    
}

- (void)swipeableViewWillEndSwipe:(MLSwipeableFitView *)swipeableView swipingView:(UIView *)view {
    
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
