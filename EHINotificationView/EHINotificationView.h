//
//  EHINotificationView.h
//  EHINotificationView
//
//  Created by yogurts on 2018/8/28.
//  Copyright © 2018年 yogurts. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EHINotificationViewAnimationTypePush,       // 新视图把旧视图推出去
    EHINotificationViewAnimationTypeMoveIn,     // 新视图移到旧视图上面
    EHINotificationViewAnimationTypeReveal,     // 将旧视图移开,显示下面的新视图
    EHINotificationViewAnimationTypeCube,       // 立方体翻滚效果
    EHINotificationViewAnimationTypeOglFlip,    // 上下左右翻转效果
    EHINotificationViewAnimationTypePageCurl,   // 向上翻页效果
    EHINotificationViewAnimationTypePageUnCurl  // 向下翻页效果
} EHINotificationViewAnimationType;     // 动画类型

typedef enum : NSUInteger {
    EHINotificationViewTransitionDirectionFromTop,      // 从上方
    EHINotificationViewTransitionDirectionFromLeft,     // 从左方
    EHINotificationViewTransitionDirectionFromBottom,   // 从下方
    EHINotificationViewTransitionDirectionFromRight     // 从右方
} EHINotificationViewTransitionDirection;      // 过渡方向


@interface EHINotificationView : UIView

/// 图片列表
@property (nonatomic ,strong) NSArray<UIImage *> *imageList;
/// 通知文字列表
@property (nonatomic ,strong) NSArray<NSString *> *noticeList;
/// 动画类型
@property (nonatomic, assign) EHINotificationViewAnimationType animationType;
/// 过渡方向
@property (nonatomic, assign) EHINotificationViewTransitionDirection transitionDirection;
/// 过渡动画时长
@property (nonatomic, assign) CGFloat animationDuration;
/// 执行动画周期，应该大于过渡动画时长
@property (nonatomic, assign) CGFloat animationInterval;
/// 文字颜色
@property (nonatomic, strong) UIColor *textColor;
/// 文字字体
@property (nonatomic, strong) UIFont *textFont;
/// 每一次过渡动画开始的回调
@property (nonatomic, strong) void(^animationDidStart)(void);
/// 每一次过渡动画结束的回调
@property (nonatomic, strong) void(^animationDidStop)(void);

@end
