//
//  XNQMonitorManager.h
//  MonitorDemo
//
//  Created by semyon on 2018/4/24.
//  Copyright © 2018年 awsome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XNQMonitorManager : NSObject

+ (instancetype)start;

/**
 Dissmiss current fps view
 */
- (void)dismissFPS;

@end
