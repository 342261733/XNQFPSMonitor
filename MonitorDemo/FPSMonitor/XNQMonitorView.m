//
//  XNQMonitorView.m
//  MonitorDemo
//
//  Created by semyon on 2018/4/25.
//  Copyright © 2018年 awsome. All rights reserved.
//

#import "XNQMonitorView.h"

typedef NS_ENUM(NSUInteger, kMonitorStatus) {
    kMonitorStatusGood,
    kMonitorStatusNormal,
    kMonitorStatusBad,
};

@interface XNQMonitorView() {
    UILabel *_monitroLabel;
}

@end

@implementation XNQMonitorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    _monitroLabel = [[UILabel alloc] init];
    _monitroLabel.frame = self.bounds;
    _monitroLabel.textColor = [UIColor lightGrayColor];
    _monitroLabel.backgroundColor = [UIColor greenColor];
    _monitroLabel.text = @"FPS 60";
    _monitroLabel.textAlignment = NSTextAlignmentCenter;
    _monitroLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_monitroLabel];
    self.alpha = 0.7;
}

- (void)updateFps:(NSInteger)fps status:(kMonitorStatus)status {
    _monitroLabel.text = [NSString stringWithFormat:@"FPS %zd", fps];
    switch (status) {
        case kMonitorStatusGood:
            _monitroLabel.backgroundColor = [UIColor greenColor];
            break;
        case kMonitorStatusNormal:
            _monitroLabel.backgroundColor = [UIColor yellowColor];
            break;
        case kMonitorStatusBad:
            _monitroLabel.backgroundColor = [UIColor redColor];
            break;
        default:
            break;
    }
}

- (void)updateFps:(NSInteger)fps {
    kMonitorStatus status;
    if (fps <= 60 && fps > 50) {
        status = kMonitorStatusGood;
    }
    else if (fps <=50 && fps > 45) {
        status = kMonitorStatusNormal;
    }
    else {
        status = kMonitorStatusBad;
    }
    if ([NSThread currentThread] != [NSThread mainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateFps:fps status:status];
        });
    }
    else {
        [self updateFps:fps status:status];
    }
}

@end
