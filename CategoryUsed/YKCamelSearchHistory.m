//
//  NSUserDefaults+searchHistory.m
//  YKSegmentTableView
//
//  Created by yanguo.sun on 13-4-9.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelSearchHistory.h"

@implementation  YKCamelSearchHistory
+ (void)clearSearchHistoryOver{
    [[self class] setSearchHistory:nil];
}
+ (NSArray*)getSearchHistory{
    NSArray * ret =  [[NSUserDefaults standardUserDefaults] objectForKey:KHistory];
    return ret;
}
+ (void)setSearchHistory:(NSArray *)_history{
    [[NSUserDefaults standardUserDefaults] setObject:_history forKey:KHistory];
}
+ (BOOL)containKeyWord:(NSString *)_key array:(NSArray*)_array{
    BOOL ret = YES;
    NSArray *array = _array;
    NSString *string = _key;
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF == %@",string];
    NSArray *retArray = [array filteredArrayUsingPredicate:pred];
    if (retArray==nil||retArray.count<1) {
        ret =  NO;
    }else{
        ret =  YES;
    }
    return ret;
}
+ (void)fixHistory:(NSMutableArray*)_array{
    if (_array.count>[self getNumberOfHistory]) {
        [_array removeObject:[_array objectAtIndex: 0]];
    }
}
+ (NSUInteger)indexOfKeyWord:(NSString *)_key array:(NSArray*)_array{
    __block NSUInteger index = NSNotFound;

    if ([[self class] containKeyWord:_key array:_array]) {
        [_array enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            if ([obj isEqualToString:_key]) {
                index = idx;
                *stop = YES;
            }
        }];
    }
    return index;
}

+ (void)deleteHisoryKeyWord:(NSString *)_keyWord{
    NSMutableArray *mut = [[[self class] getSearchHistory] mutableCopy];
    int keywordIndex = [[self class] indexOfKeyWord:_keyWord array:mut];
    if (keywordIndex==NSNotFound) {
        return;
    }
    [mut removeObjectAtIndex:keywordIndex];
    [[self class] setSearchHistory:mut];

}
+ (void)setHistoryKeyWord:(NSString *)_keyWord{
//TODO: 请修改 这里要加判断，空字符等，或者在搜索那里加。这里就不用加了
    assert(_keyWord!=nil);
    NSMutableArray *mut =   [[[self class]getSearchHistory] mutableCopy];
    if (!mut) {
        mut = [NSMutableArray new];
    }
    if ([[self class] containKeyWord:_keyWord array:mut]) {
        [[self class] deleteHisoryKeyWord:_keyWord];
        mut = [[[self class]getSearchHistory] mutableCopy];
    }
    [mut addObject:_keyWord];
    [[self class] fixHistory:mut];
    [[self class] setSearchHistory:mut];
    
}
+ (void)setNumberOfHistory:(int)_numbers{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:_numbers] forKey:KHistoryNumber];
}
+ (int)getNumberOfHistory{
      return  [[[NSUserDefaults standardUserDefaults] objectForKey:KHistoryNumber] intValue];
}

@end
