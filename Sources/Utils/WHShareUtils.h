//
//  WHShareUtils.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHRequestModelBeautifier.h"
#import "WHRequestModel.h"
#import "NSMutableAttributedString+Wormholy.h"
#import "NSDictionary+Wormholy.h"
#import "NSString+Wormholy.h"
#import "WHCustomActivity.h"
#import "WHBundle.h"
#import "WHFileHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface WHShareUtils : NSObject

+ (void)shareRequests:(UIViewController *)presentingViewController
               sender:(UIBarButtonItem *)sender
             requests:(NSArray *)requests
  requestExportOption:(WHRequestResponseExportOption)requestExportOption;
+ (NSString *)getTxtText:(NSArray<WHRequestModel *> *)requests;
+ (NSString *)getCurlText:(NSArray<WHRequestModel *> *)requests;

@end

NS_ASSUME_NONNULL_END
