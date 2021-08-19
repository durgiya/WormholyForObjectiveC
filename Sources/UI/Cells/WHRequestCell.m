//
//  WHRequestCell.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHRequestCell.h"
#import "WHColors.h"
#import "NSString+Wormholy.h"

@implementation WHRequestCell

- (void)populate:(WHRequestModel *)request {
    if (request == nil) {
        return;
    }
    
    self.methodLabel.text = request.method.uppercaseString;
    self.codeLabel.hidden = request.code == 0 ? YES : NO;
    self.codeLabel.text = request.code != 0 ? [NSString stringWithFormat:@"%zd", request.code] : @"-";
    
    NSLog(@"self.codeLabel.text = %@", self.codeLabel.text);
    
    UIColor *color = [WHColors HTTPCodeGeneric];
    if (request.code >= 200 && request.code < 300) {
        color = WHColors.HTTPCodeSuccess;
    } else if (request.code >= 300 && request.code < 400) {
        color = WHColors.HTTPCodeRedirect;
    } else if (request.code >= 400 && request.code < 500) {
        color = WHColors.HTTPCodeClientError;
    } else if (request.code >= 500 && request.code < 600) {
        color = WHColors.HTTPCodeServerError;
    }
    
    self.codeLabel.borderColor = color;
    self.codeLabel.textColor = color;
    
    self.urlLabel.text = request.url;
    self.durationLabel.text = [NSString formattedMilliseconds:request.duration];
}

@end
