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

@implementation EHINotificationView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initContentView];
    }
    return self;
}

- (void)startAnimation {
    
    NSAssert(self.imageList.count <= 1 && self.noticeList.count > 1 ||
             self.imageList.count > 1 && self.noticeList.count == self.imageList.count ||
             self.imageList.count <= 1 && self.noticeList.count == 1, @"图片和文字数量不一致");
    
    if (self.noticeList.count > 1) {
        self.timer = [NSTimer timerWithTimeInterval:self.animationInterval ?: defaultAnimationInterval target:self selector:@selector(displayNews) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        [self.timer invalidate];
    }
}

- (void)stopAnimation {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)initContentView {
    self.image = [UIImageView new];
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.image];
    
    self.notice = [UILabel new];
    self.notice.font = self.textFont ?: [UIFont systemFontOfSize:defaultFontSize];
    self.notice.text = @"查看优惠活动";
    self.notice.textColor = self.textColor ?: defaultColor;
    [self addSubview:self.notice];
}

- (void)layoutSubviews {
//    [self.notice mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.mas_right).with.offset(-10);
//        make.centerY.equalTo(self);
//        make.left.equalTo(self);
//    }];
    if (self.imageList.count) {
        self.image.frame = CGRectMake(16, (self.bounds.size.height - self.image.image.size.height) / 2, self.image.image.size.width, self.image.image.size.height);
    }
    CGFloat noticeHeight = [self.notice sizeThatFits:CGSizeMake(200, self.textFont ? self.textFont.pointSize : 10.f)].height;
    if (self.noticeList.count && self.imageList.count) {
        self.notice.frame = CGRectMake(CGRectGetMaxX(self.image.frame) + 5, (self.bounds.size.height - noticeHeight) / 2, self.bounds.size.width - CGRectGetMaxX(self.image.frame) - 45, noticeHeight);
    } else if (self.noticeList.count && self.imageList.count == 0) {
        self.notice.frame = CGRectMake(12, (self.bounds.size.height - noticeHeight) / 2, self.bounds.size.width - 52, noticeHeight);
    } else {
        
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
    
    if (self.imageList.count > 1) {
        [self.image.layer addAnimation:animation forKey:@"imageAnimation"];
        self.image.image = self.imageList[countInt];
    }
}

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
        case EHINotificationViewTransitionDirectionFromLeft:
            return @"fromLeft";
        case EHINotificationViewTransitionDirectionFromBottom:
            return @"fromBottom";
        case EHINotificationViewTransitionDirectionFromRight:
            return @"fromRight";
        default:
            return @"fromBottom";
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

@end
