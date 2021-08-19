//
//  WHWormholy.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const fireWormholy;

@interface WHWormholy : NSObject

@property (nonatomic, copy, class) NSArray<NSString *> *ignoredHosts;
@property (nonatomic, strong, class) NSNumber *limit;
@property (nonatomic, assign, class) BOOL shakeEnabled;

@end

NS_ASSUME_NONNULL_END
