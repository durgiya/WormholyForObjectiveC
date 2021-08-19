//
//  WHTextView.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/13.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHTextView : UITextView

- (NSMutableArray<NSTextCheckingResult *> *)highlights:(NSString *)text
                                                 color:(UIColor *)color
                                                  font:(UIFont *)font
                                       highlightedFont:(UIFont *)highlightedFont;

- (nullable UITextRange *)convertRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
