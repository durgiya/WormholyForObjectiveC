//
//  UIViewController+Wormholy.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/14.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "UIViewController+Wormholy.h"
#import "WHWormholy.h"

@implementation UIViewController (Wormholy)

+ (nullable UIViewController *)currentViewController:(nullable UIViewController *)viewController {
    if (viewController == nil) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        if (viewController == nil) {
            return nil;
        }
    }
    
    if ([viewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *naviVC = (UINavigationController *)viewController;
        if (naviVC.visibleViewController) {
            return [self currentViewController:naviVC.visibleViewController];
        } else {
            return [self currentViewController:naviVC.topViewController];
        }
    } else if ([viewController isKindOfClass:UITabBarController.class]) {
        UITabBarController *tabBarVC = (UITabBarController *)viewController;
        if (tabBarVC.viewControllers.count > 5 && tabBarVC.selectedIndex >= 4) {
            return [self currentViewController:tabBarVC.moreNavigationController];
        } else {
            return [self currentViewController:tabBarVC.selectedViewController];
        }
    } else if (viewController.presentedViewController) {
        return [self currentViewController:viewController.presentedViewController];
    } else if (viewController.childViewControllers.count > 0) {
        return viewController.childViewControllers.firstObject;
    } else {
        return viewController;
    }
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake && WHWormholy.shakeEnabled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"wormholy_fire" object:nil];
    }
    
    [self.nextResponder motionBegan:motion withEvent:event];
}

@end
