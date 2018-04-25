//
//  XNQMonitorManager.m
//  MonitorDemo
//
//  Created by semyon on 2018/4/24.
//  Copyright © 2018年 awsome. All rights reserved.
//

#import "XNQMonitorManager.h"
#import "XNQFPSMonitor.h"
//#import "XNQMonitorWindow.h"
#import "XNQMonitorView.h"
#import <sys/utsname.h>

@interface XNQMonitorManager()<FPSMonitorDelegate> {
    XNQMonitorView   *_monitorView;
    XNQFPSMonitor    *_fpsMonitor;
}

@end

@implementation XNQMonitorManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    if (self = [super init]) {
        [self setupUI];
        [self setupMonitor];
        [self setupNotification];
    }
    
    return self;
}

//- (void)setupUI {
//    CGFloat iphoneXoffset = [self isIphoneX] ? 34 : 0;
//    CGRect frame = CGRectMake(80, 0 + iphoneXoffset, 60, 20);
//    _monitorView = [[XNQMonitorWindow alloc] initWithFrame:frame];
//    [_monitorView show];
//}

- (void)setupUI {
    CGFloat iphoneXoffset = [self isIphoneX] ? 34 : 0;
    CGFloat oriX = [UIScreen mainScreen].bounds.size.width / 2.0 - 86;
    CGRect frame = CGRectMake(oriX, 0 + iphoneXoffset, 60, 20);
    _monitorView = [[XNQMonitorView alloc] initWithFrame:frame];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            [keyWindow addSubview:self->_monitorView];
        });
        return;
    }
    [keyWindow addSubview:_monitorView];
}

- (void)setupMonitor {
    _fpsMonitor = [XNQFPSMonitor shareInstance];
    _fpsMonitor.delegate = self;
    [_fpsMonitor start];
}

- (void)setupNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)appDidBecomeActive {
    [_fpsMonitor resume];
}

- (void)appWillResignActive {
    [_fpsMonitor pause];
}

//- (void)dismissFPS {
//    [_monitorView dismiss];
//}

- (void)dismissFPS {
    [_monitorView removeFromSuperview];
}

#pragma mark - Monitor delegate

- (void)pfsMonitor:(XNQFPSMonitor *)monitor currentfps:(NSInteger)fps {
//    NSLog(@"fps %zd", fps);
    [_monitorView updateFps:fps];
}

- (BOOL)isIphoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"]) {
        return YES;
    }
    
    return NO;
}

+ (instancetype)start {
    return [[self class] shareInstance];
}

@end
