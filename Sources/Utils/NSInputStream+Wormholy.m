//
//  NSInputStream+Wormholy.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "NSInputStream+Wormholy.h"

@implementation NSInputStream (Wormholy)

- (NSData *)readfully {
    NSMutableData *result = [NSMutableData data];
    uint8_t buffer[4096] = {0};
    
    [self open];
    NSInteger amount = 0;
    do {
        amount = [self read:buffer maxLength:4096];
        if (amount > 0) {
            NSData *data = [NSData dataWithBytes:buffer length:amount];
            [result appendData:data];
        }
    } while (amount > 0);
    
    [self close];
    
    return result;
}

@end
