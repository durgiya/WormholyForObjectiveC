//
//  NSString+Wormholy.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Wormholy)

- (NSString *)prettyPrintedJSON;
+ (NSString *)formattedMilliseconds:(double)rounded;

@end

NS_ASSUME_NONNULL_END
