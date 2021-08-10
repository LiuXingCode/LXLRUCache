//
//  LXLRUCache.m
//  LXLRUCache
//
//  Created by liuxing on 2021/8/10.
//

#import "LXLRUCache.h"
#import "LXLinkedListNode.h"

@interface LXLRUCache()

@property (nonatomic, strong) NSMutableDictionary<id, LXLinkedListNode *> *objects;

@property (nonatomic, strong) NSLock *lock;

@property (nonatomic, strong) LXLinkedListNode *head;

@property (nonatomic, strong) LXLinkedListNode *tail;

@property (nonatomic, assign, readwrite) NSUInteger totalCost;

@end

@implementation LXLRUCache

- (instancetype)init {
    return [self initWithCountLimit:NSUIntegerMax totalCostLimit:NSUIntegerMax];
}

- (instancetype)initWithCountLimit:(NSUInteger)countLimit totalCostLimit:(NSUInteger)totalCostLimit {
    if (self = [super init]) {
        self.lock = [[NSLock alloc] init];
        self.objects = [NSMutableDictionary dictionary];
        self.countLimit = countLimit;
        self.totalCostLimit = totalCostLimit;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarningNotification) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiveMemoryWarningNotification {
    [self removeAllObjects];
}

- (void)setObject:(id)object forKey:(id)key {
    [self setObject:object forKey:key cost:0];
}

- (void)setObject:(id)object forKey:(id)key cost:(NSUInteger)cost {
    if (object == nil) {
        [self removeObjectForKey:key];
        return;
    }
    [self.lock lock];
    LXLinkedListNode *node = [self.objects objectForKey:key];
    if (node) {
        node.object = object;
        self.totalCost -= cost;
        node.cost = cost;
        [self removeNode:node];
        [self appendNode:node];
    } else {
        LXLinkedListNode *node = [[LXLinkedListNode alloc] initWithKey:key object:object cost:cost];
        self.objects[key] = node;
        [self appendNode:node];
    }
    self.totalCost += cost;
    [self.lock unlock];
    [self clean];
}

- (id)objectForKey:(id)key {
    [self.lock lock];
    LXLinkedListNode *node = [self.objects objectForKey:key];
    if (node) {
        [self removeNode:node];
        [self appendNode:node];
    }
    [self.lock unlock];
    return node.object;
}

- (id)removeObjectForKey:(id)key {
    [self.lock lock];
    LXLinkedListNode *node = [self.objects objectForKey:key];
    if (node) {
        [self removeNode:node];
        [self.objects removeObjectForKey:key];
        self.totalCost -= node.cost;
    }
    [self.lock unlock];
    return node.object;
}

- (void)removeAllObjects {
    [self.lock lock];
    [self.objects removeAllObjects];
    self.head = nil;
    self.tail = nil;
    [self.lock unlock];
}

- (void)setCountLimit:(NSUInteger)countLimit {
    _countLimit = countLimit;
    [self clean];
}

- (void)setTotalCostLimit:(NSUInteger)totalCostLimit {
    _totalCostLimit = totalCostLimit;
    [self clean];
}

- (NSUInteger)count {
    return self.objects.count;
}

- (BOOL)isEmpty {
    return self.count == 0;
}

#pragma mark - LinkedList

- (void)removeNode:(LXLinkedListNode *)node {
    if (self.head == nil) {
        return;
    }
    if (self.head == node) {
        self.head = self.head.next;
    }
    if (self.tail == node) {
        self.tail = self.tail.prev;
    }
    if (node.prev) {
        node.prev.next = node.next;
    }
    if (node.next) {
        node.next.prev = node.prev;
    }
}

- (void)appendNode:(LXLinkedListNode *)node {
    if (self.head == nil) {
        self.head = self.tail = node;
        return;
    }
    node.prev = self.tail;
    self.tail.next = node;
    self.tail = node;
}

- (void)clean {
    [self.lock lock];
    while ((self.totalCost > self.totalCostLimit || self.count > self.countLimit) && self.head != nil) {
        LXLinkedListNode *tempHead = self.head;
        [self removeNode:tempHead];
        [self.objects removeObjectForKey:tempHead.key];
        self.totalCost -= tempHead.cost;
    }
    [self.lock unlock];
}

- (NSString *)description {
#if DEBUG
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendString:@"["];
    LXLinkedListNode *tempNode = self.head;
    while (tempNode) {
        [str appendString:[NSString stringWithFormat:@"%@ : %@", tempNode.key, tempNode.object]];
        tempNode = tempNode.next;
        if (tempNode) {
            [str appendString:@", "];
        }
    }
    [str appendString:@"]"];
    return str.copy;
#endif
    return [super description];
}

@end
