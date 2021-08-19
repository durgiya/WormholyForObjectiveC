//
//  WHTextView.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/13.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHTextView.h"

@implementation WHTextView

- (NSMutableArray<NSTextCheckingResult *> *)highlights:(NSString *)text
                                                 color:(UIColor *)color
                                                  font:(UIFont *)font
                                       highlightedFont:(UIFont *)highlightedFont {
    if (color == nil) {
        color = [UIColor greenColor];
    }
    
    if (font == nil) {
        font = [UIFont systemFontOfSize:14];
    }
    
    if (highlightedFont == nil) {
        highlightedFont = [UIFont boldSystemFontOfSize:14];
    }
    
    NSString *keywordSearch = [text lowercaseString];
    NSString *textViewText = [self.text lowercaseString];
    if (keywordSearch.length == 0 || textViewText.length == 0) {
        return [NSMutableArray array];
    }
    
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:textViewText];
    [attributed addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.attributedText.length)];
    
    NSError *error = nil;
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:keywordSearch options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        return [NSMutableArray array];
    }
    
    NSArray<NSTextCheckingResult *> *matches = [regex matchesInString:textViewText options:NSMatchingReportProgress range:NSMakeRange(0, textViewText.length)];
    [matches enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [attributed addAttribute:NSBackgroundColorAttributeName value:color range:obj.range];
        [attributed addAttribute:NSFontAttributeName value:highlightedFont range:obj.range];
    }];
    
    return [matches mutableCopy];
}

- (nullable UITextRange *)convertRange:(NSRange)range {
    UITextPosition *beginning = self.beginningOfDocument;
    UITextPosition *start = [self positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [self positionFromPosition:start offset:range.length];
    if (start && end) {
        return [self textRangeFromPosition:start toPosition:end];
    }
    
    return nil;
}

@end
