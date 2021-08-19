//
//  WHWormholy.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/15.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHWormholy.h"
#import "WHCustomHTTPProtocol.h"
#import "WHStorage.h"
#import "UIViewController+Wormholy.h"
#import "WHBaseViewController.h"
#import "WHNavigationController.h"
#import "WHBundle.h"

NSString *const fireWormholy = @"wormholy_fire";
static BOOL g_shakeEnabled = YES;

@implementation WHWormholy

+ (void)load {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"wormholy_fire" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [WHWormholy presentWormholyFlow];
    }];
    
    [WHWormholy setupShakeEnabled];
    [WHWormholy enable:YES];
}

+ (NSArray<NSString *> *)ignoredHosts {
    return WHCustomHTTPProtocol.ignoredHosts;
}

+ (void)setIgnoredHosts:(NSArray<NSString *> *)ignoredHosts {
    WHCustomHTTPProtocol.ignoredHosts = ignoredHosts;
}

+ (void)setLimit:(NSNumber *)limit {
    [WHStorage sharedInstance].limit = limit;
}

+ (NSNumber *)limit {
    return [WHStorage sharedInstance].limit;
}

+ (void)enable:(BOOL)enable {
    if (enable) {
        [NSURLProtocol registerClass:WHCustomHTTPProtocol.class];
    } else {
        [NSURLProtocol unregisterClass:WHCustomHTTPProtocol.class];
    }
}

+ (void)presentWormholyFlow {
    if ([[UIViewController currentViewController:nil] isKindOfClass:WHBaseViewController.class] || [[UIViewController currentViewController:nil] isKindOfClass:WHNavigationController.class]) {
        return;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Flow" bundle:[WHBundle bundle]];
    UIViewController *initialVC = [storyboard instantiateInitialViewController];
    if (initialVC) {
        initialVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [[UIViewController currentViewController:nil] presentViewController:initialVC animated:YES completion:nil];
    }
}

+ (void)setupShakeEnabled {
    NSString *key = @"WORMHOLY_SHAKE_ENABLED";
    NSString *environmentVariable = [[NSProcessInfo processInfo].environment valueForKey:key];
    if (environmentVariable) {
        WHWormholy.shakeEnabled = ![environmentVariable isEqual:@"NO"];
        return;
    }
    
    NSDictionary *arguments = [[NSUserDefaults standardUserDefaults] volatileDomainForName:NSArgumentDomain];
    id arg = [arguments valueForKey:key];
    if ([arg respondsToSelector:@selector(boolValue)]) {
        WHWormholy.shakeEnabled =  [arg boolValue];
        return;
    }
    
    WHWormholy.shakeEnabled = YES;
}

// MARK: - Navigation

+ (UIViewController *)wormholyFlow {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Flow" bundle:[WHBundle bundle]];
    return [storyboard instantiateInitialViewController];
}

+ (void)setShakeEnabled:(BOOL)shakeEnabled {
    g_shakeEnabled = shakeEnabled;
}

+ (BOOL)shakeEnabled {
    return g_shakeEnabled;
}

@end
