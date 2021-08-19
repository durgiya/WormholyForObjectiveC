//
//  NSMutableAttributedString+Wormholy.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (Wormholy)

- (NSMutableAttributedString *)bold:(NSString *)text;

- (NSMutableAttributedString *)normal:(NSString *)text;

- (NSMutableAttributedString *)chageTextColor:(UIColor *)toColor;

@end

NS_ASSUME_NONNULL_END
