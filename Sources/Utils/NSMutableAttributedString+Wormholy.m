//
//  NSMutableAttributedString+Wormholy.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "NSMutableAttributedString+Wormholy.h"

@implementation NSMutableAttributedString (Wormholy)

- (NSMutableAttributedString *)bold:(NSString *)text {
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15]};
    NSMutableAttributedString *boldString = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
    [self appendAttributedString:boldString];
    return self;
}

- (NSMutableAttributedString *)normal:(NSString *)text {
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    NSMutableAttributedString *normal = [[NSMutableAttributedString alloc] initWithString:text attributes:attrs];
    [self appendAttributedString:normal];
    return self;
}

- (NSMutableAttributedString *)chageTextColor:(UIColor *)toColor {
    NSRange range = NSMakeRange(0, self.string.length);
    [self addAttributes:@{NSForegroundColorAttributeName: toColor} range:range];
    return self;
}

@end
