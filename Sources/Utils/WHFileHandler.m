//
//  WHFileHandler.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/13.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHFileHandler.h"

@implementation WHFileHandler

+ (void)writeTxtFile:(NSString *)text path:(NSString *)path {
    [[NSFileManager defaultManager] createFileAtPath:path contents:[text dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}

+ (void)writeTxtFileOnDesktop:(NSString *)text fileName:(NSString *)fileName {
    NSArray *components = [[@"~" stringByExpandingTildeInPath] componentsSeparatedByString:@"/"];
    NSString *homeUser = @"-";
    if (components.count > 2) {
        homeUser = [components objectAtIndex:2];
    }

    NSString *path = [NSString stringWithFormat:@"Users/%@/Desktop/%@", homeUser, fileName];
    [self writeTxtFile:text path:path];
}

@end
