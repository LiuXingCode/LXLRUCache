//
//  LXLRUCache.h
//  LXLRUCache
//
//  Created by liuxing on 2021/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXLRUCache<__covariant KeyType, __covariant ObjectType> : NSObject

@property (nonatomic, assign) NSUInteger countLimit;

@property (nonatomic, assign) NSUInteger totalCostLimit;

@property (nonatomic, assign, readonly) NSUInteger count;

@property (nonatomic, assign, readonly) NSUInteger totalCost;

- (instancetype)initWithCountLimit:(NSUInteger)countLimit totalCostLimit:(NSUInteger)totalCostLimit;

- (void)setObject:(ObjectType)object forKey:(KeyType)key;

- (void)setObject:(ObjectType)object forKey:(KeyType)key cost:(NSUInteger)cost;

- (ObjectType)objectForKey:(KeyType)key;

- (ObjectType)removeObjectForKey:(KeyType)key;

- (void)removeAllObjects;

- (BOOL)isEmpty;

@end

NS_ASSUME_NONNULL_END
