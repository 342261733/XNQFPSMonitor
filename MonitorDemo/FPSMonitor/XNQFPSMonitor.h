//
//  XNQFPSMonitor.h
//  MonitorDemo
//
//  Created by semyon on 2018/4/24.
//  Copyright © 2018年 awsome. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XNQFPSMonitor;
@protocol FPSMonitorDelegate <NSObject>

@required
- (void)pfsMonitor:(XNQFPSMonitor *)monitor currentfps:(NSInteger)fps;

@end

@interface XNQFPSMonitor : NSObject

@property (nonatomic, weak) id<FPSMonitorDelegate> delegate;

+ (instancetype)shareInstance;

- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;

- (NSInteger)currentFPS;

@end
