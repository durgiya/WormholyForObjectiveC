//
//  WHFileHandler.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/13.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHFileHandler : NSObject

+ (void)writeTxtFile:(NSString *)text path:(NSString *)path;
+ (void)writeTxtFileOnDesktop:(NSString *)text fileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
