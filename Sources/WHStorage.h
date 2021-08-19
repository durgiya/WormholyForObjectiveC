//
//  WHStorage.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHStorage : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<WHRequestModel *> *requests;
@property (nonatomic, strong) NSNumber *limit;

+ (instancetype)sharedInstance;
- (void)saveRequest:(WHRequestModel *)request;
- (void)clearRequests;

@end

NS_ASSUME_NONNULL_END
