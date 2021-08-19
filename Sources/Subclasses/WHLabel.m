//
//  WHLabel.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/13.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHLabel.h"

@implementation WHLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.borderColor = [UIColor clearColor];
        self.borderWidth = 0.0;
        self.cornerRadius = 0.0;
        self.padding = 0.0;
        
        [self customize];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self customize];
}

- (void)prepareForInterfaceBuilder {
    [self customize];
}

- (void)customize {
    self.layer.masksToBounds = YES;
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.layer.cornerRadius = self.cornerRadius;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    UIEdgeInsets insets = self.textInsets;
    CGRect insetRect = UIEdgeInsetsInsetRect(bounds, insets);
    CGRect textRect = [super textRectForBounds:insetRect limitedToNumberOfLines:numberOfLines];
    insets = UIEdgeInsetsMake(-insets.top, -insets.left, -insets.bottom, -insets.right);
    return UIEdgeInsetsInsetRect(textRect, insets);;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.textInsets)];
}

- (void)appendIconToLabel:(NSString *)imageName labelText:(NSString *)labelText bounds_x:(CGFloat)bounds_x bounds_y:(CGFloat)bounds_y boundsWidth:(CGFloat)boundsWidth boundsHeight:(CGFloat)boundsHeight {
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:imageName];
    attachment.bounds = CGRectMake(bounds_x, bounds_y, boundsWidth, boundsHeight);
    
    NSAttributedString *attachmentStr = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:labelText];
    [string appendAttributedString:attachmentStr];
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@""];
    [string appendAttributedString:string2];
    self.attributedText = string;
}

#pragma mark - setter && getter

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    
    self.textInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
}

- (void)setTextInsets:(UIEdgeInsets)textInsets {
    _textInsets = textInsets;
    
    [self invalidateIntrinsicContentSize];
}

@end
