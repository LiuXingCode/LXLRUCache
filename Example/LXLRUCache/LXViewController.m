//
//  LXViewController.m
//  LXLRUCache
//
//  Created by liuxing on 08/10/2021.
//  Copyright (c) 2021 liuxing. All rights reserved.
//

#import "LXViewController.h"
#import <LXLRUCache/LXLRUCache.h>

static NSInteger const kMaxCountLimit = 5;

@interface LXViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) LXLRUCache *cache;

@property (nonatomic, copy) NSArray<NSString *> *actionTitles;

@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, strong) NSMutableArray *keys;

@end

@implementation LXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cache = [[LXLRUCache alloc] initWithCountLimit:kMaxCountLimit totalCostLimit:NSIntegerMax];
    self.actionTitles = @[
        @"添加元素",
        @"删除第一个",
        @"删除最后一个",
        @"随机删除一个",
        @"清空所有"
    ];
    self.startIndex = 0;
    self.keys = [NSMutableArray arrayWithCapacity:kMaxCountLimit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.actionTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.actionTitles[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSLog(@"加之前cache:%@", self.cache);
        NSString *key = [NSString stringWithFormat:@"key_%ld", (long)self.startIndex];
        [self.cache setObject:@(self.startIndex) forKey:key];
        NSLog(@"加之后cache:%@", self.cache);
        self.startIndex++;
        if (self.keys.count >= kMaxCountLimit) {
            [self.keys removeObjectAtIndex:0];
        }
        [self.keys addObject:key];
    } else if (indexPath.row == 1) {
        if (self.keys.count == 0) {
            return;
        }
        [self removeCacheForKey:self.keys.firstObject];
    } else if (indexPath.row == 2) {
        if (self.keys.count == 0) {
            return;
        }
        [self removeCacheForKey:self.keys.lastObject];
    } else if (indexPath.row == 3) {
        if (self.keys.count == 0) {
            return;
        }
        [self removeCacheForKey:self.keys[arc4random() % self.keys.count]];
    } else if (indexPath.row == 4) {
        NSLog(@"清空之前cache:%@", self.cache);
        [self.cache removeAllObjects];
        NSLog(@"清空之后cache:%@", self.cache);
        self.startIndex = 0;
        [self.keys removeAllObjects];
    }
}

- (void)removeCacheForKey:(NSString *)key {
    NSLog(@"删除之前cache:%@", self.cache);
    [self.cache removeObjectForKey:key];
    NSLog(@"删除之后cache:%@", self.cache);
    [self.keys removeObject:key];
}

@end
