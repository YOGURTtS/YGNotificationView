//
//  EHINotificationView.m
//  EHINotificationView
//
//  Created by yogurts on 2018/8/28.
//  Copyright © 2018年 yogurts. All rights reserved.
//

#import "EHINotificationView.h"
#define defaultColor [UIColor lightGrayColor]

@interface EHINotificationView () <CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic ,strong) UILabel *notice;
@property (nonatomic, strong) NSTimer *timer;

@end

static int countInt = 0;
static CGFloat defaultAnimationDuration = .5f;
static CGFloat defaultAnimationInterval = 2.f;
static CGFloat defaultFontSize = 10.f;

@implementation EHINotificationView {
    BOOL _hasImage;
}

#pragma mark - initialization

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    if (_hasImage) {
        [self addSubview:self.image];
    }
    [self addSubview:self.notice];
}

#pragma mark - methods

- (void)layoutSubviews {
    self.image.frame = CGRectMake(16, (self.bounds.size.height - self.image.image.size.height) / 2, self.image.image.size.width, self.image.image.size.height);
    CGFloat noticeHeight = [self.notice sizeThatFits:CGSizeMake(200, self.textFont ? self.textFont.pointSize : 10.f)].height;
    if (self.noticeList.count && _hasImage) {
        self.notice.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 5, (self.bounds.size.height - noticeHeight) / 2, self.bounds.size.width - CGRectGetMaxX(self.image.frame) - 45, noticeHeight);
    } else {
        self.notice.frame = CGRectMake(12, (self.bounds.size.height - noticeHeight) / 2, self.bounds.size.width - 52, noticeHeight);
    }
}

#pragma mark - about animation

- (NSString *)getAnimationType {
    switch (self.animationType) {
        case EHINotificationViewAnimationTypePush:
            return @"push";
        case EHINotificationViewAnimationTypeMoveIn:
            return @"moveIn";
        case EHINotificationViewAnimationTypeReveal:
            return @"reveal";
        case EHINotificationViewAnimationTypeCube:
            return @"cube";
        case EHINotificationViewAnimationTypeOglFlip:
            return @"oglFlip";
        case EHINotificationViewAnimationTypePageCurl:
            return @"pageCurl";
        case EHINotificationViewAnimationTypePageUnCurl:
            return @"pageUnCurl";
        default:
            return @"push";
    }
}

- (NSString *)getTransitionDirection {
    switch (self.transitionDirection) {
        case EHINotificationViewTransitionDirectionFromTop:
            return @"fromTop";
//        case EHINotificationViewTransitionDirectionFromLeft:
//            return @"fromLeft";
        case EHINotificationViewTransitionDirectionFromBottom:
            return @"fromBottom";
//        case EHINotificationViewTransitionDirectionFromRight:
//            return @"fromRight";
        default:
            return @"fromBottom";
    }
}

- (void)startAnimation {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    if (self.noticeList.count > 1) {
        self.timer = [NSTimer timerWithTimeInterval:self.animationInterval ?: defaultAnimationInterval target:self selector:@selector(displayNews) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        [self.timer invalidate];
    }
}

- (void)displayNews {
    if (!self.noticeList.count || self.noticeList.count == 0) {
        return;
    }
    countInt++;
    
    if (countInt >= [self.noticeList count])
        countInt = 0;
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = self.animationDuration ?: defaultAnimationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.type = [self getAnimationType];
    animation.subtype = [self getTransitionDirection];
    
    [self.notice.layer addAnimation:animation forKey:@"noticeAnimation"];
    self.notice.text = self.noticeList[countInt];
}

- (void)stopAnimation {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)animationDidStart:(CAAnimation *)anim {
    if (self.animationDidStart) {
        self.animationDidStart();
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (self.animationDidStop) {
        self.animationDidStop();
    }
}

#pragma mark - setter

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    self.image.image = icon;
    _hasImage = YES;
    [self layoutSubviews];
}

- (void)setNoticeList:(NSArray *)noticeList {
    _noticeList = noticeList;
    if (noticeList.count) {
        countInt = 0;
        self.notice.text = [self.noticeList firstObject];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.notice.textColor = textColor;
}

#pragma mark - properties

- (UIImageView *)image {
    if (!_image) {
        _image = [UIImageView new];
        _image.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _image;
}

- (UILabel *)notice {
    if (!_notice) {
        _notice = [UILabel new];
        _notice.font = [UIFont systemFontOfSize:defaultFontSize];
        _notice.text = @"查看优惠活动";
        _notice.textColor = defaultColor;
    }
    return _notice;
}

@end
