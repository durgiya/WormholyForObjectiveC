//
//  WHRequestModelBeautifier.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHRequestModel.h"

typedef NS_ENUM(NSUInteger, WHRequestResponseExportOption) {
    WHRequestResponseExportOptionFlat,
    WHRequestResponseExportOptionCurl,
    WHRequestResponseExportOptionPostman,
};

NS_ASSUME_NONNULL_BEGIN

@interface WHRequestModelBeautifier : NSObject

+ (NSMutableAttributedString *)overview:(WHRequestModel *)request;
+ (NSString *)stringWithDate:(NSDate *)date;
+ (NSDateFormatter *)defaultDateFormatter;
+ (NSMutableAttributedString *)header:(NSDictionary<NSString *, NSString *> *)headers;
+ (NSString *)body:(NSData *)body splitLength:(NSInteger)splitLength;
+ (void)body:(NSData *)body splitLength:(NSInteger)splitLength completion:(void (^)(NSString *))completion;
+ (NSString *)txtExport:(WHRequestModel *)request;
+ (NSString *)curlExport:(WHRequestModel *)request;

@end

NS_ASSUME_NONNULL_END
