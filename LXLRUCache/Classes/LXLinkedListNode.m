//
//  LXLinkedListNode.m
//  LXLRUCache
//
//  Created by liuxing on 2021/8/10.
//

#import "LXLinkedListNode.h"

@implementation LXLinkedListNode

- (instancetype)initWithKey:(id)key object:(id)object cost:(NSUInteger)cost {
    if (self = [super init]) {
        self.key = key;
        self.object = object;
        self.cost = cost;
    }
    return self;
}

@end
