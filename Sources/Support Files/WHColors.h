//
//  WHColors.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHColors : NSObject

@property (nonatomic, strong, class, readonly) UIColor *uiWordsInEvidence;
@property (nonatomic, strong, class, readonly) UIColor *uiWordFocus;

@property (nonatomic, strong, class, readonly) UIColor *drayDarkestGray;
@property (nonatomic, strong, class, readonly) UIColor *drayDarkerGray;
@property (nonatomic, strong, class, readonly) UIColor *drayDarkGray;
@property (nonatomic, strong, class, readonly) UIColor *drayMidGray;
@property (nonatomic, strong, class, readonly) UIColor *drayLightGray;
@property (nonatomic, strong, class, readonly) UIColor *drayLighestGray;

@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeSuccess;
@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeRedirect;
@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeClientError;
@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeServerError;
@property (nonatomic, strong, class, readonly) UIColor *HTTPCodeGeneric;

@end

NS_ASSUME_NONNULL_END
