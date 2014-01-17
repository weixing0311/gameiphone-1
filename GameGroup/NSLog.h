//
//  NSLog.h
//  RuYiCai
//
//  Created by LiTengjie on 11-7-30.
//  Copyright 2011 China. All rights reserved.
//

#import <Foundation/NSObjCRuntime.h>

#define MYDEBUG 0

#if MYDEBUG
#undef NSLog
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#undef NSLog
#define NSLog(...) do{}while(0)
#endif

#define NSTrace() NSLog(@"%s,%d",__FUNCTION__,__LINE__)

