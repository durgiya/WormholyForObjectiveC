//
//  WHRequestModel.h
//  Wormholy-iOS
//
//  Created by durgiya on 2021/8/12.
//  Copyright © 2021 Wormholy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WHRequestModel : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSNumber *port;
@property (nonatomic, copy) NSString *scheme;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *method;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *headers;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *credentials;
@property (nonatomic, copy) NSString *cookies;
@property (nonatomic, strong) NSData *httpBody;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *responseHeaders;
@property (nonatomic, strong) NSMutableData *dataResponse;
@property (nonatomic, copy) NSString *errorClientDescription;
@property (nonatomic, assign) double duration;


- (instancetype)initWithRequest:(NSURLRequest *)request session:(NSURLSession *)session;
- (instancetype)initWithResponse:(NSURLResponse *)response;
- (NSString *)curlRequest;
- (void)setupResponse:(NSURLResponse *)response;

@end

NS_ASSUME_NONNULL_END
