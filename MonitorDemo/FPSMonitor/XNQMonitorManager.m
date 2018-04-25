//
//  XNQMonitorManager.m
//  MonitorDemo
//
//  Created by semyon on 2018/4/24.
//  Copyright © 2018年 awsome. All rights reserved.
//

#import "XNQMonitorManager.h"
#import "XNQFPSMonitor.h"
#import "XNQMonitorWindow.h"
#import <sys/utsname.h>

@interface XNQMonitorManager()<FPSMonitorDelegate> {
    XNQMonitorWindow *_monitorView;
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

- (void)setupUI {
    CGFloat iphoneXoffset = [self isIphoneX] ? 34 : 0;
    CGRect frame = CGRectMake(80, 0 + iphoneXoffset, 60, 20);
    _monitorView = [[XNQMonitorWindow alloc] initWithFrame:frame];
    [_monitorView show];
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

- (void)dismissFPS {
    [_monitorView dismiss];
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
