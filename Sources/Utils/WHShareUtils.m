//
//  WHShareUtils.m
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import "WHShareUtils.h"
#import <UIKit/UIKit.h>


@implementation WHShareUtils

+ (void)shareRequests:(UIViewController *)presentingViewController
               sender:(UIBarButtonItem *)sender
             requests:(NSArray *)requests
  requestExportOption:(WHRequestResponseExportOption)requestExportOption {
    NSString *text = @"";
    switch (requestExportOption) {
        case WHRequestResponseExportOptionFlat:
            text = [self getTxtText:requests];
            break;
        case WHRequestResponseExportOptionCurl:
            text = [self getCurlText:requests];
            break;
        case WHRequestResponseExportOptionPostman:
            break;
    }
    
    if (text == nil) {
        text = @"";
    }
    
    NSArray *textShare = @[text];
    UIImage *image = [UIImage imageNamed:@"activity_icon" inBundle:[WHBundle bundle] compatibleWithTraitCollection:nil];
    WHCustomActivity *customItem = [[WHCustomActivity alloc] initWithTitle:@"Save to the desktop" image:image performAction:^(NSArray * sharedItems) {
        NSArray<NSString *> *sharedStrings = sharedItems;
        if (sharedStrings.count == 0) {
            return;
        }
        
        NSString *appName = [[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleName"];
        NSDateFormatter *dateFormatterGet = [[NSDateFormatter alloc] init];
        [dateFormatterGet setDateFormat:@"yyyyMMdd_HHmmss_SSS"];
        
        NSString *suffix = @"";
        switch (requestExportOption) {
            case WHRequestResponseExportOptionFlat:
                suffix = @"-wormholy.txt";
                break;
            case WHRequestResponseExportOptionCurl:
                suffix = @"-wormholy.txt";
                break;
            case WHRequestResponseExportOptionPostman:
                suffix = @"-postman_collection.json";
                break;
        }
        
        NSString *date = [dateFormatterGet stringFromDate:[NSDate date]];
        NSString *filename = [NSString stringWithFormat:@"%@_%@%@", appName, date, suffix];
        
        for (NSString *string in sharedStrings) {
            [WHFileHandler writeTxtFileOnDesktop:string fileName:filename];
        }
    }];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:textShare applicationActivities:@[customItem]];
    activityViewController.popoverPresentationController.barButtonItem = sender;
    [presentingViewController presentViewController:activityViewController animated:YES completion:nil];
}

+ (NSString *)getTxtText:(NSArray<WHRequestModel *> *)requests {
    NSString *text = @"";
    for (WHRequestModel *request in requests) {
        text = [text stringByAppendingString:[WHRequestModelBeautifier txtExport:request]];
    }
    
    return text;
}

+ (NSString *)getCurlText:(NSArray<WHRequestModel *> *)requests {
    NSString *text = @"";
    for (WHRequestModel *request in requests) {
        text = [text stringByAppendingString:[WHRequestModelBeautifier curlExport:request]];
    }
    
    return text;
}

@end
