//
//  XNQFPSMonitor.m
//  MonitorDemo
//
//  Created by semyon on 2018/4/24.
//  Copyright © 2018年 awsome. All rights reserved.
//

#import "XNQFPSMonitor.h"
#import <UIKit/UIKit.h>

static const NSInteger kFPSExpectPerSecond = 30; // 期望每秒回调次数

@interface XNQFPSMonitor() {
    CADisplayLink   *_displayLink;
    CFTimeInterval  _lastUpdateTimestamp;
    NSUInteger      _timesCount;
    NSInteger       _currentFPS;
    BOOL            _isPause;
}

@end

@implementation XNQFPSMonitor

- (void)dealloc {
    [_displayLink setPaused:YES];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink invalidate];
    _displayLink = nil;
}

+ (instancetype)shareInstance {
    static id __cls = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (nil == __cls) {
            __cls = [[[self class] alloc] init];
        }
    });
    
    return __cls;
}

- (instancetype)init {
    if(self = [super init]) {
        _isPause = YES;
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
        if (@available(iOS 10.0, *)) {
            _displayLink.preferredFramesPerSecond = kFPSExpectPerSecond;
        }
        else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
            _displayLink.frameInterval = 60 / kFPSExpectPerSecond;
#pragma GCC diagnostic pop
        }

        [_displayLink setPaused:YES];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    return self;
}

- (void)displayLinkTick {
    if (_lastUpdateTimestamp <= 0) {
        _lastUpdateTimestamp = _displayLink.timestamp;
        
        return;
    }
    if (@available(iOS 10.0, *)) {
        _timesCount += 60.0 / _displayLink.preferredFramesPerSecond;
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        _timesCount += _displayLink.frameInterval;
#pragma GCC diagnostic pop
    }

    CFTimeInterval interval = _displayLink.timestamp - _lastUpdateTimestamp;
    if(interval >= 1) {
        _lastUpdateTimestamp = _displayLink.timestamp;
        _currentFPS = _timesCount / interval;
        _timesCount = 0;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pfsMonitor:currentfps:)]) {
            [self.delegate pfsMonitor:self currentfps:_currentFPS];
        }
    }
}

- (void)start {
    _isPause = NO;
    _timesCount = 0;
    _lastUpdateTimestamp = 0;
    [_displayLink setPaused:NO];
}

- (void)pause {
    _isPause = YES;
    [_displayLink setPaused:YES];
}

- (void)resume {
    if (_isPause) {
        [self start];
    }
}

- (void)stop {
    _isPause = YES;
    [_displayLink setPaused:YES];
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink invalidate];
    _displayLink = nil;
}

- (NSInteger)currentFPS {
    return _currentFPS;
}

@end
