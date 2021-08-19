//
//  NSURLSessionConfiguration+Wormholy.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/18.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "NSURLSessionConfiguration+Wormholy.h"
#import "NSObject+Wormholy.h"
#import "WHCustomHTTPProtocol.h"

@implementation NSURLSessionConfiguration (Wormholy)

+ (void)load{
    [[self class] wormholy_swizzleClassMethodWithOriginSel:@selector(defaultSessionConfiguration) swizzledSel:@selector(wormholy_defaultSessionConfiguration)];
    [[self class] wormholy_swizzleClassMethodWithOriginSel:@selector(ephemeralSessionConfiguration) swizzledSel:@selector(wormholy_ephemeralSessionConfiguration)];
}

+ (NSURLSessionConfiguration *)wormholy_defaultSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self wormholy_defaultSessionConfiguration];
    [configuration addDoraemonNSURLProtocol];
    return configuration;
}

+ (NSURLSessionConfiguration *)wormholy_ephemeralSessionConfiguration{
    NSURLSessionConfiguration *configuration = [self wormholy_ephemeralSessionConfiguration];
    [configuration addDoraemonNSURLProtocol];
    return configuration;
}

- (void)addDoraemonNSURLProtocol {
    if ([self respondsToSelector:@selector(protocolClasses)]
        && [self respondsToSelector:@selector(setProtocolClasses:)]) {
        NSMutableArray * urlProtocolClasses = [NSMutableArray arrayWithArray: self.protocolClasses];
        Class protoCls = WHCustomHTTPProtocol.class;
        if (![urlProtocolClasses containsObject:protoCls]) {
            [urlProtocolClasses insertObject:protoCls atIndex:0];
        }
        self.protocolClasses = urlProtocolClasses;
    }
}

@end
