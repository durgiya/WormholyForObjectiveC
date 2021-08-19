//
//  UIViewController+Wormholy.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/14.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Wormholy)

+ (nullable UIViewController *)currentViewController:(nullable UIViewController *)viewController;

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event;

@end

NS_ASSUME_NONNULL_END
