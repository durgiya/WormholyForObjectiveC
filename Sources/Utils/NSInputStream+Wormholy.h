//
//  NSStream+Wormholy.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSInputStream (Wormholy)

- (NSData *)readfully;

@end

NS_ASSUME_NONNULL_END
