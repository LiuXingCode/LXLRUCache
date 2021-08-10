//
//  LXLinkedListNode.h
//  LXLRUCache
//
//  Created by liuxing on 2021/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXLinkedListNode<__covariant KeyType, __covariant ObjectType> : NSObject

@property (nonatomic, strong) LXLinkedListNode *prev;

@property (nonatomic, strong) LXLinkedListNode *next;

@property (nonatomic, strong) KeyType key;

@property (nonatomic, strong) ObjectType object;

@property (nonatomic, assign) NSUInteger cost;

- (instancetype)initWithKey:(KeyType)key object:(ObjectType)object cost:(NSUInteger)cost;

@end

NS_ASSUME_NONNULL_END
