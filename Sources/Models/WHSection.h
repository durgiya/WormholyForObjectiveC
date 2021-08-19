//
//  WHSection.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WHSectionType) {
    WHSectionTypeOverview,
    WHSectionTypeRequestHeader,
    WHSectionTypeRequestBody,
    WHSectionTypeResponseHeader,
    WHSectionTypeResponseBody,
};

NS_ASSUME_NONNULL_BEGIN

@interface WHSection : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) WHSectionType type;

- (instancetype)initWithName:(NSString *)name type:(WHSectionType)type;

@end

NS_ASSUME_NONNULL_END
