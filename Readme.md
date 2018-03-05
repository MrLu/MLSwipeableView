# MLSwipeableView
[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
             )](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-ObjC-brightgreen.svg?style=flat)](https://developer.apple.com/Objective-C)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](http://mit-license.org)

*SwipeableView 类 探探主页面。卡片滑动*

### thaks to
* [ZLSwipeableView](https://github.com/zhxnlai/ZLSwipeableView)
* [MLSwipeToChoose](https://github.com/MrLu/MLSwipeToChoose)

### 使用

`@property (nonatomic, assign) MLSwipeDirection direction;`

`@property (nonatomic, assign) CGFloat thresholdRatio;`

`@property (nonatomic, assign) BOOL isAuto;`


```
@protocol MLSwipeableViewDataSource <NSObject>
@required
- (UIView<SwipeableViewProtocol> *)nextViewForSwipeableView:(MLSwipeableView *)swipeableView index:(NSUInteger)index;
@end
```

```
@protocol MLSwipeableViewDelegate <NSObject>
@optional
- (void)swipeableView: (MLSwipeableView *)swipeableView willDisplay:(UIView *)view;
- (void)swipeableView: (MLSwipeableView *)swipeableView didDisplay:(UIView *)view;
- (BOOL)swipeableView: (MLSwipeableView *)swipeableView willSwipeLeft:(UIView *)view;
- (BOOL)swipeableView: (MLSwipeableView *)swipeableView willSwipeRight:(UIView *)view;
- (void)swipeableView: (MLSwipeableView *)swipeableView didSwipeLeft:(UIView *)view;
- (void)swipeableView: (MLSwipeableView *)swipeableView didSwipeRight:(UIView *)view;
- (void)swipeableView: (MLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location;
- (void)swipeableView: (MLSwipeableView *)swipeableView swipingView:(UIView *)view atLocation:(CGPoint)location panState:(MLPanState *)panState;
- (void)swipeableViewdidEndSwipe:(MLSwipeableView *)swipeableView swipingView:(UIView *)view;
- (void)swipeableViewWillEndSwipe:(MLSwipeableView *)swipeableView swipingView:(UIView *)view;
@end
```



### by
* 问题建议 to mail
* mail：haozi370198370@gmail.com
