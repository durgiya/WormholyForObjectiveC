//
//  WHBundle.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/13.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHBundle.h"

@implementation WHBundle

+ (NSBundle *)bundle {
    NSBundle *podBundle = [NSBundle bundleForClass:WHBundle.class];
    NSURL *bundleURL = [podBundle URLForResource:@"Wormholy" withExtension:@"bundle"];
    if (bundleURL) {
        NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
        return bundle;
    }
    
    return podBundle;
}

@end
