//
//  WHStorage.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHStorage.h"

@interface WHStorage ()

@property (nonatomic, strong) NSMutableArray<WHRequestModel *> *requests;

@end

@implementation WHStorage

+ (instancetype)sharedInstance {
    static WHStorage *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WHStorage alloc] init];
    });
    
    return instance;
}

- (void)saveRequest:(WHRequestModel *)request {
    if (request == nil) {
        return;
    }
    
    NSInteger targetIndex = -1;
    for (NSInteger i = 0; i < self.requests.count; i++) {
        WHRequestModel *model = [self.requests objectAtIndex:i];
        if (model.uuid == request.uuid) {
            targetIndex = i;
            break;
        }
    }
    
    if (targetIndex != -1) {
        [self.requests replaceObjectAtIndex:targetIndex withObject:request];
    } else {
        [self.requests insertObject:request atIndex:0];
    }
    
    if (self.limit.integerValue != 0 && self.requests.count > self.limit.integerValue) {
        NSArray *subArray = [self.requests subarrayWithRange:NSMakeRange(0, self.limit.integerValue)];
        self.requests = [NSMutableArray arrayWithArray:subArray];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wormholy_new_request" object:nil];
}

- (void)clearRequests {
    [self.requests removeAllObjects];
}

- (NSMutableArray<WHRequestModel *> *)requests {
    if (_requests == nil) {
        _requests = [NSMutableArray array];
    }
    
    return _requests;
}

@end
