//
//  NSString+Wormholy.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "NSString+Wormholy.h"

@implementation NSString (Wormholy)

- (NSString *)prettyPrintedJSON {
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonString = [self responseJSONFromData:stringData];
    [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    return jsonString;
}

- (NSString *)responseJSONFromData:(NSData *)data {
    if (data == nil) return nil;
    NSError *error = nil;
    id returnValue = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if(error) {
        NSLog(@"JSON Parsing Error: %@", error);
        return nil;
    }
    
    if (!returnValue || returnValue == [NSNull null]) {
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnValue options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)formattedMilliseconds:(double)rounded {
    if (rounded < 1000) {
        return [NSString stringWithFormat:@"%zdms", (long)rounded];
    } else if (rounded < 1000 * 60) {
        double seconds = rounded / 1000;
        return [NSString stringWithFormat:@"%zds", (long)seconds];
    } else if (rounded < 1000 * 60 * 60) {
        double secondsTemp = rounded / 1000;
        double minutes = secondsTemp / 60;
        double seconds = (rounded - minutes * 60 * 1000) / 1000;
        return [NSString stringWithFormat:@"%zdm %zds", (long)minutes, (long)seconds];
    } else if (rounded < 1000 * 60 * 60 * 24) {
        double minutesTemp = rounded / 1000 / 60;
        double hours = minutesTemp / 60;
        double minutes = (rounded - hours * 60 * 60 * 1000) / 1000 / 60;
        double seconds = (rounded - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000;
        return [NSString stringWithFormat:@"%zdh %zdm %zds", (long)hours, (long)minutes, (long)seconds];
    } else {
        double hoursTemp = rounded / 1000 / 60 / 60;
        double days = hoursTemp / 24;
        double hours = (rounded - days * 24 * 60 * 60 * 1000) / 1000 / 60 / 60;
        double minutes = (rounded - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000) / 1000 / 60;
        double seconds = (rounded - days * 24 * 60 * 60 * 1000 - hours * 60 * 60 * 1000 - minutes * 60 * 1000) / 1000;
        return [NSString stringWithFormat:@"%zdd %zdh %zdm %zds", (long)days, (long)hours, (long)minutes, (long)seconds];
    }
}

@end
