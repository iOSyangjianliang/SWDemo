//
//  NSObject+RRDeallocBlock.m
//  ThemeManager
//
//  Created by 杨建亮 on 2019/6/26.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "NSObject+RRDeallocBlock.h"

#import <objc/runtime.h>

const void *RRDeallocExecutorsKey = &RRDeallocExecutorsKey;

@interface RRDeallocExecutor : NSObject

@property (nonatomic, copy) void(^deallocExecutorBlock)(void);

@end

@implementation RRDeallocExecutor

- (id)initWithBlock:(void(^)(void))deallocExecutorBlock {
    self = [super init];
    if (self) {
        _deallocExecutorBlock = [deallocExecutorBlock copy];
    }
    return self;
}

- (void)dealloc {
    _deallocExecutorBlock ? _deallocExecutorBlock() : nil;
}

@end


@implementation NSObject (RRDeallocBlock)

- (void)sd_executeAtDealloc:(void (^)(void))block {
    if (block) {
        RRDeallocExecutor *executor = [[RRDeallocExecutor alloc] initWithBlock:block];
        @synchronized (self) {
            [[self hs_deallocExecutors] addObject:executor];
        }
    }
}

- (NSHashTable *)hs_deallocExecutors {
    NSHashTable *table = objc_getAssociatedObject(self,RRDeallocExecutorsKey);
    if (!table) {
        table = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
        objc_setAssociatedObject(self, RRDeallocExecutorsKey, table, OBJC_ASSOCIATION_RETAIN);
    }
    return table;
}
@end
