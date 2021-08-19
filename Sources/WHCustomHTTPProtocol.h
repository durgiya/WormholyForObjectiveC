//
//  WHCustomHTTPProtocol.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

@interface WHCustomHTTPProtocol : NSURLProtocol

@property (nonatomic, copy, class) NSArray<NSString *> *ignoredHosts;

@end

NS_ASSUME_NONNULL_END
