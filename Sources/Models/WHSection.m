//
//  WHSection.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHSection.h"

@implementation WHSection

- (instancetype)initWithName:(NSString *)name type:(WHSectionType)type {
    if (self = [super init]) {
        self.name = name;
        self.type = type;
    }
    
    return self;
}

@end
