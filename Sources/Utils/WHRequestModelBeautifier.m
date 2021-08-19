//
//  WHRequestModelBeautifier.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHRequestModelBeautifier.h"
#import "WHRequestModel.h"
#import "NSMutableAttributedString+Wormholy.h"
#import "NSDictionary+Wormholy.h"
#import "NSString+Wormholy.h"

@implementation WHRequestModelBeautifier

+ (NSMutableAttributedString *)overview:(WHRequestModel *)request {
    NSMutableAttributedString *url = [[[[NSMutableAttributedString alloc] init] bold:@"URL "] normal:[NSString stringWithFormat:@"%@\n", request.url]];
    NSMutableAttributedString *method = [[[[NSMutableAttributedString alloc] init] bold:@"Method "] normal:[NSString stringWithFormat:@"%@\n", request.method]];
    NSString *codeString = @"-";
    if (request.code != 0) {
        codeString = [NSString stringWithFormat:@"%zd", request.code];
    }
    
    NSMutableAttributedString *responseCode = [[[[NSMutableAttributedString alloc] init] bold:@"Response Code "] normal:[NSString stringWithFormat:@"%@\n", codeString]];
    
    
    NSString *requestStartTimeString = [self stringWithDate:request.date];
    if (requestStartTimeString.length == 0) {
        requestStartTimeString = @"-";
    }

    NSMutableAttributedString *requestStartTime = [[[[NSMutableAttributedString alloc] init] bold:@"Request Start Time "] normal:[NSString stringWithFormat:@"%@\n", requestStartTimeString]];
    
    NSString *durationString = [NSString formattedMilliseconds:request.duration];
    if (durationString.length == 0) {
        durationString = @"-";
    }
    
    NSMutableAttributedString *duration = [[[[NSMutableAttributedString alloc] init] bold:@"Duration "] normal:[NSString stringWithFormat:@"%@\n", durationString]];
    
    NSMutableAttributedString *final = [[NSMutableAttributedString alloc] init];
    [final appendAttributedString:url];
    [final appendAttributedString:method];
    [final appendAttributedString:responseCode];
    [final appendAttributedString:requestStartTime];
    [final appendAttributedString:duration];
    return final;
}

+ (NSString *)stringWithDate:(NSDate *)date {
    NSString *destDateString = [[self defaultDateFormatter] stringFromDate:date];
    return destDateString;
}

+ (NSDateFormatter *)defaultDateFormatter {
    static NSDateFormatter *staticDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        staticDateFormatter=[[NSDateFormatter alloc] init];
        // zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
        [staticDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    });
    
    return staticDateFormatter;
}

+ (NSMutableAttributedString *)header:(NSDictionary<NSString *, NSString *> *)headers {
    if (headers.allKeys.count == 0) {
        return [[NSMutableAttributedString alloc] initWithString:@"-"];
    }
    
    NSMutableAttributedString *final = [[NSMutableAttributedString alloc] init];
    
    [headers enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableAttributedString *tmp = [[[[NSMutableAttributedString alloc] init] bold:key] normal:[NSString stringWithFormat:@" %@\n", obj]];
        [final appendAttributedString:tmp];
    }];
    
    return final;
}

+ (NSString *)body:(NSData *)body splitLength:(NSInteger)splitLength {
    if (body.length == 0) {
        return @"-";
    }
    
    NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
    if (splitLength > 0) {
        bodyString = [bodyString substringToIndex:splitLength];
    }
    
    NSString *pretty = [bodyString prettyPrintedJSON];
    if (pretty.length > 0) {
        return pretty;
    }
    
    return @"-";
}

+ (void)body:(NSData *)body splitLength:(NSInteger)splitLength completion:(void (^)(NSString *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *string = [self body:body splitLength:splitLength];
        if (completion) {
            completion(string);
        }
    });
}

+ (NSString *)txtExport:(WHRequestModel *)request {
    NSString *txt = @"";
    
    txt = [txt stringByAppendingString:@"*** Overview *** \n"];
    NSString *overview = [self overview:request].string;
    txt = [txt stringByAppendingFormat:@"%@\n\n", overview];
    
    txt = [txt stringByAppendingString:@"*** Request Header *** \n"];
    NSString *header = [self header:request.headers].string;
    txt = [txt stringByAppendingFormat:@"%@\n\n", header];
    
    txt = [txt stringByAppendingString:@"*** Request Body *** \n"];
    NSString *body = [self body:request.httpBody splitLength:0];
    txt = [txt stringByAppendingFormat:@"%@\n\n", body];
    
    txt = [txt stringByAppendingString:@"*** Response Header *** \n"];
    NSString *responseHeaders = [self header:request.responseHeaders].string;
    txt = [txt stringByAppendingFormat:@"%@\n\n", responseHeaders];
    
    txt = [txt stringByAppendingString:@"*** Response Body *** \n"];
    NSString *dataResponse = [self body:request.dataResponse splitLength:0];
    txt = [txt stringByAppendingFormat:@"%@\n\n", dataResponse];
    
    txt = [txt stringByAppendingString:@"------------------------------------------------------------------------\n"];
    txt = [txt stringByAppendingString:@"------------------------------------------------------------------------\n"];
    txt = [txt stringByAppendingString:@"------------------------------------------------------------------------\n\n\n\n"];
    
    return txt;
}

+ (NSString *)curlExport:(WHRequestModel *)request {
    NSString *txt = @"";
    
    txt = [txt stringByAppendingString:@"*** Overview *** \n"];
    NSString *overview = [self overview:request].string;
    txt = [txt stringByAppendingFormat:@"%@\n\n", overview];
    
    txt = [txt stringByAppendingString:@"*** curl Request *** \n"];
    txt = [txt stringByAppendingFormat:@"%@\n\n", [request curlRequest]];
    
    txt = [txt stringByAppendingString:@"*** Response Header *** \n"];
    NSString *responseHeaders = [self header:request.responseHeaders].string;
    txt = [txt stringByAppendingFormat:@"%@\n\n", responseHeaders];
    
    txt = [txt stringByAppendingString:@"*** Response Body *** \n"];
    NSString *dataResponse = [self body:request.dataResponse splitLength:0];
    txt = [txt stringByAppendingFormat:@"%@\n\n", dataResponse];
    
    txt = [txt stringByAppendingString:@"------------------------------------------------------------------------\n"];
    txt = [txt stringByAppendingString:@"------------------------------------------------------------------------\n"];
    txt = [txt stringByAppendingString:@"------------------------------------------------------------------------\n\n\n\n"];
    
    return txt;
}

@end
