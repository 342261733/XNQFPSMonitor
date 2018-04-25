//
//  XNQMonitorWindow.h
//  MonitorDemo
//
//  Created by semyon on 2018/4/24.
//  Copyright © 2018年 awsome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XNQMonitorWindow : UIWindow

- (void)show;
- (void)dismiss;
- (void)updateFps:(NSInteger)fps;

@end
